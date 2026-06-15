from database import get_db_connection

def run_alter():
    conn = get_db_connection()
    try:
        with conn.cursor() as cursor:
            cursor.execute("ALTER TABLE participacoes ADD COLUMN IF NOT EXISTS tipo_participacao VARCHAR(50) DEFAULT 'Ouvinte';")
            conn.commit()
            print("Coluna tipo_participacao adicionada com sucesso.")
    except Exception as e:
        print("Erro:", e)
    finally:
        conn.close()

if __name__ == "__main__":
    run_alter()
