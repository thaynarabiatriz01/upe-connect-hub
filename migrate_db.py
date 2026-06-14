import psycopg2

DB_CONFIG = {
    "host": "localhost",
    "database": "upe_connect_hub",
    "user": "postgres",
    "password": "postgres" 
}

def migrate():
    conn = psycopg2.connect(**DB_CONFIG)
    conn.autocommit = True
    cursor = conn.cursor()
    
    print("Atualizando tabela vagas...")
    try:
        cursor.execute("ALTER TABLE vagas ADD COLUMN id_usuario INTEGER REFERENCES usuarios(id_usuario);")
    except Exception as e:
        print(f"Erro (talvez já exista): {e}")

    try:
        cursor.execute("UPDATE vagas SET id_usuario = 4 WHERE id_usuario IS NULL;")
    except Exception as e:
        print(f"Erro no UPDATE: {e}")

    try:
        # Lendo o arquivo 07_procedures.sql atualizado e rodando as procedures para garantir o REPLACE
        with open('sql/07_procedures.sql', 'r', encoding='utf-8') as f:
            procedures_sql = f.read()
        cursor.execute(procedures_sql)
        print("Procedures recriadas com sucesso!")
    except Exception as e:
        print(f"Erro ao recriar procedures: {e}")

    conn.close()
    print("Migração concluída.")

if __name__ == "__main__":
    migrate()
