from fastapi import APIRouter, HTTPException, Depends, Header
from pydantic import BaseModel
from typing import Optional
from jose import jwt
from psycopg2.extras import RealDictCursor
from database import get_db_connection

router = APIRouter()

SECRET_KEY = "upe-connect-hub-secret-key"
ALGORITHM = "HS256"

class NovoUsuario(BaseModel):
    nome: str
    email: str
    senha: str
    matricula: Optional[str] = None
    telefone: str
    id_tipo_usuario: int

def get_current_admin(authorization: str = Header(None)):
    if not authorization or not authorization.startswith("Bearer "):
        raise HTTPException(status_code=401, detail="Token não fornecido ou inválido")
    
    token = authorization.split(" ")[1]
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        role = payload.get("role")
        if role != "Administrador":
            raise HTTPException(status_code=403, detail="Acesso restrito. Somente administradores permitidos.")
        return payload
    except Exception:
        raise HTTPException(status_code=401, detail="Sessão expirada ou token adulterado.")

@router.get("/dashboard")
def get_admin_dashboard(admin=Depends(get_current_admin)):
    conn = get_db_connection()
    try:
        with conn.cursor(cursor_factory=RealDictCursor) as cursor:
            cursor.execute("SELECT count(*) as total FROM usuarios")
            total_users = cursor.fetchone()["total"]
            
            cursor.execute("SELECT count(*) as total FROM vagas")
            total_vagas = cursor.fetchone()["total"]
            
            cursor.execute("SELECT count(*) as total FROM candidaturas")
            total_cand = cursor.fetchone()["total"]
            
            cursor.execute("SELECT count(*) as total FROM eventos")
            total_ev = cursor.fetchone()["total"]
            
            cursor.execute("""
                SELECT u.id_usuario, u.nome, u.email, t.nome_tipo 
                FROM usuarios u 
                JOIN tipos_usuario t ON u.id_tipo_usuario = t.id_tipo_usuario 
                WHERE u.ativo = FALSE
                ORDER BY u.id_usuario DESC
            """)
            usuarios_pendentes = cursor.fetchall()
            
            return {
                "stats": {
                    "usuarios": total_users,
                    "vagas": total_vagas,
                    "candidaturas": total_cand,
                    "eventos": total_ev
                },
                "usuarios_pendentes": usuarios_pendentes
            }
    finally:
        conn.close()

@router.put("/usuarios/{id_usuario}/aprovar")
def aprovar_usuario(id_usuario: int, admin=Depends(get_current_admin)):
    conn = get_db_connection()
    try:
        with conn.cursor() as cursor:
            cursor.execute("""
                UPDATE usuarios SET ativo = TRUE WHERE id_usuario = %s RETURNING id_usuario
            """, (id_usuario,))
            
            updated = cursor.fetchone()
            if not updated:
                raise HTTPException(status_code=404, detail="Usuário não encontrado.")
                
            conn.commit()
            return {"message": f"Usuário #{id_usuario} aprovado com sucesso e já pode acessar o sistema!"}
    except Exception as e:
        conn.rollback()
        raise HTTPException(status_code=400, detail="Erro ao aprovar usuário: " + str(e))
    finally:
        conn.close()

@router.get("/usuarios/ativos")
def listar_usuarios_ativos(admin=Depends(get_current_admin)):
    conn = get_db_connection()
    try:
        with conn.cursor(cursor_factory=RealDictCursor) as cursor:
            cursor.execute("""
                SELECT u.id_usuario, u.nome, u.email, u.telefone, t.nome_tipo 
                FROM usuarios u 
                JOIN tipos_usuario t ON u.id_tipo_usuario = t.id_tipo_usuario 
                WHERE u.ativo = TRUE
                ORDER BY u.id_usuario DESC
            """)
            return cursor.fetchall()
    finally:
        conn.close()

@router.get("/vagas_detalhes")
def listar_vagas_detalhes(admin=Depends(get_current_admin)):
    conn = get_db_connection()
    try:
        with conn.cursor(cursor_factory=RealDictCursor) as cursor:
            cursor.execute("""
                SELECT v.id_vaga, v.titulo, e.nome_empresa as empresa, v.quantidade_vagas as bolsa, v.data_limite as data_fim
                FROM vagas v
                JOIN empresas e ON v.id_empresa = e.id_empresa
                ORDER BY v.id_vaga DESC
            """)
            results = cursor.fetchall()
            for r in results:
                if r['data_fim']:
                    r['data_fim'] = r['data_fim'].strftime('%Y-%m-%d')
            return results
    finally:
        conn.close()

@router.get("/candidaturas_detalhes")
def listar_candidaturas_detalhes(admin=Depends(get_current_admin)):
    conn = get_db_connection()
    try:
        with conn.cursor(cursor_factory=RealDictCursor) as cursor:
            cursor.execute("""
                SELECT c.id_candidatura, u.nome as aluno, v.titulo as vaga, s.descricao as status, c.data_candidatura
                FROM candidaturas c
                JOIN usuarios u ON c.id_usuario = u.id_usuario
                JOIN vagas v ON c.id_vaga = v.id_vaga
                JOIN status_candidatura s ON c.status_candidatura = s.id_status_candidatura
                ORDER BY c.data_candidatura DESC
            """)
            # Formatando a data
            results = cursor.fetchall()
            for r in results:
                if r['data_candidatura']:
                    r['data_candidatura'] = r['data_candidatura'].strftime('%Y-%m-%d %H:%M')
            return results
    finally:
        conn.close()

@router.get("/eventos_detalhes")
def listar_eventos_detalhes(admin=Depends(get_current_admin)):
    conn = get_db_connection()
    try:
        with conn.cursor(cursor_factory=RealDictCursor) as cursor:
            cursor.execute("""
                SELECT id_evento, titulo, local, data_inicio, vagas
                FROM eventos
                ORDER BY data_inicio DESC
            """)
            results = cursor.fetchall()
            for r in results:
                if r['data_inicio']:
                    r['data_inicio'] = r['data_inicio'].strftime('%Y-%m-%d %H:%M')
            return results
    finally:
        conn.close()
