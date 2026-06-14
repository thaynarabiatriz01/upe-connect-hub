from conexao import conectar

def listar_notificacoes():

    conn = conectar()
    cur = conn.cursor()

    cur.execute("""
        SELECT titulo, mensagem
        FROM notificacoes
    """)

    resultados = cur.fetchall()

    for item in resultados:
        print(item)

    cur.close()
    conn.close()