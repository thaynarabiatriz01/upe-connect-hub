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
