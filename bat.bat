@echo off
color 0A
echo ==========================================
echo      GERADOR DE EXECUTAVEL AUTOMATICO
echo ==========================================
echo.
echo 1. Verificando e Instalando bibliotecas necessarias...
pip install pyinstaller ttkbootstrap psutil
echo.

echo 2. Criando o executavel...
echo Isso pode demorar alguns minutos. Aguarde...
echo.

:: --noconsole: Esconde a tela preta
:: --onefile: Cria um arquivo so
:: --clean: Limpa cache antigo
:: --collect-all: Importa os temas visuais do ttkbootstrap
pyinstaller --noconsole --onefile --clean --name="Launcher_HeadCargo" --collect-all ttkbootstrap "Launcher_Cliente.pyw"

echo.
echo 3. Limpando lixo da compilacao...
rmdir /s /q build
del /q *.spec

echo.
echo ==========================================
echo               CONCLUIDO!
echo ==========================================
echo.
echo O seu arquivo .exe esta dentro da pasta 'dist' que foi criada.
echo Pode pegar ele e colocar na pasta do cliente.
echo.
pause