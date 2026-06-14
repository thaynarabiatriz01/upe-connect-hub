CREATE OR REPLACE PROCEDURE marcar_notificacoes_lidas(
    p_usuario INTEGER
)
LANGUAGE plpgsql
AS $$
BEGIN

    UPDATE notificacoes
    SET lida = TRUE
    WHERE id_usuario = p_usuario;

END;
$$;