SELECT * FROM eventos;

-- Participantes de um evento
SELECT
    e.titulo,
    u.nome
FROM participacoes p 
JOIN usuarios u
    ON p.id_usuario = u.id_usuario
JOIN eventos e
    ON p.id_evento = e.id_evento;


--certificados emitidos

SELECT
    u.nome,
    e.titulo,
    c.codigo_validacao
FROM certificados c
JOIN participacoes p
    ON c.id_participacao = p.id_participacao
JOIN usuarios u
    ON p.id_evento = e.id_evento;
    
