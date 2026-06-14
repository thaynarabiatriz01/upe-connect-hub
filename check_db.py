import psycopg2

try:
    print("Tentando conectar ao PostgreSQL...")
    conn = psycopg2.connect(host="localhost", user="postgres", password="postgres", database="postgres")
    conn.autocommit = True
    cursor = conn.cursor()
    
    cursor.execute("SELECT datname FROM pg_database WHERE datname = 'upe_connect_hub';")
    db = cursor.fetchone()
    
    if db:
        print("RESULTADO: O banco de dados 'upe_connect_hub' EXISTE!")
        
        # Agora vamos checar se tem tabelas
        conn2 = psycopg2.connect(host="localhost", user="postgres", password="postgres", database="upe_connect_hub")
        cursor2 = conn2.cursor()
        cursor2.execute("SELECT count(*) FROM information_schema.tables WHERE table_schema = 'public';")
        count = cursor2.fetchone()[0]
        print(f"RESULTADO: O banco possui {count} tabelas criadas.")
        conn2.close()
        
    else:
        print("RESULTADO: O banco de dados 'upe_connect_hub' NÃO FOI CRIADO AINDA!")
        
    conn.close()
except Exception as e:
    print(f"ERRO DE CONEXAO: {e}")
