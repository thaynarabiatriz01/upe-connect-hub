CREATE OR REPLACE PROCEDURE adicionar_habilidade_usuario(
    usuario_id INTEGER,
    habilidade_id INTEGER,
    nivel_habilidade VARCHAR(30)
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO usuario_habilidades (
        id_usuario,
        id_habilidade,
        nivel
    )
    VALUES (
        usuario_id,
        habilidade_id,
        nivel_habilidade
    );
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
    INSERT INTO usuario_certificacoes (
        id_usuario,
        id_certificacao,
        data_conclusao
    )
    VALUES (
        usuario_id,
        certificacao_id,
        data_conclusao_usuario
    );
END;
$$;
