from fastapi import APIRouter, HTTPException, Depends, Header
from pydantic import BaseModel
from typing import Optional
from jose import jwt
from psycopg2.extras import RealDictCursor
from database import get_db_connection

router = APIRouter()

SECRET_KEY = "upe-connect-hub-secret-key"
ALGORITHM = "HS256"

def get_current_user(authorization: str = Header(None)):
    if not authorization or not authorization.startswith("Bearer "):
        raise HTTPException(status_code=401, detail="Token não fornecido")
    
    token = authorization.split(" ")[1]
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        return payload
    except Exception:
        raise HTTPException(status_code=401, detail="Sessão expirada.")

class PerfilRequest(BaseModel):
    id_curso: int
    periodo: int
    foto_perfil: Optional[str] = None
    linkedin: Optional[str] = None
    github: Optional[str] = None
    biografia: Optional[str] = None

@router.get("/perfil")
def buscar_perfil(user=Depends(get_current_user)):
    conn = get_db_connection()
    try:
        with conn.cursor(cursor_factory=RealDictCursor) as cursor:
            cursor.execute("SELECT * FROM perfis WHERE id_usuario = %s", (user["id"],))
            perfil = cursor.fetchone()
            if not perfil:
                raise HTTPException(status_code=404, detail="Perfil não encontrado")
            return perfil
    finally:
        conn.close()

@router.post("/perfil")
def salvar_perfil(req: PerfilRequest, user=Depends(get_current_user)):
    conn = get_db_connection()
    try:
        with conn.cursor() as cursor:
            # UPSERT: Insere o perfil se não existir, senão atualiza.
            cursor.execute("""
                INSERT INTO perfis (id_usuario, id_curso, periodo, foto_perfil, linkedin, github, biografia)
                VALUES (%s, %s, %s, %s, %s, %s, %s)
                ON CONFLICT (id_usuario) DO UPDATE SET
                    id_curso = EXCLUDED.id_curso,
                    periodo = EXCLUDED.periodo,
                    foto_perfil = EXCLUDED.foto_perfil,
                    linkedin = EXCLUDED.linkedin,
                    github = EXCLUDED.github,
                    biografia = EXCLUDED.biografia
            """, (user["id"], req.id_curso, req.periodo, req.foto_perfil, req.linkedin, req.github, req.biografia))
            conn.commit()
            return {"message": "Perfil atualizado com sucesso!"}
    except Exception as e:
        conn.rollback()
        raise HTTPException(status_code=400, detail="Erro ao salvar perfil: " + str(e))
    finally:
        conn.close()

class HabilidadeRequest(BaseModel):
    id_habilidade: int
    nivel: str

class CertificacaoRequest(BaseModel):
    id_certificacao: int
    data_conclusao: str

@router.get("/todas_habilidades")
def listar_todas_habilidades():
    conn = get_db_connection()
    try:
        with conn.cursor(cursor_factory=RealDictCursor) as cursor:
            cursor.execute("SELECT * FROM habilidades ORDER BY nome")
            return cursor.fetchall()
    finally:
        conn.close()

@router.get("/todas_certificacoes")
def listar_todas_certificacoes():
    conn = get_db_connection()
    try:
        with conn.cursor(cursor_factory=RealDictCursor) as cursor:
            cursor.execute("SELECT * FROM certificacoes ORDER BY nome")
            return cursor.fetchall()
    finally:
        conn.close()

@router.get("/habilidades")
def listar_minhas_habilidades(user=Depends(get_current_user)):
    conn = get_db_connection()
    try:
        with conn.cursor(cursor_factory=RealDictCursor) as cursor:
            cursor.execute("""
                SELECT h.id_habilidade, h.nome, uh.nivel 
                FROM usuario_habilidades uh
                JOIN habilidades h ON uh.id_habilidade = h.id_habilidade
                WHERE uh.id_usuario = %s
            """, (user["id"],))
            return cursor.fetchall()
    finally:
        conn.close()

@router.get("/minhas_candidaturas")
def listar_minhas_candidaturas(user=Depends(get_current_user)):
    conn = get_db_connection()
    try:
        with conn.cursor(cursor_factory=RealDictCursor) as cursor:
            cursor.execute("""
                SELECT 
                    c.id_candidatura,
                    v.titulo,
                    s.descricao as status,
                    c.data_candidatura,
                    (SELECT fc.comentario FROM feedback_candidatura fc WHERE fc.id_candidatura = c.id_candidatura ORDER BY fc.data_feedback DESC LIMIT 1) as ultimo_feedback
                FROM candidaturas c
                JOIN vagas v ON c.id_vaga = v.id_vaga
                JOIN status_candidatura s ON c.status_candidatura = s.id_status_candidatura
                WHERE c.id_usuario = %s
                ORDER BY c.data_candidatura DESC
            """, (user["id"],))
            
            results = cursor.fetchall()
            for r in results:
                if r['data_candidatura']:
                    r['data_candidatura'] = r['data_candidatura'].strftime('%d/%m/%Y')
            return results
    finally:
        conn.close()

@router.post("/habilidades")
def adicionar_minha_habilidade(req: HabilidadeRequest, user=Depends(get_current_user)):
    conn = get_db_connection()
    try:
        with conn.cursor() as cursor:
            cursor.execute("CALL adicionar_habilidade_usuario(%s, %s, %s)", 
                           (user["id"], req.id_habilidade, req.nivel))
            conn.commit()
            return {"message": "Habilidade adicionada com sucesso!"}
    except Exception as e:
        conn.rollback()
        raise HTTPException(status_code=400, detail="Erro ao adicionar habilidade: " + str(e))
    finally:
        conn.close()

@router.delete("/habilidades/{id_habilidade}")
def remover_minha_habilidade(id_habilidade: int, user=Depends(get_current_user)):
    conn = get_db_connection()
    try:
        with conn.cursor() as cursor:
            cursor.execute("DELETE FROM usuario_habilidades WHERE id_usuario = %s AND id_habilidade = %s", 
                           (user["id"], id_habilidade))
            conn.commit()
            return {"message": "Habilidade removida com sucesso!"}
    except Exception as e:
        conn.rollback()
        raise HTTPException(status_code=400, detail="Erro ao remover habilidade: " + str(e))
    finally:
        conn.close()

@router.get("/certificacoes")
def listar_minhas_certificacoes(user=Depends(get_current_user)):
    conn = get_db_connection()
    try:
        with conn.cursor(cursor_factory=RealDictCursor) as cursor:
            cursor.execute("""
                SELECT c.id_certificacao, c.nome, c.instituicao, uc.data_conclusao, uc.arquivo_comprovante
                FROM usuario_certificacoes uc
                JOIN certificacoes c ON uc.id_certificacao = c.id_certificacao
                WHERE uc.id_usuario = %s
            """, (user["id"],))
            results = cursor.fetchall()
            for r in results:
                if r['data_conclusao']:
                    r['data_conclusao'] = r['data_conclusao'].strftime('%Y-%m-%d')
            return results
    finally:
        conn.close()

@router.post("/certificacoes")
def adicionar_minha_certificacao(req: CertificacaoRequest, user=Depends(get_current_user)):
    conn = get_db_connection()
    try:
        with conn.cursor() as cursor:
            cursor.execute("CALL adicionar_certificacao_usuario(%s, %s, %s)", 
                           (user["id"], req.id_certificacao, req.data_conclusao))
            conn.commit()
            return {"message": "Certificação adicionada com sucesso!"}
    except Exception as e:
        conn.rollback()
        raise HTTPException(status_code=400, detail="Erro ao adicionar certificação: " + str(e))
    finally:
        conn.close()

@router.delete("/certificacoes/{id_certificacao}")
def remover_minha_certificacao(id_certificacao: int, user=Depends(get_current_user)):
    conn = get_db_connection()
    try:
        with conn.cursor() as cursor:
            cursor.execute("DELETE FROM usuario_certificacoes WHERE id_usuario = %s AND id_certificacao = %s", 
                           (user["id"], id_certificacao))
            conn.commit()
            return {"message": "Certificação removida com sucesso!"}
    except Exception as e:
        conn.rollback()
        raise HTTPException(status_code=400, detail="Erro ao remover certificação: " + str(e))
    finally:
        conn.close()


class AreaInteresseRequest(BaseModel):
    id_area: int

@router.get("/todas_areas_interesse")
def listar_todas_areas_interesse():
    conn = get_db_connection()
    try:
        with conn.cursor(cursor_factory=RealDictCursor) as cursor:
            cursor.execute("SELECT * FROM areas_interesse ORDER BY nome")
            return cursor.fetchall()
    finally:
        conn.close()

@router.get("/areas_interesse")
def listar_minhas_areas_interesse(user=Depends(get_current_user)):
    conn = get_db_connection()
    try:
        with conn.cursor(cursor_factory=RealDictCursor) as cursor:
            cursor.execute("""
                SELECT ai.id_area, ai.nome, ai.descricao 
                FROM usuario_areas_interesse uai
                JOIN areas_interesse ai ON uai.id_area = ai.id_area
                WHERE uai.id_usuario = %s
            """, (user["id"],))
            return cursor.fetchall()
    finally:
        conn.close()

@router.post("/areas_interesse")
def adicionar_minha_area_interesse(req: AreaInteresseRequest, user=Depends(get_current_user)):
    conn = get_db_connection()
    try:
        with conn.cursor() as cursor:
            cursor.execute("""
                INSERT INTO usuario_areas_interesse (id_usuario, id_area)
                VALUES (%s, %s)
                ON CONFLICT DO NOTHING
            """, (user["id"], req.id_area))
            conn.commit()
            return {"message": "Área de interesse adicionada com sucesso!"}
    except Exception as e:
        conn.rollback()
        raise HTTPException(status_code=400, detail="Erro ao adicionar área de interesse: " + str(e))
    finally:
        conn.close()

@router.delete("/areas_interesse/{id_area}")
def remover_minha_area_interesse(id_area: int, user=Depends(get_current_user)):
    conn = get_db_connection()
    try:
        with conn.cursor() as cursor:
            cursor.execute("""
                DELETE FROM usuario_areas_interesse 
                WHERE id_usuario = %s AND id_area = %s
            """, (user["id"], id_area))
            conn.commit()
            return {"message": "Área de interesse removida com sucesso!"}
    except Exception as e:
        conn.rollback()
        raise HTTPException(status_code=400, detail="Erro ao remover área de interesse: " + str(e))
    finally:
        conn.close()

@router.get("/notificacoes")
def listar_notificacoes(user=Depends(get_current_user)):
    conn = get_db_connection()
    try:
        with conn.cursor(cursor_factory=RealDictCursor) as cursor:
            cursor.execute("""
                SELECT id_notificacao, titulo, mensagem, lida, data_criacao 
                FROM notificacoes 
                WHERE id_usuario = %s 
                ORDER BY data_criacao DESC
            """, (user["id"],))
            results = cursor.fetchall()
            for r in results:
                if r['data_criacao']:
                    r['data_criacao'] = r['data_criacao'].strftime('%Y-%m-%d %H:%M')
            return results
    finally:
        conn.close()

@router.put("/notificacoes/{id_notificacao}/ler")
def marcar_notificacao_lida(id_notificacao: int, user=Depends(get_current_user)):
    conn = get_db_connection()
    try:
        with conn.cursor() as cursor:
            cursor.execute("""
                UPDATE notificacoes SET lida = TRUE 
                WHERE id_notificacao = %s AND id_usuario = %s
                RETURNING id_notificacao
            """, (id_notificacao, user["id"]))
            if not cursor.fetchone():
                raise HTTPException(status_code=404, detail="Notificação não encontrada.")
            conn.commit()
            return {"message": "Notificação marcada como lida."}
    except Exception as e:
        conn.rollback()
        raise HTTPException(status_code=400, detail="Erro ao marcar notificação: " + str(e))
    finally:
        conn.close()

@router.get("/minhas_candidaturas")
def listar_minhas_candidaturas(user=Depends(get_current_user)):
    conn = get_db_connection()
    try:
        with conn.cursor(cursor_factory=RealDictCursor) as cursor:
            cursor.execute("""
                SELECT c.id_candidatura, c.data_candidatura, s.descricao as status, v.titulo as vaga, e.nome_empresa as empresa,
                       fc.comentario as feedback, fc.data_feedback
                FROM candidaturas c
                JOIN vagas v ON c.id_vaga = v.id_vaga
                LEFT JOIN empresas e ON v.id_empresa = e.id_empresa
                JOIN status_candidatura s ON c.status_candidatura = s.id_status_candidatura
                LEFT JOIN feedback_candidatura fc ON c.id_candidatura = fc.id_candidatura
                WHERE c.id_usuario = %s
                ORDER BY c.data_candidatura DESC
            """, (user["id"],))
            results = cursor.fetchall()
            for r in results:
                if r['data_candidatura']:
                    r['data_candidatura'] = r['data_candidatura'].strftime('%Y-%m-%d %H:%M')
                if r['data_feedback']:
                    r['data_feedback'] = r['data_feedback'].strftime('%Y-%m-%d %H:%M')
            return results
    finally:
        conn.close()

@router.get("/tipos_usuario")
def listar_tipos_usuario():
    conn = get_db_connection()
    try:
        with conn.cursor(cursor_factory=RealDictCursor) as cursor:
            cursor.execute("SELECT * FROM tipos_usuario ORDER BY id_tipo_usuario")
            return cursor.fetchall()
    finally:
        conn.close()
