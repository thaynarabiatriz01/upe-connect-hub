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

def pause():
    input("\nPressione ENTER para continuar...")

# ==========================================
# CRUD DE USUÁRIOS
# ==========================================

def criar_usuario():
    print("\n--- Novo Usuário ---")
    nome = input("Nome: ")
    email = input("Email: ")
    senha = input("Senha: ")
    matricula = input("Matrícula: ")
    telefone = input("Telefone: ")
    print("Tipos: 1-Aluno, 2-Professor, 3-Coordenador, 4-Pesquisador, 5-Monitor, 6-Administrador")
    try:
        tipo = int(input("ID do Tipo: "))
    except ValueError:
        print("Erro: O ID do tipo deve ser um número inteiro.")
        return

    conn = None
    try:
        conn = conectar()
        cur = conn.cursor()
        cur.execute("""
            INSERT INTO usuarios (nome, email, senha, matricula, telefone, id_tipo_usuario)
            VALUES (%s, %s, %s, %s, %s, %s)
        """, (nome, email, senha, matricula, telefone, tipo))
        conn.commit()
        print("\nUsuário criado com sucesso!")
    except Exception as e:
        if conn: conn.rollback()
        print(f"\nErro ao criar usuário: {e}")
    finally:
        if conn: conn.close()

def listar_usuarios():
    print("\n--- Lista de Usuários ---")
    conn = None
    try:
        conn = conectar()
        cur = conn.cursor()
        cur.execute("""
            SELECT id_usuario, nome, email, ativo 
            FROM usuarios 
            ORDER BY id_usuario
        """)
        registros = cur.fetchall()
        for r in registros:
            status = "Ativo" if r[3] else "Desativado"
            print(f"ID: {r[0]} | Nome: {r[1]} | Email: {r[2]} | Status: {status}")
    except Exception as e:
        print(f"\nErro ao listar usuários: {e}")
    finally:
        if conn: conn.close()

def atualizar_usuario():
    print("\n--- Atualizar Usuário ---")
    try:
        id_usuario = int(input("ID do Usuário que deseja alterar: "))
    except ValueError:
        print("Erro: ID inválido.")
        return

    novo_nome = input("Novo Nome (deixe em branco para não alterar): ")
    novo_telefone = input("Novo Telefone (deixe em branco para não alterar): ")

    conn = None
    try:
        conn = conectar()
        cur = conn.cursor()
        
        if novo_nome.strip():
            cur.execute("UPDATE usuarios SET nome = %s WHERE id_usuario = %s", (novo_nome, id_usuario))
        if novo_telefone.strip():
            cur.execute("UPDATE usuarios SET telefone = %s WHERE id_usuario = %s", (novo_telefone, id_usuario))
            
        conn.commit()
        print("\nUsuário atualizado com sucesso!")
    except Exception as e:
        if conn: conn.rollback()
        print(f"\nErro ao atualizar usuário: {e}")
    finally:
        if conn: conn.close()

def deletar_usuario():
    print("\n--- Desativar Usuário ---")
    try:
        id_usuario = int(input("ID do Usuário que deseja desativar: "))
    except ValueError:
        print("Erro: ID inválido.")
        return

    conn = None
    try:
        conn = conectar()
        cur = conn.cursor()
        cur.execute("UPDATE usuarios SET ativo = FALSE WHERE id_usuario = %s", (id_usuario,))
        conn.commit()
        print("\nUsuário desativado com sucesso!")
    except Exception as e:
        if conn: conn.rollback()
        print(f"\nErro ao desativar usuário: {e}")
    finally:
        if conn: conn.close()

# ==========================================
# CRUD DE EVENTOS
# ==========================================

def criar_evento():
    print("\n--- Novo Evento ---")
    titulo = input("Título: ")
    descricao = input("Descrição: ")
    local = input("Local: ")
    data_inicio = input("Data Início (YYYY-MM-DD HH:MM:SS): ")
    data_fim = input("Data Fim (YYYY-MM-DD HH:MM:SS): ")

    conn = None
    try:
        conn = conectar()
        cur = conn.cursor()
        cur.execute("""
            INSERT INTO eventos (titulo, descricao, local, data_inicio, data_fim)
            VALUES (%s, %s, %s, %s, %s)
        """, (titulo, descricao, local, data_inicio, data_fim))
        conn.commit()
        print("\nEvento criado com sucesso!")
    except Exception as e:
        if conn: conn.rollback()
        print(f"\nErro ao criar evento: {e}")
    finally:
        if conn: conn.close()

def listar_eventos():
    print("\n--- Lista de Eventos ---")
    conn = None
    try:
        conn = conectar()
        cur = conn.cursor()
        cur.execute("""
            SELECT id_evento, titulo, data_inicio, status 
            FROM eventos 
            ORDER BY id_evento
        """)
        registros = cur.fetchall()
        for r in registros:
            print(f"ID: {r[0]} | Título: {r[1]} | Data: {r[2]} | Status: {r[3]}")
    except Exception as e:
        print(f"\nErro ao listar eventos: {e}")
    finally:
        if conn: conn.close()

def atualizar_evento():
    print("\n--- Atualizar Evento ---")
    try:
        id_evento = int(input("ID do Evento que deseja alterar: "))
    except ValueError:
        print("Erro: ID inválido.")
        return

    novo_titulo = input("Novo Título (deixe em branco para não alterar): ")
    novo_local = input("Novo Local (deixe em branco para não alterar): ")

    conn = None
    try:
        conn = conectar()
        cur = conn.cursor()
        
        if novo_titulo.strip():
            cur.execute("UPDATE eventos SET titulo = %s WHERE id_evento = %s", (novo_titulo, id_evento))
        if novo_local.strip():
            cur.execute("UPDATE eventos SET local = %s WHERE id_evento = %s", (novo_local, id_evento))
            
        conn.commit()
        print("\nEvento atualizado com sucesso!")
    except Exception as e:
        if conn: conn.rollback()
        print(f"\nErro ao atualizar evento: {e}")
    finally:
        if conn: conn.close()

def deletar_evento():
    print("\n--- Cancelar Evento ---")
    try:
        id_evento = int(input("ID do Evento que deseja cancelar: "))
    except ValueError:
        print("Erro: ID inválido.")
        return

    conn = None
    try:
        conn = conectar()
        cur = conn.cursor()
        cur.execute("UPDATE eventos SET status = 'Cancelado' WHERE id_evento = %s", (id_evento,))
        conn.commit()
        print("\nEvento cancelado com sucesso!")
    except Exception as e:
        if conn: conn.rollback()
        print(f"\nErro ao cancelar evento: {e}")
    finally:
        if conn: conn.close()


# ==========================================
# CRUD DE VAGAS
# ==========================================

def criar_vaga():
    print("\n--- Nova Vaga ---")
    titulo = input("Título da vaga: ")
    descricao = input("Descrição: ")
    data_limite = input("Data Limite (YYYY-MM-DD): ")
    try:
        id_tipo_vaga = int(input("ID do Tipo da Vaga (ex: 1-Estágio, 2-Efetivo): "))
    except ValueError:
        print("Erro: ID do tipo inválido.")
        return

    conn = None
    try:
        conn = conectar()
        cur = conn.cursor()
        cur.execute("""
            INSERT INTO vagas (titulo, descricao, data_limite, id_tipo_vaga)
            VALUES (%s, %s, %s, %s)
        """, (titulo, descricao, data_limite, id_tipo_vaga))
        conn.commit()
        print("\nVaga criada com sucesso!")
    except Exception as e:
        if conn: conn.rollback()
        print(f"\nErro ao criar vaga: {e}")
    finally:
        if conn: conn.close()

def listar_vagas():
    print("\n--- Lista de Vagas ---")
    conn = None
    try:
        conn = conectar()
        cur = conn.cursor()
        cur.execute("""
            SELECT id_vaga, titulo, status, data_limite 
            FROM vagas 
            ORDER BY id_vaga
        """)
        registros = cur.fetchall()
        for r in registros:
            print(f"ID: {r[0]} | Título: {r[1]} | Status: {r[2]} | Limite: {r[3]}")
    except Exception as e:
        print(f"\nErro ao listar vagas: {e}")
    finally:
        if conn: conn.close()

def atualizar_vaga():
    print("\n--- Atualizar Vaga ---")
    try:
        id_vaga = int(input("ID da Vaga que deseja alterar: "))
    except ValueError:
        print("Erro: ID inválido.")
        return

    novo_titulo = input("Novo Título (deixe em branco para não alterar): ")
    nova_desc = input("Nova Descrição (deixe em branco para não alterar): ")

    conn = None
    try:
        conn = conectar()
        cur = conn.cursor()
        
        if novo_titulo.strip():
            cur.execute("UPDATE vagas SET titulo = %s WHERE id_vaga = %s", (novo_titulo, id_vaga))
        if nova_desc.strip():
            cur.execute("UPDATE vagas SET descricao = %s WHERE id_vaga = %s", (nova_desc, id_vaga))
            
        conn.commit()
        print("\nVaga atualizada com sucesso!")
    except Exception as e:
        if conn: conn.rollback()
        print(f"\nErro ao atualizar vaga: {e}")
    finally:
        if conn: conn.close()

def deletar_vaga():
    print("\n--- Cancelar Vaga ---")
    try:
        id_vaga = int(input("ID da Vaga que deseja cancelar: "))
    except ValueError:
        print("Erro: ID inválido.")
        return

    conn = None
    try:
        conn = conectar()
        cur = conn.cursor()
        cur.execute("UPDATE vagas SET status = 'CANCELADA' WHERE id_vaga = %s", (id_vaga,))
        conn.commit()
        print("\nVaga cancelada com sucesso!")
    except Exception as e:
        if conn: conn.rollback()
        print(f"\nErro ao cancelar vaga: {e}")
    finally:
        if conn: conn.close()

# ==========================================
# MENUS DE NAVEGAÇÃO
# ==========================================

def menu_crud(entidade_nome, fn_criar, fn_listar, fn_atualizar, fn_deletar):
    while True:
        print(f"\n===== GERENCIAR {entidade_nome.upper()} =====")
        print("1 - Criar")
        print("2 - Listar")
        print("3 - Atualizar")
        print("4 - Deletar (Desativar)")
        print("0 - Voltar")
        
        opcao = input("\nEscolha: ")
        if opcao == '1': fn_criar()
        elif opcao == '2': fn_listar()
        elif opcao == '3': fn_atualizar()
        elif opcao == '4': fn_deletar()
        elif opcao == '0': break
        else: print("Opção inválida.")
        pause()

def menu_principal():
    while True:
        print("\n===============================")
        print("   UPE CONNECT HUB - CRUD CLI  ")
        print("===============================")
        print("1 - Usuários")
        print("2 - Eventos")
        print("3 - Vagas")
        print("0 - Sair")

        opcao = input("\nO que você deseja gerenciar? ")

        if opcao == '1':
            menu_crud("Usuários", criar_usuario, listar_usuarios, atualizar_usuario, deletar_usuario)
        elif opcao == '2':
            menu_crud("Eventos", criar_evento, listar_eventos, atualizar_evento, deletar_evento)
        elif opcao == '3':
            menu_crud("Vagas", criar_vaga, listar_vagas, atualizar_vaga, deletar_vaga)
        elif opcao == '0':
            print("Saindo do sistema...")
            break
        else:
            print("Opção inválida!")
            pause()

if __name__ == "__main__":
    menu_principal()
