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

SELECT contar_notificacoes_nao_lidas(1);