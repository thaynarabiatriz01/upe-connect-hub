import psycopg2
from psycopg2.extras import RealDictCursor

# Configuração fixa para testes locais (ajustar em produção para .env)
DB_CONFIG = {
    "host": "localhost",
    "database": "upe_connect_hub",
    "user": "postgres",
    "password": "postgres"  # Lembre-se de mudar aqui depois!
}

def get_db_connection():
    try:
        conn = psycopg2.connect(**DB_CONFIG)
        return conn
    except Exception as e:
        print(f"Erro ao conectar com o banco de dados: {e}")
        return None
