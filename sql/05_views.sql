CREATE VIEW vw_participantes_eventos AS
SELECT 
    e.titulo,
    u.nome,
    p.data_inscricao
FROM participacoes p
JOIN usuarios u
    ON p.id_usuario = u.id_usuario
JOIN eventos e
    ON p.id_evento = e.id_evento;

CREATE VIEW vw_eventos_populares AS
SELECT 
    e.id_evento,
    e.titulo,
    COUNT (p.id_participacao) AS total_inscritos
FROM eventos e
LEFT JOIN participacoes p
    ON e.id_evento = p.id_evento
GROUP BY e.id_evento;