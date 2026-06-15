from fastapi import APIRouter, HTTPException, Depends
from pydantic import BaseModel
from psycopg2.extras import RealDictCursor
from database import get_db_connection
from routers.usuarios import get_current_user

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
            
            for v in vagas:
                # Busca requisitos da vaga
                cursor.execute("SELECT descricao FROM requisitos_vaga WHERE id_vaga = %s", (v['id_vaga'],))
                v['requisitos'] = [x['descricao'] for x in cursor.fetchall()]

                # Busca habilidades da vaga
                cursor.execute("""
                    SELECT h.id_habilidade, h.nome 
                    FROM vaga_habilidades vh
                    JOIN habilidades h ON vh.id_habilidade = h.id_habilidade
                    WHERE vh.id_vaga = %s
                """, (v['id_vaga'],))
                v['habilidades'] = cursor.fetchall()
                
            return {"vagas": vagas}
    finally:
        conn.close()

@router.post("/candidatar")
def candidatar_vaga(req: CandidaturaRequest, user=Depends(get_current_user)):
    if user.get("role") in ["Professor", "Coordenador", "Pesquisador", "Administrador"]:
        raise HTTPException(status_code=403, detail="Apenas estudantes podem se candidatar a vagas.")
        
    conn = get_db_connection()
    if not conn:
        raise HTTPException(status_code=500, detail="Erro de conexão")
    
    try:
        with conn.cursor() as cursor:
            # Aciona a Procedure exata do seu PostgreSQL
            cursor.execute("CALL sp_cadastrar_candidatura(%s, %s)", (user["id"], req.id_vaga))
            conn.commit()
            return {"message": "Candidatura enviada com sucesso! O sistema registrou seu log."}
    except Exception as e:
        conn.rollback()
        # O banco de dados vai jogar as exceptions (EX: "Você já se candidatou para essa vaga") 
        # Isso será pego aqui e devolvido pra tela!
        raise HTTPException(status_code=400, detail=str(e))
    finally:
        conn.close()
