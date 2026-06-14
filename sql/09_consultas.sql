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
    v.titulo, 
    COUNT(c.id_candidatura) AS total_candidatos
FROM vagas v
LEFT JOIN candidaturas c ON v.id_vaga = c.id_vaga
GROUP BY v.titulo;

-- Consultar o histórico de logs de uma candidatura (auditoria)
SELECT 
    lc.data_log,
    lc.descricao,
    lc.id_usuario
FROM log_candidatura lc
WHERE lc.id_candidatura = 1
ORDER BY lc.data_log DESC;

SELECT
    empresas.nome_empresa AS empresa,
    representantes_empresa.nome AS representante,
    representantes_empresa.cargo
FROM empresas
INNER JOIN representantes_empresa
    ON empresas.id_empresa = representantes_empresa.id_empresa;

SELECT
    empresas.nome_empresa AS empresa,
    COUNT(representantes_empresa.id_representante) AS quantidade_representantes
FROM empresas
LEFT JOIN representantes_empresa
    ON empresas.id_empresa = representantes_empresa.id_empresa
GROUP BY empresas.nome_empresa;

SELECT
    usuarios.nome AS usuario,
    habilidades.nome AS habilidade,
    usuario_habilidades.nivel
FROM usuarios
INNER JOIN usuario_habilidades
    ON usuarios.id_usuario = usuario_habilidades.id_usuario
INNER JOIN habilidades
    ON habilidades.id_habilidade = usuario_habilidades.id_habilidade;

SELECT
    usuarios.nome,
    usuario_habilidades.nivel
FROM usuarios
INNER JOIN usuario_habilidades
    ON usuarios.id_usuario = usuario_habilidades.id_usuario
INNER JOIN habilidades
    ON habilidades.id_habilidade = usuario_habilidades.id_habilidade
WHERE habilidades.nome = 'SQL';

SELECT
    usuarios.nome AS usuario,
    certificacoes.nome AS certificacao,
    certificacoes.instituicao,
    usuario_certificacoes.data_conclusao
FROM usuarios
INNER JOIN usuario_certificacoes
    ON usuarios.id_usuario = usuario_certificacoes.id_usuario
INNER JOIN certificacoes
    ON certificacoes.id_certificacao = usuario_certificacoes.id_certificacao;

SELECT
    usuarios.nome AS usuario,
    areas_interesse.nome AS area_interesse
FROM usuarios
INNER JOIN usuario_areas_interesse
    ON usuarios.id_usuario = usuario_areas_interesse.id_usuario
INNER JOIN areas_interesse
    ON areas_interesse.id_area = usuario_areas_interesse.id_area;

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
    ON p.id_usuario = u.id_usuario
JOIN eventos e
    ON p.id_evento = e.id_evento;
    

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