-- Cadastrar uma nova candidatura com validação (RN08)
CREATE OR REPLACE PROCEDURE sp_cadastrar_candidatura(
    p_id_usuario INTEGER,
    p_id_vaga INTEGER
)
LANGUAGE plpgsql
AS $$
BEGIN
    -- Verifica se a vaga ainda aceita candidaturas (se está ABERTA e dentro do prazo)
    IF NOT fn_vaga_aceita_candidatura(p_id_vaga) THEN
        RAISE EXCEPTION 'Não é possível se candidatar. A vaga não está aberta ou o prazo expirou.';
    END IF;

    -- Verifica se o usuário já se candidatou para essa vaga
    IF EXISTS (
        SELECT 1 FROM candidaturas 
        WHERE id_usuario = p_id_usuario AND id_vaga = p_id_vaga
    ) THEN
        RAISE EXCEPTION 'O usuário já realizou uma candidatura para esta vaga.';
    END IF;

    -- Insere a candidatura com status inicial 'Em Análise' (ID = 1)
    INSERT INTO candidaturas (status_candidatura, id_usuario, id_vaga)
    VALUES (1, p_id_usuario, p_id_vaga);
    
    -- O log será gerado automaticamente pela Trigger
END;
$$;

-- Publicar uma nova vaga
CREATE OR REPLACE PROCEDURE publicar_vaga(
    p_titulo VARCHAR,
    p_descricao TEXT,
    p_data_limite DATE,
    p_empresa INTEGER,
    p_tipo INTEGER,
    p_id_usuario INTEGER
)
LANGUAGE plpgsql
AS
$$
BEGIN
    INSERT INTO vagas (titulo, descricao, data_limite, id_empresa, id_tipo_vaga, id_usuario)
    VALUES (p_titulo, p_descricao, p_data_limite, p_empresa, p_tipo, p_id_usuario);
END;
$$;

CREATE OR REPLACE PROCEDURE cadastrar_representante_empresa(
    nome_representante VARCHAR(150),
    email_representante VARCHAR(150),
    telefone_representante VARCHAR(20),
    cargo_representante VARCHAR(100),
    empresa_id INTEGER
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO representantes_empresa (nome, email, telefone, cargo, id_empresa)
    VALUES (nome_representante, email_representante, telefone_representante, cargo_representante, empresa_id);
END;
$$;

CREATE OR REPLACE PROCEDURE adicionar_habilidade_usuario(
    usuario_id INTEGER,
    habilidade_id INTEGER,
    nivel_habilidade VARCHAR(30)
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO usuario_habilidades (id_usuario, id_habilidade, nivel)
    VALUES (usuario_id, habilidade_id, nivel_habilidade);
END;
$$;

CREATE OR REPLACE PROCEDURE adicionar_certificacao_usuario(
    usuario_id INTEGER,
    certificacao_id INTEGER,
    data_conclusao_usuario DATE
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO usuario_certificacoes (id_usuario, id_certificacao, data_conclusao)
    VALUES (usuario_id, certificacao_id, data_conclusao_usuario);
END;
$$;

CREATE OR REPLACE PROCEDURE gerar_relatorio_empregabilidade()
LANGUAGE plpgsql
AS $$
DECLARE
    v_total_vagas INTEGER;
    v_total_candidaturas INTEGER;
    v_selecionados INTEGER;
BEGIN
    SELECT COUNT(*) INTO v_total_vagas FROM vagas;
    SELECT COUNT(*) INTO v_total_candidaturas FROM candidaturas;
    
    -- Considerando status_candidatura = 3 como 'Selecionado' (ver 04_inserts.sql)
    SELECT COUNT(*) INTO v_selecionados FROM candidaturas WHERE status_candidatura = 3;

    RAISE NOTICE '--- Relatório de Empregabilidade ---';
    RAISE NOTICE 'Total de Vagas Publicadas: %', v_total_vagas;
    RAISE NOTICE 'Total de Candidaturas: %', v_total_candidaturas;
    RAISE NOTICE 'Alunos Selecionados: %', v_selecionados;
    
    -- Aqui poderia ser salvo na tabela de auditoria ou em uma tabela de relatórios consolidada.
    INSERT INTO auditoria (operacao, tabela_afetada, dados_novos)
    VALUES ('GERACAO_RELATORIO', 'vagas/candidaturas', jsonb_build_object('total_vagas', v_total_vagas, 'selecionados', v_selecionados));
END;
$$;