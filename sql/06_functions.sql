-- Função para validar se uma vaga ainda aceita candidaturas
CREATE OR REPLACE FUNCTION fn_vaga_aceita_candidatura(p_id_oportunidade INTEGER)
RETURNS BOOLEAN AS $$
DECLARE
    v_status VARCHAR(20);
    v_data_encerramento DATE;
BEGIN
    SELECT status, data_encerramento 
    INTO v_status, v_data_encerramento
    FROM oportunidades
    WHERE id_oportunidade = p_id_oportunidade;

    -- Se a vaga não existir ou estiver fechada
    IF v_status != 'ABERTA' THEN
        RETURN FALSE;
    END IF;

    -- Se a data de encerramento já passou
    IF v_data_encerramento IS NOT NULL AND v_data_encerramento < CURRENT_DATE THEN
        RETURN FALSE;
    END IF;

    RETURN TRUE;
END;
$$ LANGUAGE plpgsql;

-- Função auxiliar que será chamada pela Trigger para log automático de candidatura
CREATE OR REPLACE FUNCTION fn_log_candidatura_trigger()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        INSERT INTO log_candidatura (descricao, id_candidatura, id_usuario)
        VALUES ('Nova candidatura realizada', NEW.id_candidatura, NEW.id_usuario);
    ELSIF TG_OP = 'UPDATE' THEN
        IF OLD.status_candidatura IS DISTINCT FROM NEW.status_candidatura THEN
            INSERT INTO log_candidatura (descricao, id_candidatura, id_usuario)
            VALUES (
                'Status da candidatura alterado de ' || OLD.status_candidatura || ' para ' || NEW.status_candidatura, 
                NEW.id_candidatura, 
                NEW.id_usuario
            );
        END IF;
    END IF;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
