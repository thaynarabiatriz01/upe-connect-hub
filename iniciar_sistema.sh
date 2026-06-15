#!/bin/bash
echo "=============================================================="
echo "           Iniciador do UPE Connect Hub"
echo "=============================================================="
echo ""

if [ ! -d ".venv" ]; then
    echo "[1/3] Criando ambiente virtual Python (.venv)..."
    python3 -m venv .venv
else
    echo "[1/3] Ambiente virtual ja existe."
fi

echo "[2/3] Instalando dependencias do backend..."
source .venv/bin/activate
pip install -r backend/requirements.txt --quiet
pip install uvicorn fastapi psycopg2-binary jose python-jose[cryptography] --quiet

echo "[3/3] Iniciando o Servidor Backend (FastAPI) na porta 8000..."
echo "O backend estara rodando em: http://localhost:8000"
echo "Mantenha esta janela aberta e abra o arquivo frontend/index.html no navegador."
echo ""
echo "Pressione CTRL+C nesta janela para encerrar o servidor."
echo ""

cd backend
uvicorn main:app --reload --host 0.0.0.0 --port 8000

echo ""
echo "Servidor encerrado ou ocorreu um erro fatal no carregamento."
read -p "Pressione ENTER para fechar..."
