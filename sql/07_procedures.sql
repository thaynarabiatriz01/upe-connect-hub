CREATE OR REPLACE PROCEDURE publicar_vaga(
    p_titulo VARCHAR,
    p_descricao TEXT,
    p_data_limite DATE,
    p_empresa INTEGER,
    p_tipo INTEGER
)
LANGUAGE plpgsql
AS
$$
BEGIN

INSERT INTO vagas
(
titulo,
descricao,
data_limite,
id_empresa,
id_tipo_vaga
)
VALUES
(
p_titulo,
p_descricao,
p_data_limite,
p_empresa,
p_tipo
);

END;
$$;