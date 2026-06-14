-- Listar todos os usuários

SELECT *
FROM usuarios;

-- Usuários por curso

SELECT
    u.nome,
    c.nome AS curso
FROM usuarios u
JOIN perfis p
    ON u.id_usuario = p.id_usuario
JOIN cursos c
    ON p.id_curso = c.id_curso;

-- Professores

SELECT
    u.nome,
    u.email
FROM usuarios u
JOIN tipos_usuario tu
    ON u.id_tipo_usuario = tu.id_tipo_usuario
WHERE tu.nome_tipo = 'Professor';

-- Quantidade de usuários por tipo

SELECT
    tu.nome_tipo,
    COUNT(*) AS quantidade
FROM usuarios u
JOIN tipos_usuario tu
    ON u.id_tipo_usuario = tu.id_tipo_usuario
GROUP BY tu.nome_tipo;

-- Usuários e departamentos

SELECT
    u.nome,
    c.nome AS curso,
    d.nome AS departamento
FROM usuarios u
JOIN perfis p
    ON u.id_usuario = p.id_usuario
JOIN cursos c
    ON p.id_curso = c.id_curso
JOIN departamentos d
    ON c.id_departamento = d.id_departamento;
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
