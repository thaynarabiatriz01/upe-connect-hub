CREATE OR REPLACE VIEW vw_notificacoes_usuarios AS
SELECT
    n.id_notificacao,
    u.nome,
    n.titulo,
    n.mensagem,
    n.lida,
    n.data_envio
FROM notificacoes n
JOIN usuarios u
ON n.id_usuario = u.id_usuario;