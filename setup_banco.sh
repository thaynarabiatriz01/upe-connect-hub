#!/bin/bash
echo "=============================================================="
echo "      Instalador Automatico do Banco de Dados"
echo "              UPE Connect Hub"
echo "=============================================================="
echo ""
if ! python3 -c "import psycopg2" &> /dev/null; then
    echo "A biblioteca psycopg2 não está instalada."
    echo "Por favor, instale-a rodando o comando:"
    echo "  sudo apt install -y python3-psycopg2"
    exit 1
fi

echo ""
echo "Iniciando a criacao do banco e injecao de tabelas..."
python3 build_db.py

echo ""
echo "Concluido!"
