SELECT
    u.nome,
    n.titulo,
    n.mensagem
FROM usuarios u
JOIN notificacoes n
ON u.id_usuario = n.id_usuario;

SELECT *
FROM notificacoes
WHERE lida = FALSE;

SELECT *
FROM notificacoes
WHERE lida = FALSE;

SELECT *
FROM auditoria
ORDER BY data_operacao DESC;