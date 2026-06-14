CREATE VIEW vw_usuarios_cursos AS SELECT
SELECT
    u.id_usuario,
    u.nome,
    u.email,
    tu.nome_tipo,
    c.nome AS CURSO
FROM usuarios u
JOIN tipos_usuario tu
    ON u.id_tipo_usuario = tu.id_tipo_usuario
LEFT JOIN perfis p  
    ON u.id_usuario = p.id_usuario
LEFT JOIN cursos c  
    ON p.id_curso = c.id_curso;    

-- View para leitura das oportunidades que ainda estão abertas e dentro do prazo
CREATE OR REPLACE VIEW vw_vagas_abertas AS
SELECT 
    o.id_oportunidade,
    o.titulo,
    o.descricao,
    o.data_criacao,
    o.data_encerramento,
    o.id_empresa,
    o.id_tipo_vaga
FROM oportunidades o
WHERE o.status = 'ABERTA' 
  AND (o.data_encerramento IS NULL OR o.data_encerramento >= CURRENT_DATE);

-- Consulta ao histórico de candidaturas com os status textuais e detalhes da vaga
CREATE OR REPLACE VIEW vw_candidaturas_completas AS
SELECT 
    c.id_candidatura,
    c.data_candidatura,
    c.id_usuario,
    o.titulo AS oportunidade_titulo,
    o.id_empresa,
    sc.descricao AS status_atual,
    (SELECT fc.comentario FROM feedback_candidatura fc WHERE fc.id_candidatura = c.id_candidatura ORDER BY fc.data_feedback DESC LIMIT 1) AS ultimo_feedback
FROM candidaturas c
JOIN oportunidades o ON c.id_oportunidade = o.id_oportunidade
JOIN status_candidatura sc ON c.status_candidatura = sc.id_status_candidatura;
