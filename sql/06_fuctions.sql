CREATE OR REPLACE FUNCTION vaga_disponivel(
    p_vaga INTEGER
)
RETURNS BOOLEAN
AS
$$

DECLARE
    resultado BOOLEAN;

BEGIN

    SELECT
        CASE
            WHEN status = 'ABERTA'
            THEN TRUE
            ELSE FALSE
        END

    INTO resultado

    FROM vagas

    WHERE id_vaga = p_vaga;

    RETURN resultado;

END;

$$
LANGUAGE plpgsql;