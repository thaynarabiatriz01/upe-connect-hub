-- Cadastrar uma nova candidatura com validação (RN08)
CREATE OR REPLACE PROCEDURE sp_cadastrar_candidatura(
    p_id_usuario INTEGER,
    p_id_oportunidade INTEGER
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Verifica se a vaga ainda aceita candidaturas (se está ABERTA e ou dentro do prazo)
    IF NOT fn_vaga_aceita_candidatura(p_id_oportunidade) THEN
        RAISE EXCEPTION 'Não é possível se candidatar. A oportunidade não está aberta ou o prazo expirou.';
    END IF;

    -- Verifica se o usuário já se candidatou para essa vaga
    IF EXISTS (
        SELECT 1 FROM candidaturas 
        WHERE id_usuario = p_id_usuario AND id_oportunidade = p_id_oportunidade
    ) THEN
        RAISE EXCEPTION 'O usuário já realizou uma candidatura para esta oportunidade.';
    END IF;

    -- Insere a candidatura com status inicial 'Em Análise' (ID = 1)
    INSERT INTO candidaturas (status_candidatura, id_usuario, id_oportunidade)
    VALUES (1, p_id_usuario, p_id_oportunidade);
    
    -- O log será gerado automaticamente pela Trigger
END;
$$;

-- Publicar uma nova vaga/oportunidade
CREATE OR REPLACE PROCEDURE sp_publicar_vaga(
    p_titulo VARCHAR,
    p_descricao TEXT,
    p_data_encerramento DATE,
    p_id_empresa INTEGER,
    p_id_tipo_vaga INTEGER
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO oportunidades (titulo, descricao, data_encerramento, id_empresa, id_tipo_vaga, status)
    VALUES (p_titulo, p_descricao, p_data_encerramento, p_id_empresa, p_id_tipo_vaga, 'ABERTA');
END;
$$;
