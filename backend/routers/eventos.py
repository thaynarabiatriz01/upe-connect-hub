from fastapi import APIRouter, HTTPException, Depends, Header
from pydantic import BaseModel
from typing import Optional
from datetime import datetime
from jose import jwt
from psycopg2.extras import RealDictCursor
import uuid
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

def get_current_admin_or_docente(authorization: str = Header(None)):
    user = get_current_user(authorization)
    role = user.get("role")
    if role not in ["Professor", "Coordenador", "Pesquisador", "Administrador"]:
        raise HTTPException(status_code=403, detail="Acesso restrito.")
    return user

class EventoRequest(BaseModel):
    titulo: str
    descricao: str
    data_inicio: str # YYYY-MM-DD HH:MM
    data_fim: str # YYYY-MM-DD HH:MM
    local: str
    vagas: str
    carga_horaria: int

class EquipeRequest(BaseModel):
    email_aluno: str
    papel: str = "Monitor"

@router.get("/")
def listar_eventos():
    conn = get_db_connection()
    try:
        with conn.cursor(cursor_factory=RealDictCursor) as cursor:
            cursor.execute("SELECT * FROM eventos WHERE status = 'Aberto' ORDER BY data_inicio ASC")
            results = cursor.fetchall()
            for r in results:
                if r['data_inicio']: r['data_inicio'] = r['data_inicio'].strftime('%Y-%m-%d %H:%M')
                if r['data_fim']: r['data_fim'] = r['data_fim'].strftime('%Y-%m-%d %H:%M')
            return results
    finally:
        conn.close()

@router.post("/")
def criar_evento(req: EventoRequest, admin=Depends(get_current_admin_or_docente)):
    conn = get_db_connection()
    try:
        with conn.cursor() as cursor:
            cursor.execute("""
                INSERT INTO eventos (titulo, descricao, data_inicio, data_fim, local, vagas, carga_horaria)
                VALUES (%s, %s, %s, %s, %s, %s, %s)
            """, (req.titulo, req.descricao, req.data_inicio, req.data_fim, req.local, req.vagas, req.carga_horaria))
            conn.commit()
            return {"message": "Evento criado com sucesso!"}
    except Exception as e:
        conn.rollback()
        raise HTTPException(status_code=400, detail="Erro ao criar evento: " + str(e))
    finally:
        conn.close()

@router.post("/{id_evento}/participar")
def participar_evento(id_evento: int, user=Depends(get_current_user)):
    if user.get("role") in ["Professor", "Coordenador", "Pesquisador", "Administrador"]:
        raise HTTPException(status_code=403, detail="Apenas estudantes e monitores podem se inscrever como ouvinte em eventos.")
        
    conn = get_db_connection()
    try:
        with conn.cursor() as cursor:
            cursor.execute("""
                INSERT INTO participacoes (id_usuario, id_evento, tipo_participacao)
                VALUES (%s, %s, 'Ouvinte')
            """, (user["id"], id_evento))
            conn.commit()
            return {"message": "Inscrição realizada com sucesso!"}
    except Exception as e:
        conn.rollback()
        raise HTTPException(status_code=400, detail="Erro ao se inscrever (Você já está inscrito?).")
    finally:
        conn.close()

@router.post("/{id_evento}/equipe")
def alocar_equipe(id_evento: int, req: EquipeRequest, admin=Depends(get_current_admin_or_docente)):
    conn = get_db_connection()
    try:
        with conn.cursor() as cursor:
            cursor.execute("SELECT id_usuario FROM usuarios WHERE email = %s", (req.email_aluno,))
            user = cursor.fetchone()
            if not user:
                raise HTTPException(status_code=404, detail="Aluno não encontrado com este e-mail.")
            
            # Upsert para permitir que um aluno que se inscreveu como ouvinte vire monitor
            cursor.execute("""
                INSERT INTO participacoes (id_usuario, id_evento, tipo_participacao, presenca)
                VALUES (%s, %s, %s, TRUE)
                ON CONFLICT (id_usuario, id_evento) DO UPDATE SET 
                tipo_participacao = EXCLUDED.tipo_participacao, presenca = TRUE
            """, (user[0], id_evento, req.papel))
            conn.commit()
            return {"message": f"Aluno alocado como {req.papel} com sucesso!"}
    except Exception as e:
        conn.rollback()
        raise HTTPException(status_code=400, detail="Erro ao alocar equipe: " + str(e))
    finally:
        conn.close()

@router.get("/{id_evento}/equipe")
def listar_equipe(id_evento: int, admin=Depends(get_current_admin_or_docente)):
    conn = get_db_connection()
    try:
        with conn.cursor(cursor_factory=RealDictCursor) as cursor:
            cursor.execute("""
                SELECT u.nome, u.email, p.tipo_participacao 
                FROM participacoes p
                JOIN usuarios u ON p.id_usuario = u.id_usuario
                WHERE p.id_evento = %s AND p.tipo_participacao != 'Ouvinte'
            """, (id_evento,))
            return cursor.fetchall()
    finally:
        conn.close()

@router.put("/{id_evento}/presenca/{id_usuario}")
def registrar_presenca(id_evento: int, id_usuario: int, admin=Depends(get_current_admin_or_docente)):
    conn = get_db_connection()
    try:
        with conn.cursor() as cursor:
            cursor.execute("""
                UPDATE participacoes SET presenca = TRUE 
                WHERE id_evento = %s AND id_usuario = %s
                RETURNING id_participacao
            """, (id_evento, id_usuario))
            if not cursor.fetchone():
                raise HTTPException(status_code=404, detail="Participação não encontrada.")
            conn.commit()
            return {"message": "Presença confirmada."}
    except Exception as e:
        conn.rollback()
        raise HTTPException(status_code=400, detail="Erro ao registrar presença: " + str(e))
    finally:
        conn.close()

@router.post("/{id_evento}/certificados")
def gerar_certificados(id_evento: int, admin=Depends(get_current_admin_or_docente)):
    conn = get_db_connection()
    try:
        with conn.cursor(cursor_factory=RealDictCursor) as cursor:
            cursor.execute("""
                SELECT p.id_participacao, p.id_usuario, e.titulo 
                FROM participacoes p
                JOIN eventos e ON p.id_evento = e.id_evento
                WHERE p.id_evento = %s AND p.presenca = TRUE
            """, (id_evento,))
            participantes = cursor.fetchall()
            
            gerados = 0
            for p in participantes:
                codigo_validacao = str(uuid.uuid4())
                try:
                    cursor.execute("""
                        INSERT INTO certificados (id_participacao, codigo_validacao)
                        VALUES (%s, %s)
                    """, (p['id_participacao'], codigo_validacao))
                    
                    cursor.execute("""
                        INSERT INTO notificacoes (id_usuario, titulo, mensagem)
                        VALUES (%s, %s, %s)
                    """, (p['id_usuario'], 
                          f"Certificado Disponível: {p['titulo']}", 
                          f"Seu certificado de participação no evento '{p['titulo']}' foi gerado e já está disponível para download!"))
                    gerados += 1
                except Exception:
                    pass # Ignore se já gerou para este aluno
            
            conn.commit()
            return {"message": f"Certificados gerados: {gerados}."}
    except Exception as e:
        conn.rollback()
        raise HTTPException(status_code=400, detail="Erro ao gerar certificados: " + str(e))
    finally:
        conn.close()

@router.get("/minhas_inscricoes")
def listar_minhas_inscricoes(user=Depends(get_current_user)):
    conn = get_db_connection()
    try:
        with conn.cursor(cursor_factory=RealDictCursor) as cursor:
            cursor.execute("""
                SELECT p.id_participacao, p.data_inscricao, p.presenca, p.tipo_participacao,
                       e.id_evento, e.titulo, e.descricao, e.data_inicio, e.data_fim, e.local, e.carga_horaria,
                       c.codigo_validacao, c.data_emissao
                FROM participacoes p
                JOIN eventos e ON p.id_evento = e.id_evento
                LEFT JOIN certificados c ON p.id_participacao = c.id_participacao
                WHERE p.id_usuario = %s
                ORDER BY e.data_inicio DESC
            """, (user["id"],))
            results = cursor.fetchall()
            for r in results:
                if r['data_inscricao']:
                    r['data_inscricao'] = r['data_inscricao'].strftime('%Y-%m-%d %H:%M')
                if r['data_inicio']:
                    r['data_inicio'] = r['data_inicio'].strftime('%Y-%m-%d %H:%M')
                if r['data_fim']:
                    r['data_fim'] = r['data_fim'].strftime('%Y-%m-%d %H:%M')
                if r['data_emissao']:
                    r['data_emissao'] = r['data_emissao'].strftime('%Y-%m-%d %H:%M')
            return results
    finally:
        conn.close()
