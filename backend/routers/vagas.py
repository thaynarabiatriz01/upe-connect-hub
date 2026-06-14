from fastapi import APIRouter, HTTPException
from pydantic import BaseModel
from psycopg2.extras import RealDictCursor
from database import get_db_connection

router = APIRouter()

class CandidaturaRequest(BaseModel):
    id_usuario: int
    id_vaga: int

@router.get("/")
def listar_vagas():
    conn = get_db_connection()
    if not conn:
        raise HTTPException(status_code=500, detail="Erro de conexão com o banco de dados")
    
    try:
        with conn.cursor(cursor_factory=RealDictCursor) as cursor:
            # Lê a view que preparamos para o sistema
            cursor.execute("SELECT * FROM vw_vagas_abertas")
            vagas = cursor.fetchall()
            return {"vagas": vagas}
    finally:
        conn.close()

@router.post("/candidatar")
def candidatar_vaga(req: CandidaturaRequest):
    conn = get_db_connection()
    if not conn:
        raise HTTPException(status_code=500, detail="Erro de conexão")
    
    try:
        with conn.cursor() as cursor:
            # Aciona a Procedure exata do seu PostgreSQL
            cursor.execute("CALL sp_cadastrar_candidatura(%s, %s)", (req.id_usuario, req.id_vaga))
            conn.commit()
            return {"message": "Candidatura enviada com sucesso! O sistema registrou seu log."}
    except Exception as e:
        conn.rollback()
        # O banco de dados vai jogar as exceptions (EX: "Você já se candidatou para essa vaga") 
        # Isso será pego aqui e devolvido pra tela!
        raise HTTPException(status_code=400, detail=str(e))
    finally:
        conn.close()
