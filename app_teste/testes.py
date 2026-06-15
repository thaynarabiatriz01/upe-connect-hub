import os
import psycopg2
from dotenv import load_dotenv

# Carrega variáveis de ambiente do arquivo .env se existir
load_dotenv()

def conectar():
    return psycopg2.connect(
        host=os.getenv("DB_HOST", "localhost"),
        database=os.getenv("DB_NAME", "upe_connect_hub"),
        user=os.getenv("DB_USER", "postgres"),
        password=os.getenv("DB_PASSWORD", "postgres"),
        port=os.getenv("DB_PORT", "5432")
    )

def cadastrar_usuario():
    print("\n--- Cadastro de Usuário ---")
    nome = input("Nome: ")
    email = input("Email: ")
    senha = input("Senha: ")
    matricula = input("Matricula: ")
    telefone = input("Telefone: ")

    print("\nTipos de Usuário:")
    print("1 - Aluno")
    print("2 - Professor")
    print("3 - Coordenador")
    print("4 - Pesquisador")
    print("5 - Monitor")
    print("6 - Administrador")

    try:
        tipo = int(input("Tipo: "))
    except ValueError:
        print("Tipo inválido. Deve ser um número de 1 a 6.")
        return

    try:
        conn = conectar()
        cur = conn.cursor()
        cur.execute("""
            INSERT INTO usuarios (nome, email, senha, matricula, telefone, id_tipo_usuario)
            VALUES (%s, %s, %s, %s, %s, %s)
        """, (nome, email, senha, matricula, telefone, tipo))
        conn.commit()
        print("\nUsuário cadastrado com sucesso!")
    except Exception as e:
        print(f"\nErro ao cadastrar usuário: {e}")
    finally:
        if 'cur' in locals(): cur.close()
        if 'conn' in locals(): conn.close()

def listar_usuarios():
    print("\n===== USUÁRIOS =====")
    try:
        conn = conectar()
        cur = conn.cursor()
        cur.execute("""
            SELECT id_usuario, nome, email, id_tipo_usuario
            FROM usuarios
            ORDER BY id_usuario
        """)
        usuarios = cur.fetchall()
        for u in usuarios:
            print(f"ID: {u[0]} | Nome: {u[1]} | Email: {u[2]} | Tipo: {u[3]}")
    except Exception as e:
        print(f"Erro ao listar usuários: {e}")
    finally:
        if 'cur' in locals(): cur.close()
        if 'conn' in locals(): conn.close()

def cadastrar_evento():
    print("\n--- Cadastro de Evento ---")
    titulo = input("Título: ")
    descricao = input("Descrição: ")
    local = input("Local: ")
    data_evento = input("Data (YYYY-MM-DD): ")

    try:
        conn = conectar()
        cur = conn.cursor()
        cur.execute("""
            INSERT INTO eventos (titulo, descricao, local, data_evento)
            VALUES (%s, %s, %s, %s)
        """, (titulo, descricao, local, data_evento))
        conn.commit()
        print("\nEvento cadastrado com sucesso!")
    except Exception as e:
        print(f"\nErro ao cadastrar evento: {e}")
    finally:
        if 'cur' in locals(): cur.close()
        if 'conn' in locals(): conn.close()

def listar_eventos():
    print("\n===== EVENTOS =====")
    try:
        conn = conectar()
        cur = conn.cursor()
        cur.execute("""
            SELECT id_evento, titulo, data_evento, local
            FROM eventos
            ORDER BY id_evento
        """)
        eventos = cur.fetchall()
        for e in eventos:
            print(f"ID: {e[0]} | Título: {e[1]} | Data: {e[2]} | Local: {e[3]}")
    except Exception as e:
        print(f"Erro ao listar eventos: {e}")
    finally:
        if 'cur' in locals(): cur.close()
        if 'conn' in locals(): conn.close()

def cadastrar_vaga():
    print("\n--- Cadastro de Vaga ---")
    titulo = input("Título da vaga: ")
    descricao = input("Descrição: ")
    requisitos = input("Requisitos: ")

    try:
        conn = conectar()
        cur = conn.cursor()
        # Nota: Caso a tabela vagas possua outras colunas obrigatórias no banco,
        # pode ser necessário ajustá-las aqui.
        cur.execute("""
            INSERT INTO vagas (titulo, descricao, requisitos)
            VALUES (%s, %s, %s)
        """, (titulo, descricao, requisitos))
        conn.commit()
        print("\nVaga cadastrada com sucesso!")
    except Exception as e:
        print(f"\nErro ao cadastrar vaga: {e}")
    finally:
        if 'cur' in locals(): cur.close()
        if 'conn' in locals(): conn.close()

def listar_vagas():
    print("\n===== VAGAS =====")
    try:
        conn = conectar()
        cur = conn.cursor()
        cur.execute("""
            SELECT id_vaga, titulo
            FROM vagas
            ORDER BY id_vaga
        """)
        vagas = cur.fetchall()
        for vaga in vagas:
            print(f"ID: {vaga[0]} | Título: {vaga[1]}")
    except Exception as e:
        print(f"Erro ao listar vagas: {e}")
    finally:
        if 'cur' in locals(): cur.close()
        if 'conn' in locals(): conn.close()

def menu():
    while True:
        print("\n===== UPE CONNECT HUB =====")
        print("1 - Cadastrar usuário")
        print("2 - Listar usuários")
        print("3 - Cadastrar evento")
        print("4 - Listar eventos")
        print("5 - Cadastrar vaga")
        print("6 - Listar vagas")
        print("0 - Sair")

        opcao = input("\nEscolha uma opção: ")

        if opcao == "1":
            cadastrar_usuario()
        elif opcao == "2":
            listar_usuarios()
        elif opcao == "3":
            cadastrar_evento()
        elif opcao == "4":
            listar_eventos()
        elif opcao == "5":
            cadastrar_vaga()
        elif opcao == "6":
            listar_vagas()
        elif opcao == "0":
            print("Saindo do sistema de testes...")
            break
        else:
            print("Opção inválida!")

if __name__ == "__main__":
    menu()
