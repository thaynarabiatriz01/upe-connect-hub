-- Função para validar se uma vaga ainda aceita candidaturas
CREATE OR REPLACE FUNCTION fn_vaga_aceita_candidatura(p_id_vaga INTEGER)
RETURNS BOOLEAN AS $$
DECLARE
    v_status VARCHAR(20);
    v_data_limite DATE;
BEGIN
    SELECT status, data_limite 
    INTO v_status, v_data_limite
    FROM vagas
    WHERE id_vaga = p_id_vaga;

    -- Se a vaga não existir ou estiver fechada
    IF v_status != 'ABERTA' THEN
        RETURN FALSE;
    END IF;

    -- Se a data limite já passou
    IF v_data_limite IS NOT NULL AND v_data_limite < CURRENT_DATE THEN
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

-- Funções adicionais e consolidadas

CREATE OR REPLACE FUNCTION verificar_cnpj_empresa()
RETURNS TRIGGER
AS $$
BEGIN
    IF NEW.cnpj IS NULL OR NEW.cnpj = '' THEN
        RAISE EXCEPTION 'O CNPJ da empresa é obrigatório.';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION validar_nivel_habilidade()
RETURNS TRIGGER
AS $$
BEGIN
    IF NEW.nivel NOT IN ('Básico', 'Intermediário', 'Avançado') THEN
        RAISE EXCEPTION 'Nível de habilidade inválido.';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION preencher_data_certificacao()
RETURNS TRIGGER
AS $$
BEGIN
    IF NEW.data_conclusao IS NULL THEN
        NEW.data_conclusao := CURRENT_DATE;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Função auxiliar que será chamada pela Trigger para notificação automática de vaga
CREATE OR REPLACE FUNCTION fn_notificacao_nova_vaga_trigger()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO notificacoes (id_usuario, mensagem)
    SELECT id_usuario, 'Nova vaga publicada: ' || NEW.titulo
    FROM usuarios
    WHERE ativo = TRUE;
    
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION contar_notificacoes_nao_lidas(
    p_usuario INTEGER
)
RETURNS INTEGER
AS $$
DECLARE
    total INTEGER;
BEGIN

    SELECT COUNT(*)
    INTO total
    FROM notificacoes
    WHERE id_usuario = p_usuario
    AND lida = FALSE;

    RETURN total;

END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION fechar_vagas_expiradas()
RETURNS TRIGGER
AS
$$
BEGIN
    IF NEW.data_limite < CURRENT_DATE THEN
        NEW.status := 'ENCERRADA';
    END IF;
    RETURN NEW;
END;
$$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION registrar_log()
RETURNS TRIGGER
AS $$
BEGIN

    INSERT INTO logs(
        tabela_afetada,
        operacao,
        descricao
    )
    VALUES(
        TG_TABLE_NAME,
        TG_OP,
        'Operação executada automaticamente'
    );

    RETURN NEW;

END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION registrar_auditoria()
RETURNS TRIGGER
AS $$
BEGIN

    INSERT INTO auditoria(
        tabela_afetada,
        operacao,
        dados_novos
    )
    VALUES(
        TG_TABLE_NAME,
        TG_OP,
        row_to_json(NEW)::JSONB
    );

    RETURN NEW;

END;
$$ LANGUAGE plpgsql;
