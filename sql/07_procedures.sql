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
    INSERT INTO representantes_empresa (
        nome,
        email,
        telefone,
        cargo,
        id_empresa
    )
    VALUES (
        nome_representante,
        email_representante,
        telefone_representante,
        cargo_representante,
        empresa_id
    );
END;
$$;
