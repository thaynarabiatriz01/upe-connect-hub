from fastapi import APIRouter, HTTPException, Depends, Header
from pydantic import BaseModel
from jose import jwt
from psycopg2.extras import RealDictCursor
from database import get_db_connection

router = APIRouter()

SECRET_KEY = "upe-connect-hub-secret-key"
ALGORITHM = "HS256"

def get_current_docente(authorization: str = Header(None)):
    if not authorization or not authorization.startswith("Bearer "):
        raise HTTPException(status_code=401, detail="Token não fornecido ou inválido")
    
    token = authorization.split(" ")[1]
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        role = payload.get("role")
        # Permite Professor, Coordenador e Pesquisador
        if role not in ["Professor", "Coordenador", "Pesquisador"]:
            raise HTTPException(status_code=403, detail="Acesso restrito a docentes e pesquisadores.")
        return payload
    except Exception:
        raise HTTPException(status_code=401, detail="Sessão expirada ou token adulterado.")

class VagaRequest(BaseModel):
    titulo: str
    descricao: str
    data_limite: str
    quantidade_vagas: int
    id_tipo_vaga: int
    id_empresa: int

@router.post("/vagas")
def criar_vaga(req: VagaRequest, docente=Depends(get_current_docente)):
    conn = get_db_connection()
    try:
        with conn.cursor() as cursor:
            # Chama a procedure publicar_vaga enviando o ID do docente logado
            cursor.execute("CALL publicar_vaga(%s, %s, %s, %s, %s, %s)", 
                           (req.titulo, req.descricao, req.data_limite, req.id_empresa, req.id_tipo_vaga, docente['id']))
            
            # Se a quantidade for > 1, fazemos um update rápido
            if req.quantidade_vagas > 1:
                cursor.execute("UPDATE vagas SET quantidade_vagas = %s WHERE titulo = %s AND id_empresa = %s", 
                               (req.quantidade_vagas, req.titulo, req.id_empresa))
            
            conn.commit()
            return {"message": "Vaga publicada com sucesso!"}
    except Exception as e:
        conn.rollback()
        raise HTTPException(status_code=400, detail="Erro ao publicar vaga: " + str(e))
    finally:
        conn.close()

@router.get("/vagas")
def listar_minhas_vagas(docente=Depends(get_current_docente)):
    conn = get_db_connection()
    try:
        with conn.cursor(cursor_factory=RealDictCursor) as cursor:
            # Retorna apenas as vagas publicadas por ESTE docente
            cursor.execute("""
                SELECT v.id_vaga, v.titulo, v.descricao, e.nome_empresa, v.quantidade_vagas, v.data_limite, v.status, v.id_tipo_vaga
                FROM vagas v
                JOIN empresas e ON v.id_empresa = e.id_empresa
                WHERE v.id_usuario = %s
                ORDER BY v.id_vaga DESC
            """, (docente['id'],))
            results = cursor.fetchall()
            for r in results:
                if r['data_limite']:
                    r['data_limite'] = r['data_limite'].strftime('%Y-%m-%d')
            return results
    finally:
        conn.close()

@router.delete("/vagas/{id_vaga}")
def excluir_minha_vaga(id_vaga: int, docente=Depends(get_current_docente)):
    conn = get_db_connection()
    try:
        with conn.cursor() as cursor:
            # Verifica se a vaga pertence ao docente logado
            cursor.execute("SELECT id_usuario FROM vagas WHERE id_vaga = %s", (id_vaga,))
            vaga = cursor.fetchone()
            if not vaga:
                raise HTTPException(status_code=404, detail="Vaga não encontrada.")
            if vaga[0] != docente['id']:
                raise HTTPException(status_code=403, detail="Você não tem permissão para excluir uma vaga de outro pesquisador/professor.")

            # Deleta as candidaturas relacionadas para não dar erro de FK
            cursor.execute("DELETE FROM candidaturas WHERE id_vaga = %s", (id_vaga,))
            # Deleta a vaga
            cursor.execute("DELETE FROM vagas WHERE id_vaga = %s", (id_vaga,))
            conn.commit()
            return {"message": "Vaga e candidaturas relacionadas excluídas com sucesso."}
    except Exception as e:
        conn.rollback()
        raise HTTPException(status_code=400, detail="Erro ao excluir: " + str(e))
    finally:
        conn.close()

@router.put("/vagas/{id_vaga}")
def editar_minha_vaga(id_vaga: int, req: VagaRequest, docente=Depends(get_current_docente)):
    conn = get_db_connection()
    try:
        with conn.cursor() as cursor:
            cursor.execute("SELECT id_usuario FROM vagas WHERE id_vaga = %s", (id_vaga,))
            vaga = cursor.fetchone()
            if not vaga:
                raise HTTPException(status_code=404, detail="Vaga não encontrada.")
            if vaga[0] != docente['id']:
                raise HTTPException(status_code=403, detail="Você não tem permissão para editar esta vaga.")

            cursor.execute("""
                UPDATE vagas 
                SET titulo = %s, descricao = %s, data_limite = %s, quantidade_vagas = %s, id_tipo_vaga = %s 
                WHERE id_vaga = %s
            """, (req.titulo, req.descricao, req.data_limite, req.quantidade_vagas, req.id_tipo_vaga, id_vaga))
            conn.commit()
            return {"message": "Vaga atualizada com sucesso."}
    except Exception as e:
        conn.rollback()
        raise HTTPException(status_code=400, detail="Erro ao atualizar: " + str(e))
    finally:
        conn.close()

@router.get("/vagas/{id_vaga}/candidaturas")
def listar_candidaturas_da_vaga(id_vaga: int, docente=Depends(get_current_docente)):
    conn = get_db_connection()
    try:
        with conn.cursor(cursor_factory=RealDictCursor) as cursor:
            cursor.execute("""
                SELECT c.id_candidatura, u.nome, u.email, u.telefone, s.descricao as status, c.data_candidatura
                FROM candidaturas c
                JOIN usuarios u ON c.id_usuario = u.id_usuario
                JOIN status_candidatura s ON c.status_candidatura = s.id_status_candidatura
                WHERE c.id_vaga = %s
                ORDER BY c.data_candidatura DESC
            """, (id_vaga,))
            results = cursor.fetchall()
            for r in results:
                if r['data_candidatura']:
                    r['data_candidatura'] = r['data_candidatura'].strftime('%Y-%m-%d %H:%M')
            return results
    finally:
        conn.close()

@router.put("/candidaturas/{id_candidatura}/status")
def atualizar_status_candidatura(id_candidatura: int, novo_status: int, docente=Depends(get_current_docente)):
    conn = get_db_connection()
    try:
        with conn.cursor() as cursor:
            cursor.execute("""
                UPDATE candidaturas 
                SET status_candidatura = %s 
                WHERE id_candidatura = %s
                RETURNING id_candidatura
            """, (novo_status, id_candidatura))
            if not cursor.fetchone():
                raise HTTPException(status_code=404, detail="Candidatura não encontrada.")
            conn.commit()
            return {"message": "Status atualizado com sucesso!"}
    except Exception as e:
        conn.rollback()
        raise HTTPException(status_code=400, detail="Erro ao atualizar: " + str(e))
    finally:
        conn.close()
