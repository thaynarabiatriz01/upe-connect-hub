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