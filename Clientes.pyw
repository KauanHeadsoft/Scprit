import os
import sys
import ctypes
import psutil
import subprocess
import threading
import time
import pythoncom # Necessário para corrigir o erro CoInitialize
import win32com.client
import ttkbootstrap as ttk
from ttkbootstrap.constants import *
# Correção do aviso de Deprecation (importando de widgets agora)
from ttkbootstrap.widgets import ToastNotification 
from tkinter import filedialog, simpledialog, messagebox

# --- CONFIGURAÇÕES DO SISTEMA ---
PASTA_LOGINS = r"C:\Users\Kauan Lauer\Desktop\Logins"
PASTA_ORIGEM = r"D:\OneDrive - headsoft.com.br\Documentos\Headsoft\Pastinha Clientes\Acessos Clientes"
PORTA_ALVO = 53232 

# --- FUNÇÕES ADMINISTRATIVAS ---
def is_admin():
    """Verifica se o programa está rodando como administrador."""
    try: return ctypes.windll.shell32.IsUserAnAdmin()
    except: return False

if not is_admin():
    ctypes.windll.shell32.ShellExecuteW(None, "runas", sys.executable, f'"{__file__}"', None, 1)
    sys.exit()

class LauncherModerno(ttk.Window):
    def __init__(self):
        super().__init__(themename="cyborg")
        self.title("HeadCargo Launcher 2.2 - Final")
        self.geometry("1000x700")
        self.place_window_center()
        
        # Variáveis
        self.busca_var = ttk.StringVar()
        self.busca_var.trace_add("write", self.filtrar_lista)
        self.clientes_cache = [] 

        self.configurar_layout()
        self.after(100, self.carregar_dados)

    def configurar_layout(self):
        container = ttk.Frame(self)
        container.pack(fill=BOTH, expand=YES)

        # --- SIDEBAR ---
        sidebar = ttk.Frame(container, bootstyle="secondary", padding=20, width=250)
        sidebar.pack(side=LEFT, fill=Y)
        
        lbl_logo = ttk.Label(sidebar, text="HEADCARGO", font=("Impact", 22), bootstyle="inverse-secondary")
        lbl_logo.pack(pady=(0, 5))
        lbl_sub = ttk.Label(sidebar, text="MANAGER V2", font=("Consolas", 10), bootstyle="inverse-secondary")
        lbl_sub.pack(pady=(0, 30))

        btn_add = ttk.Button(sidebar, text="➕ NOVO CLIENTE", bootstyle="success", width=20, command=self.importar_cliente)
        btn_add.pack(pady=10)

        btn_refresh = ttk.Button(sidebar, text="🔄 ATUALIZAR LISTA", bootstyle="info-outline", width=20, command=self.carregar_dados)
        btn_refresh.pack(pady=10)
        
        ttk.Separator(sidebar, bootstyle="secondary").pack(fill=X, pady=20)

        self.lbl_status = ttk.Label(sidebar, text="Pronto.", font=("Segoe UI", 9), bootstyle="inverse-secondary", wraplength=200)
        self.lbl_status.pack(side=BOTTOM, pady=20)
        
        self.progress = ttk.Progressbar(sidebar, mode='indeterminate', bootstyle="success-striped")
        
        # --- ÁREA PRINCIPAL ---
        main_area = ttk.Frame(container, padding=20)
        main_area.pack(side=RIGHT, fill=BOTH, expand=YES)

        search_frame = ttk.Frame(main_area)
        search_frame.pack(fill=X, pady=(0, 15))
        
        ttk.Label(search_frame, text="🔍 Buscar Cliente:", font=("Segoe UI", 10, "bold")).pack(side=LEFT, padx=(0, 10))
        ent_busca = ttk.Entry(search_frame, textvariable=self.busca_var, font=("Segoe UI", 11))
        ent_busca.pack(side=LEFT, fill=X, expand=YES)

        cols = ("nome", "caminho")
        self.tree = ttk.Treeview(
            main_area, 
            columns=cols, 
            show="headings", 
            bootstyle="info",
            selectmode="browse"
        )
        
        self.tree.heading("nome", text="NOME DO CLIENTE")
        self.tree.heading("caminho", text="ARQUIVO DE ORIGEM")
        self.tree.column("nome", width=300, anchor=W)
        self.tree.column("caminho", width=400, anchor=W)

        scrollbar = ttk.Scrollbar(main_area, orient=VERTICAL, command=self.tree.yview)
        self.tree.configure(yscroll=scrollbar.set)
        
        self.tree.pack(side=LEFT, fill=BOTH, expand=YES)
        scrollbar.pack(side=RIGHT, fill=Y)

        self.tree.bind("<Double-1>", self.ao_clicar_duplo)
        self.tree.bind("<Button-3>", self.abrir_menu_contexto)

    def carregar_dados(self):
        if not os.path.exists(PASTA_LOGINS):
            try: os.makedirs(PASTA_LOGINS)
            except: pass

        for item in self.tree.get_children():
            self.tree.delete(item)
        
        self.clientes_cache = []
        try:
            arquivos = [f for f in os.listdir(PASTA_LOGINS) if f.lower().endswith('.lnk')]
            arquivos.sort()

            for arq in arquivos:
                nome_display = arq.replace('.lnk', '').upper()
                caminho_completo = os.path.join(PASTA_LOGINS, arq)
                self.clientes_cache.append((nome_display, caminho_completo))
                self.tree.insert("", END, values=(nome_display, caminho_completo))
            
            self.lbl_status.config(text=f"{len(arquivos)} clientes carregados.")
        except Exception as e:
            self.lbl_status.config(text=f"Erro ao ler pasta: {e}")

    def filtrar_lista(self, *args):
        busca = self.busca_var.get().upper()
        for item in self.tree.get_children():
            self.tree.delete(item)   
        for nome, caminho in self.clientes_cache:
            if busca in nome:
                self.tree.insert("", END, values=(nome, caminho))

    def ao_clicar_duplo(self, event):
        selected_item = self.tree.selection()
        if not selected_item: return
        item_values = self.tree.item(selected_item, "values")
        # Inicia thread separada
        threading.Thread(target=self.executar_sistema, args=(item_values[1], item_values[0]), daemon=True).start()

    def executar_sistema(self, caminho_atalho, nome):
        # 1. CORREÇÃO CRÍTICA: Inicializa COM para esta thread
        pythoncom.CoInitialize()
        
        self.mostrar_loading(True)
        self.lbl_status.config(text=f"Verificando porta 53232...", bootstyle="warning")

        try:
            # 2. LÓGICA DE LIMPEZA DE PORTA (Permitido derrubar se necessário)
            porta_ocupada = False
            proc_para_matar = None

            for conn in psutil.net_connections(kind='tcp'):
                if conn.laddr.port == PORTA_ALVO:
                    porta_ocupada = True
                    try:
                        proc_para_matar = psutil.Process(conn.pid)
                    except: pass
                    break
            
            if porta_ocupada and proc_para_matar:
                self.lbl_status.config(text=f"Liberando porta (PID {proc_para_matar.pid})...", bootstyle="danger")
                try:
                    proc_para_matar.kill()
                    time.sleep(1) # Aguarda o SO processar o encerramento
                except Exception as e:
                    print(f"Erro ao matar processo: {e}")

            # 3. Limpeza de Rede Adicional
            subprocess.run("netsh int ip reset", creationflags=0x08000000, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
            
            # 4. Iniciar Sistema
            self.lbl_status.config(text=f"Iniciando {nome}...", bootstyle="success")
            os.startfile(caminho_atalho)
            
            toast = ToastNotification(
                title="Launcher HeadCargo",
                message=f"Sistema {nome} iniciado!",
                duration=3000,
                bootstyle="success"
            )
            toast.show_toast()
            self.lbl_status.config(text="Pronto.", bootstyle="secondary")

        except Exception as e:
            messagebox.showerror("Erro", f"Falha na execução: {e}")
            self.lbl_status.config(text="Erro.", bootstyle="danger")
        finally:
            # Finaliza a thread COM corretamente
            pythoncom.CoUninitialize()
            self.mostrar_loading(False)

    def mostrar_loading(self, mostrar):
        if mostrar:
            self.progress.pack(side=BOTTOM, fill=X, pady=5)
            self.progress.start(10)
        else:
            self.progress.stop()
            self.progress.pack_forget()

    def importar_cliente(self):
        caminho_exe = filedialog.askopenfilename(
            initialdir=PASTA_ORIGEM, title="Selecione o desktop.exe",
            filetypes=[("Executável", "desktop.exe"), ("Todos os EXE", "*.exe")]
        )
        if caminho_exe:
            nome_sugerido = os.path.basename(os.path.dirname(caminho_exe))
            nome_cliente = simpledialog.askstring("Novo Cliente", "Nome do Cliente:", initialvalue=nome_sugerido)
            if nome_cliente:
                try:
                    caminho_atalho = os.path.join(PASTA_LOGINS, f"{nome_cliente}.lnk")
                    shell = win32com.client.Dispatch('WScript.Shell')
                    shortcut = shell.CreateShortCut(caminho_atalho)
                    shortcut.Targetpath = caminho_exe
                    shortcut.WorkingDirectory = os.path.dirname(caminho_exe)
                    shortcut.IconLocation = caminho_exe
                    shortcut.save()
                    self.carregar_dados()
                    messagebox.showinfo("Sucesso", "Cliente adicionado!")
                except Exception as e:
                    messagebox.showerror("Erro", f"Falha: {e}")

    def abrir_menu_contexto(self, event):
        item = self.tree.identify_row(event.y)
        if item:
            self.tree.selection_set(item)
            menu = ttk.Menu(self, tearoff=0)
            menu.add_command(label="🗑️ Excluir Cliente", command=self.excluir_cliente)
            menu.post(event.x_root, event.y_root)

    def excluir_cliente(self):
        selected_item = self.tree.selection()
        if not selected_item: return
        item_values = self.tree.item(selected_item, "values")
        if messagebox.askyesno("Excluir", f"Remover {item_values[0]}?"):
            try:
                os.remove(item_values[1])
                self.carregar_dados()
            except Exception as e:
                messagebox.showerror("Erro", str(e))

if __name__ == "__main__":
    app = LauncherModerno()
    app.mainloop()