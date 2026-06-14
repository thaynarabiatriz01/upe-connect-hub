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

CREATE VIEW representantes_empresas AS
SELECT
    empresas.nome_empresa AS empresa,
    representantes_empresa.nome AS representante,
    representantes_empresa.cargo,
    representantes_empresa.email,
    representantes_empresa.telefone
FROM empresas
INNER JOIN representantes_empresa
ON empresas.id_empresa = representantes_empresa.id_empresa;

CREATE VIEW habilidades_usuarios AS
SELECT
    usuarios.id_usuario,
    usuarios.nome AS usuario,
    habilidades.nome AS habilidade,
    usuario_habilidades.nivel
FROM usuarios
INNER JOIN usuario_habilidades
ON usuarios.id_usuario = usuario_habilidades.id_usuario
INNER JOIN habilidades
ON habilidades.id_habilidade = usuario_habilidades.id_habilidade;

CREATE VIEW certificacoes_usuarios AS
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

CREATE VIEW areas_interesse_usuarios AS
SELECT
    usuarios.nome AS usuario,
    areas_interesse.nome AS area_interesse
FROM usuarios
INNER JOIN usuario_areas_interesse
ON usuarios.id_usuario = usuario_areas_interesse.id_usuario
INNER JOIN areas_interesse
ON areas_interesse.id_area = usuario_areas_interesse.id_area;
