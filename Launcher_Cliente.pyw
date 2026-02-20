import os
import sys
import ctypes
import psutil
import subprocess
import threading
import time
import ttkbootstrap as ttk
from ttkbootstrap.constants import *
from ttkbootstrap.scrolled import ScrolledText
from tkinter import filedialog, messagebox
import win32com.client # Necessário para criar o atalho

# --- CONFIGURAÇÕES ---
PORTA_ALVO = 53232
NOME_PADRAO = "desktop.exe"
ARQUIVO_CONFIG = "config_launcher.txt" # Arquivo simples para salvar o caminho

# --- VERIFICAÇÃO DE ADM ---
def is_admin():
    try: return ctypes.windll.shell32.IsUserAnAdmin()
    except: return False

if not is_admin():
    if getattr(sys, 'frozen', False):
        ctypes.windll.shell32.ShellExecuteW(None, "runas", sys.executable, None, None, 1)
    else:
        ctypes.windll.shell32.ShellExecuteW(None, "runas", sys.executable, f'"{__file__}"', None, 1)
    sys.exit()

class LauncherTecnico(ttk.Window):
    def __init__(self):
        super().__init__(themename="cyborg")
        self.title("Launcher Diagnóstico HeadCargo")
        self.geometry("600x450")
        self.place_window_center()
        
        self.caminho_sistema = self.carregar_configuracao()
        self.montar_tela()
        
        # Se não tiver caminho configurado, pede na hora
        if not self.caminho_sistema:
            self.after(500, self.selecionar_manual)

    def montar_tela(self):
        # Cabeçalho
        ttk.Label(self, text="GERENCIADOR DE PORTA 53232", font=("Impact", 18), bootstyle="warning").pack(pady=(15,5))
        
        # Log simplificado
        self.log_widget = ScrolledText(self, padding=10, height=10, autohide=True, font=("Consolas", 9))
        self.log_widget.pack(fill=BOTH, expand=YES, padx=15, pady=5)
        
        # Botões Principais
        frame_btn = ttk.Frame(self)
        # CORREÇÃO AQUI: Trocado 'padding' (inválido) por 'padx' e 'pady'
        frame_btn.pack(fill=X, padx=15, pady=15)
        
        self.btn_limpar = ttk.Button(
            frame_btn, 
            text="⚡ LIMPAR PORTA E INICIAR", 
            bootstyle="success", 
            command=self.iniciar_processo
        )
        self.btn_limpar.pack(side=LEFT, fill=X, expand=YES, padx=(0, 5))
        
        self.btn_atalho = ttk.Button(
            frame_btn, 
            text="📌 CRIAR ATALHO", 
            bootstyle="info-outline", 
            command=self.criar_atalho_desktop
        )
        self.btn_atalho.pack(side=RIGHT, padx=(5, 0))

        # Botão discreto para trocar o arquivo se precisar
        ttk.Button(self, text="Trocar arquivo executável", bootstyle="link", command=self.selecionar_manual).pack(pady=5)

    def log(self, texto):
        timestamp = time.strftime("%H:%M:%S")
        self.log_widget.text.insert(END, f"[{timestamp}] {texto}\n")
        self.log_widget.text.see(END)

    def carregar_configuracao(self):
        """Tenta carregar o caminho salvo ou achar na pasta atual."""
        # 1. Tenta ler do arquivo de config
        if os.path.exists(ARQUIVO_CONFIG):
            with open(ARQUIVO_CONFIG, "r") as f:
                path = f.read().strip()
                if os.path.exists(path):
                    return path
        
        # 2. Tenta achar na pasta local
        local_exe = os.path.join(os.path.dirname(os.path.abspath(__file__)), NOME_PADRAO)
        if os.path.exists(local_exe):
            return local_exe
            
        return None

    def salvar_configuracao(self, path):
        with open(ARQUIVO_CONFIG, "w") as f:
            f.write(path)
        self.caminho_sistema = path

    def selecionar_manual(self):
        caminho = filedialog.askopenfilename(
            title="Selecione o executável do sistema (desktop.exe)",
            filetypes=[("Executável", "*.exe")]
        )
        if caminho:
            self.salvar_configuracao(caminho)
            self.log(f"Arquivo configurado: {caminho}")
            messagebox.showinfo("Configurado", "Caminho salvo! Agora você pode clicar em 'Limpar e Iniciar'.")
        else:
            self.log("Seleção cancelada.")

    def iniciar_processo(self):
        if not self.caminho_sistema or not os.path.exists(self.caminho_sistema):
            messagebox.showwarning("Atenção", "Selecione o arquivo desktop.exe primeiro!")
            self.selecionar_manual()
            return
            
        threading.Thread(target=self.rotina_limpeza, daemon=True).start()

    def rotina_limpeza(self):
        self.btn_limpar.config(state=DISABLED)
        self.log("Verificando porta 53232...")
        
        # 1. Mata processo na porta
        porta_estava_presa = False
        try:
            for conn in psutil.net_connections(kind='tcp'):
                if conn.laddr.port == PORTA_ALVO:
                    proc = psutil.Process(conn.pid)
                    self.log(f"Porta presa por PID {proc.pid}. Derrubando...")
                    proc.kill()
                    porta_estava_presa = True
                    time.sleep(1)
                    break
        except Exception as e:
            self.log(f"Erro ao verificar porta: {e}")

        # 2. Reset de rede preventivo
        subprocess.run("netsh int ip reset", creationflags=0x08000000, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        
        if porta_estava_presa:
            self.log("Porta liberada com sucesso.")
        else:
            self.log("A porta já estava livre.")

        # 3. Pergunta ao usuário
        self.btn_limpar.config(state=NORMAL)
        resposta = messagebox.askyesno(
            "Porta Liberada", 
            "A porta 53232 está limpa e pronta.\nDeseja abrir o sistema agora?"
        )
        
        if resposta:
            self.log(f"Iniciando: {self.caminho_sistema}")
            try:
                os.startfile(self.caminho_sistema)
                time.sleep(2)
                self.quit() # Fecha o launcher se deu tudo certo
            except Exception as e:
                messagebox.showerror("Erro", f"Não foi possível abrir o sistema:\n{e}")

    def criar_atalho_desktop(self):
        """Cria um atalho na área de trabalho para este script/exe."""
        try:
            desktop = os.path.join(os.path.expanduser("~"), "Desktop")
            caminho_link = os.path.join(desktop, "Launcher HeadCargo.lnk")
            
            if getattr(sys, 'frozen', False):
                target = sys.executable
            else:
                target = os.path.abspath(__file__) # Se for script .pyw não cria atalho direto executável, mas funciona para teste

            shell = win32com.client.Dispatch("WScript.Shell")
            shortcut = shell.CreateShortCut(caminho_link)
            shortcut.Targetpath = target
            shortcut.WorkingDirectory = os.path.dirname(target)
            shortcut.save()
            
            messagebox.showinfo("Sucesso", f"Atalho criado na Área de Trabalho!\nUse este atalho para sempre liberar a porta antes de entrar.")
        except Exception as e:
            messagebox.showerror("Erro", f"Falha ao criar atalho: {e}")

if __name__ == "__main__":
    app = LauncherTecnico()
    app.mainloop()