import psycopg2
import os

# Credenciais do banco de dados local
DB_USER = "postgres"
DB_PASS = "postgres"
DB_HOST = "localhost"
DB_NAME = "upe_connect_hub"

sql_files_order = [
    "sql/01_tabelas.sql",
    "sql/02_relacionamentos.sql",
    "sql/03_indices.sql",
    "sql/04_inserts.sql",
    "sql/05_views.sql",
    "sql/06_functions.sql",
    "sql/07_procedures.sql",
    "sql/08_triggers.sql",
    "sql/09_consultas.sql",
    "seeders/empresas.sql",
    "seeders/usuarios.sql",
    "seeders/vagas.sql",
    "seeders/candidaturas.sql",
    "seeders/eventos.sql"
]

def build_database():
    try:
        print("Conectando ao PostgreSQL padrão...")
        # Conecta no DB padrão apenas para criar o novo banco
        conn_default = psycopg2.connect(host=DB_HOST, user=DB_USER, password=DB_PASS, database="postgres")
        conn_default.autocommit = True
        cursor_default = conn_default.cursor()
        
        # Criação do Banco
        print(f"Criando banco de dados '{DB_NAME}'...")
        cursor_default.execute(f"DROP DATABASE IF EXISTS {DB_NAME};")
        cursor_default.execute(f"CREATE DATABASE {DB_NAME};")
        
        cursor_default.close()
        conn_default.close()
        
        print(f"Banco de dados '{DB_NAME}' criado com sucesso!\n")
        
        # Conecta no novo banco para injetar os scripts
        print("Conectando ao novo banco para injetar os scripts SQL...")
        conn_target = psycopg2.connect(host=DB_HOST, user=DB_USER, password=DB_PASS, database=DB_NAME)
        conn_target.autocommit = True
        cursor_target = conn_target.cursor()
        
        # Descobre a pasta atual dinamicamente onde o script está rodando
        base_dir = os.path.dirname(os.path.abspath(__file__))
        
        for file_path in sql_files_order:
            full_path = os.path.join(base_dir, file_path)
            if os.path.exists(full_path):
                print(f"Executando script: {file_path}")
                with open(full_path, 'r', encoding='utf-8') as f:
                    sql_content = f.read()
                    
                # Ignora arquivos vazios
                if sql_content.strip():
                    try:
                        cursor_target.execute(sql_content)
                    except Exception as sql_err:
                        print(f"  [ERRO] Falha ao executar {file_path}: {sql_err}")
            else:
                print(f"[AVISO] Script não encontrado: {file_path}")

        cursor_target.close()
        conn_target.close()
        print("\nTodos os scripts foram injetados com sucesso! Banco pronto para uso.")
        
    except Exception as e:
        print(f"ERRO CRÍTICO: {e}")

if __name__ == "__main__":
    build_database()
