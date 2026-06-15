@echo off
echo ==============================================================
echo            Iniciador do UPE Connect Hub
echo ==============================================================
echo.

IF NOT EXIST ".venv" (
    echo [1/3] Criando ambiente virtual Python (.venv)...
    python -m venv .venv
) ELSE (
    echo [1/3] Ambiente virtual ja existe.
)

echo [2/3] Instalando dependencias do backend...
call .venv\Scripts\activate.bat
pip install -r backend\requirements.txt --quiet
pip install uvicorn fastapi psycopg2-binary jose python-jose[cryptography] --quiet

echo [3/3] Iniciando o Servidor Backend (FastAPI) na porta 8000...
echo O backend estara rodando em: http://localhost:8000
echo Mantenha esta janela aberta e abra o arquivo frontend\index.html no navegador.
echo.
echo Pressione CTRL+C nesta janela para encerrar o servidor.
echo.

cd backend
uvicorn main:app --reload --host 0.0.0.0 --port 8000
