#!/bin/bash
echo "=============================================================="
echo "      Instalador Automatico do Banco de Dados"
echo "              UPE Connect Hub"
echo "=============================================================="
echo ""
echo "Verificando dependencias do Python..."
pip3 install psycopg2-binary --quiet

echo ""
echo "Iniciando a criacao do banco e injecao de tabelas..."
python3 build_db.py

echo ""
echo "Concluido!"
