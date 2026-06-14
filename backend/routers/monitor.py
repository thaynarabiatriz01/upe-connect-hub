from fastapi import APIRouter, HTTPException, Depends, Header
from pydantic import BaseModel
from jose import jwt
from psycopg2.extras import RealDictCursor
from database import get_db_connection

router = APIRouter()

SECRET_KEY = "upe-connect-hub-secret-key"
ALGORITHM = "HS256"

def get_current_monitor(authorization: str = Header(None)):
    if not authorization or not authorization.startswith("Bearer "):
        raise HTTPException(status_code=401, detail="Token não fornecido ou inválido")
    
    token = authorization.split(" ")[1]
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        role = payload.get("role")
        if role != "Monitor":
            raise HTTPException(status_code=403, detail="Acesso restrito a Monitores.")
        return payload
    except Exception:
        raise HTTPException(status_code=401, detail="Sessão expirada ou token adulterado.")

@router.get("/meus_dados")
def painel_monitor(monitor=Depends(get_current_monitor)):
    conn = get_db_connection()
    try:
        with conn.cursor(cursor_factory=RealDictCursor) as cursor:
            cursor.execute("""
                SELECT u.nome, u.email, u.matricula, t.nome_tipo
                FROM usuarios u
                JOIN tipos_usuario t ON u.id_tipo_usuario = t.id_tipo_usuario
                WHERE u.id_usuario = %s
            """, (monitor["id"],))
            return cursor.fetchone()
    finally:
        conn.close()
