-- Consultar todas as vagas abertas
SELECT * FROM vw_vagas_abertas;

-- Consultar o detalhamento de uma candidatura específica e seu feedback atual
SELECT * FROM vw_candidaturas_completas
WHERE id_candidatura = 2;

-- Contar o número de candidaturas por vaga
SELECT 
    o.titulo, 
    COUNT(c.id_candidatura) AS total_candidatos
FROM oportunidades o
LEFT JOIN candidaturas c ON o.id_oportunidade = c.id_oportunidade
GROUP BY o.titulo;

-- Consultar o histórico de logs de uma candidatura (auditoria)
SELECT 
    lc.data_log,
    lc.descricao,
    lc.id_usuario
FROM log_candidatura lc
WHERE lc.id_candidatura = 1
ORDER BY lc.data_log DESC;
