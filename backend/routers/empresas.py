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

def get_current_admin(authorization: str = Header(None)):
    user = get_current_user(authorization)
    role = user.get("role")
    if role != "Administrador":
        raise HTTPException(status_code=403, detail="Acesso restrito a Administradores.")
    return user

class EmpresaRequest(BaseModel):
    razao_social: str
    nome_empresa: str
    cnpj: str
    email: str
    telefone: str
    site: Optional[str] = None
    # Representante opcional para simplificar se precisar
    nome_representante: Optional[str] = None
    email_representante: Optional[str] = None
    telefone_representante: Optional[str] = None
    cargo_representante: Optional[str] = None

@router.get("/")
def listar_empresas():
    conn = get_db_connection()
    try:
        with conn.cursor(cursor_factory=RealDictCursor) as cursor:
            cursor.execute("SELECT * FROM empresas ORDER BY nome_empresa ASC")
            return cursor.fetchall()
    finally:
        conn.close()

@router.post("/")
def criar_empresa(req: EmpresaRequest, admin=Depends(get_current_admin)):
    conn = get_db_connection()
    try:
        with conn.cursor() as cursor:
            cursor.execute("""
                INSERT INTO empresas (razao_social, nome_empresa, cnpj, email, telefone, site)
                VALUES (%s, %s, %s, %s, %s, %s)
                RETURNING id_empresa
            """, (req.razao_social, req.nome_empresa, req.cnpj, req.email, req.telefone, req.site))
            empresa_id = cursor.fetchone()[0]

            if req.nome_representante:
                cursor.execute("CALL cadastrar_representante_empresa(%s, %s, %s, %s, %s)",
                               (req.nome_representante, req.email_representante, req.telefone_representante, req.cargo_representante, empresa_id))
            
            conn.commit()
            return {"message": "Empresa cadastrada com sucesso!"}
    except Exception as e:
        conn.rollback()
        raise HTTPException(status_code=400, detail="Erro ao cadastrar empresa: " + str(e))
    finally:
        conn.close()
