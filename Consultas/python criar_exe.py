import PyInstaller.__main__
import customtkinter
import os

# 1. Pega o caminho onde o customtkinter está instalado no seu PC
# Isso é necessário para incluir os temas e imagens da biblioteca no executável
caminho_ctk = os.path.dirname(customtkinter.__file__)

# 2. Configura e roda o PyInstaller
print("Iniciando a criação do executável...")

PyInstaller.__main__.run([
    'buscador.py',                          # Nome do seu arquivo principal
    '--name=ScriptHunter',                  # Nome que o .exe terá
    '--onefile',                            # Cria um arquivo único (.exe) em vez de uma pasta cheia de coisas
    '--noconsole',                          # Não mostra aquela janela preta de terminal ao abrir
    f'--add-data={caminho_ctk};customtkinter', # Copia os dados do customtkinter (Essencial no Windows)
    '--clean',                              # Limpa arquivos temporários antigos
])

print("\n\n✅ SUCESSO! Seu executável foi criado.")
print("👉 Verifique a pasta 'dist' que apareceu no seu projeto.")