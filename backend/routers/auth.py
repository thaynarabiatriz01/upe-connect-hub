from fastapi import APIRouter, HTTPException, Depends, status
from pydantic import BaseModel
from datetime import datetime, timedelta
from jose import jwt
from psycopg2.extras import RealDictCursor
from database import get_db_connection

router = APIRouter()

# Configuração simples para o JWT
SECRET_KEY = "upe-connect-hub-secret-key"
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_MINUTES = 60

class LoginRequest(BaseModel):
    email: str
    password: str

class LoginResponse(BaseModel):
    access_token: str
    token_type: str = "bearer"
    user_name: str
    user_type: str

class RegisterRequest(BaseModel):
    nome: str
    email: str
    senha: str
    matricula: str
    telefone: str
    id_tipo_usuario: int

def create_access_token(data: dict, expires_delta: timedelta | None = None):
    to_encode = data.copy()
    if expires_delta:
        expire = datetime.utcnow() + expires_delta
    else:
        expire = datetime.utcnow() + timedelta(minutes=15)
    to_encode.update({"exp": expire})
    encoded_jwt = jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)
    return encoded_jwt

@router.post("/login", response_model=LoginResponse)
def login(request: LoginRequest):
    conn = get_db_connection()
    if not conn:
        raise HTTPException(status_code=500, detail="Erro de conexão com o banco de dados")
    
    try:
        with conn.cursor(cursor_factory=RealDictCursor) as cursor:
            # Em produção as senhas devem ser hasheadas (ex: bcrypt).
            # Como nos seeders usamos texto puro ("123456"), comparamos puramente.
            cursor.execute("""
                SELECT u.id_usuario, u.nome, u.email, u.senha, t.nome_tipo
                FROM usuarios u
                JOIN tipos_usuario t ON u.id_tipo_usuario = t.id_tipo_usuario
                WHERE u.email = %s AND u.ativo = TRUE
            """, (request.email,))
            
            user = cursor.fetchone()
            
            if not user or user["senha"] != request.password:
                raise HTTPException(
                    status_code=status.HTTP_401_UNAUTHORIZED,
                    detail="E-mail ou senha incorretos",
                    headers={"WWW-Authenticate": "Bearer"},
                )
            
            access_token_expires = timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
            access_token = create_access_token(
                data={"sub": user["email"], "id": user["id_usuario"], "role": user["nome_tipo"]},
                expires_delta=access_token_expires
            )
            
            return {
                "access_token": access_token, 
                "token_type": "bearer", 
                "user_name": user["nome"],
                "user_type": user["nome_tipo"]
            }
            
    finally:
        conn.close()

@router.post("/register")
def register(request: RegisterRequest):
    conn = get_db_connection()
    if not conn:
        raise HTTPException(status_code=500, detail="Erro de conexão com o banco de dados")
    
    try:
        with conn.cursor() as cursor:
            # O campo 'ativo' existe na tabela e por padrão é true, mas vamos forçar FALSE para contas novas aguardando aprovação
            cursor.execute("""
                INSERT INTO usuarios (nome, email, senha, matricula, telefone, id_tipo_usuario, ativo)
                VALUES (%s, %s, %s, %s, %s, %s, FALSE)
            """, (request.nome, request.email, request.senha, request.matricula, request.telefone, request.id_tipo_usuario))
            
            conn.commit()
            return {"message": "Cadastro realizado com sucesso! Aguardando aprovação do Administrador."}
    except Exception as e:
        conn.rollback()
        raise HTTPException(status_code=400, detail="Erro ao realizar cadastro (E-mail já existe?)")
    finally:
        conn.close()
