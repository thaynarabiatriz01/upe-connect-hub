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
