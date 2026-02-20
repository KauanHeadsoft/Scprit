import os
import sys
import ctypes
import psutil
import subprocess
import time
import threading
import ttkbootstrap as ttk
from ttkbootstrap.constants import *
from ttkbootstrap.scrolled import ScrolledFrame
from tkinter import messagebox

# --- CONFIGURAÇÕES ---
PASTA_LOGINS = r"C:\Users\Kauan Lauer\Desktop\Logins"
PORTA_CONFLITO = 53232

def is_admin():
    try:
        return ctypes.windll.shell32.IsUserAnAdmin()
    except:
        return False

# Força execução como Admin para o comando netsh funcionar
if not is_admin():
    ctypes.windll.shell32.ShellExecuteW(None, "runas", sys.executable, f'"{__file__}"', None, 1)
    sys.exit()

class SmartLauncher(ttk.Window):
    def __init__(self):
        super().__init__(themename="darkly")
        self.title("HeadCargo Multi-Client Dashboard")
        self.geometry("900x650")
        self.protocol("WM_DELETE_WINDOW", self.quit)
        
        self.busca_var = ttk.StringVar()
        self.busca_var.trace("w", self.filtrar)
        self.botoes = []

        self.montar_tela()
        self.carregar_atalhos()

    def montar_tela(self):
        # Header
        hdr = ttk.Frame(self, padding=20, bootstyle="secondary")
        hdr.pack(fill=X)
        
        ttk.Label(hdr, text="GERENCIADOR DE ACESSOS", font=("Impact", 20), bootstyle="inverse-secondary").pack(side=LEFT)
        
        # Busca
        bus_ent = ttk.Entry(hdr, textvariable=self.busca_var, width=30)
        bus_ent.pack(side=RIGHT, padx=10)
        ttk.Label(hdr, text="FILTRAR:", bootstyle="inverse-secondary").pack(side=RIGHT)

        # Container de Botões
        self.area_botoes = ScrolledFrame(self, autohide=True)
        self.area_botoes.pack(fill=BOTH, expand=YES, padx=10, pady=10)

        # Status Bar
        self.status = ttk.Label(self, text="Pronto.", font=("Consolas", 10), padding=5)
        self.status.pack(side=BOTTOM, fill=X)

    def carregar_atalhos(self):
        if not os.path.exists(PASTA_LOGINS): return
        
        arquivos = [f for f in os.listdir(PASTA_LOGINS) if f.lower().endswith('.lnk')]
        arquivos.sort()

        row, col = 0, 0
        for arq in arquivos:
            nome = arq.replace('.lnk', '')
            path = os.path.join(PASTA_LOGINS, arq)
            
            f = ttk.Frame(self.area_botoes.container, padding=5)
            f.grid(row=row, column=col, sticky="ew")
            
            btn = ttk.Button(f, text=nome.upper(), width=25, bootstyle="outline-info",
                             command=lambda p=path, n=nome: self.lancar(p, n))
            btn.pack(fill=X, ipady=5)
            
            self.botoes.append({"frame": f, "nome": nome.lower()})
            
            col += 1
            if col > 2: col = 0; row += 1

    def filtrar(self, *args):
        b = self.busca_var.get().lower()
        for i in self.botoes:
            i["frame"].grid_remove() if b not in i["nome"] else i["frame"].grid()

    def lancar(self, caminho, nome):
        threading.Thread(target=self._executar, args=(caminho, nome), daemon=True).start()

    def _executar(self, caminho, nome):
        self.status.config(text=f"Limpando porta para {nome}...", bootstyle="warning")
        
        # AÇÃO CIRÚRGICA: Só mata quem está na porta 53232
        try:
            for conn in psutil.net_connections(kind='tcp'):
                if conn.laddr.port == PORTA_CONFLITO:
                    psutil.Process(conn.pid).kill()
                    self.status.config(text="Porta 53232 liberada!", bootstyle="success")
                    break
        except: pass

        # Reset de socket silencioso (Oculto)
        si = subprocess.STARTUPINFO()
        si.dwFlags |= subprocess.STARTF_USESHOWWINDOW
        subprocess.run("netsh int ip reset", startupinfo=si, stdout=subprocess.DEVNULL)

        # Abre o sistema sem fechar os outros
        try:
            os.startfile(caminho)
            self.status.config(text=f"Sistema {nome} iniciado com sucesso!", bootstyle="success")
        except:
            messagebox.showerror("Erro", f"Não abriu o atalho de {nome}")

if __name__ == "__main__":
    SmartLauncher().mainloop()