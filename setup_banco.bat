@echo off
echo ==============================================================
echo       Instalador Automatico do Banco de Dados 
echo               UPE Connect Hub
echo ==============================================================
echo.
echo Verificando dependencias do Python...
pip install psycopg2-binary --quiet

echo.
echo Iniciando a criacao do banco e injecao de tabelas...
python build_db.py

echo.
echo Pressione qualquer tecla para sair...
pause >nul
