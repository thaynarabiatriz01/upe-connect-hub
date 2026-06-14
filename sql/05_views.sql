CREATE OR REPLACE VIEW vw_usuarios_cursos AS 
SELECT
    u.id_usuario,
    u.nome,
    u.email,
    tu.nome_tipo,
    c.nome AS curso
FROM usuarios u
JOIN tipos_usuario tu
    ON u.id_tipo_usuario = tu.id_tipo_usuario
LEFT JOIN perfis p  
    ON u.id_usuario = p.id_usuario
LEFT JOIN cursos c  
    ON p.id_curso = c.id_curso;    

CREATE OR REPLACE VIEW vw_vagas_abertas AS
SELECT 
    v.id_vaga,
    v.titulo,
    v.descricao,
    v.data_publicacao,
    v.data_limite,
    e.nome_empresa,
    tv.nome_tipo AS tipo_vaga
FROM vagas v
LEFT JOIN empresas e ON v.id_empresa = e.id_empresa
JOIN tipos_vaga tv ON v.id_tipo_vaga = tv.id_tipo_vaga
WHERE v.status = 'ABERTA' 
  AND v.data_limite >= CURRENT_DATE;

CREATE OR REPLACE VIEW vw_candidaturas_completas AS
SELECT 
    c.id_candidatura,
    c.data_candidatura,
    c.id_usuario,
    v.titulo AS vaga_titulo,
    v.id_empresa,
    sc.descricao AS status_atual,
    (SELECT fc.comentario FROM feedback_candidatura fc WHERE fc.id_candidatura = c.id_candidatura ORDER BY fc.data_feedback DESC LIMIT 1) AS ultimo_feedback
FROM candidaturas c
JOIN vagas v ON c.id_vaga = v.id_vaga
JOIN status_candidatura sc ON c.status_candidatura = sc.id_status_candidatura;

CREATE OR REPLACE VIEW vw_representantes_empresas AS
SELECT
    e.nome_empresa AS empresa,
    r.nome AS representante,
    r.cargo,
    r.email,
    r.telefone
FROM empresas e
JOIN representantes_empresa r
ON e.id_empresa = r.id_empresa;

CREATE OR REPLACE VIEW vw_habilidades_usuarios AS
SELECT
    u.id_usuario,
    u.nome AS usuario,
    h.nome AS habilidade,
    uh.nivel
FROM usuarios u
JOIN usuario_habilidades uh ON u.id_usuario = uh.id_usuario
JOIN habilidades h ON h.id_habilidade = uh.id_habilidade;

CREATE OR REPLACE VIEW vw_participantes_eventos AS
SELECT 
    e.titulo,
    u.nome,
    p.data_inscricao
FROM participacoes p
JOIN usuarios u ON p.id_usuario = u.id_usuario
JOIN eventos e ON p.id_evento = e.id_evento;

CREATE OR REPLACE VIEW vw_eventos_populares AS
SELECT 
    e.id_evento,
    e.titulo,
    COUNT(p.id_participacao) AS total_inscritos
FROM eventos e
LEFT JOIN participacoes p ON e.id_evento = p.id_evento
GROUP BY e.id_evento, e.titulo;

CREATE OR REPLACE VIEW vw_candidaturas_por_curso AS
SELECT 
    c.nome AS curso,
    COUNT(cand.id_candidatura) AS total_candidaturas
FROM candidaturas cand
JOIN usuarios u ON cand.id_usuario = u.id_usuario
JOIN perfis p ON u.id_usuario = p.id_usuario
JOIN cursos c ON p.id_curso = c.id_curso
GROUP BY c.nome;

CREATE OR REPLACE VIEW vw_alunos_certificados AS
SELECT
    u.nome AS usuario,
    c.nome AS curso,
    cert.nome AS certificacao,
    cert.instituicao,
    uc.data_conclusao
FROM usuarios u
JOIN perfis p ON u.id_usuario = p.id_usuario
JOIN cursos c ON p.id_curso = c.id_curso
JOIN usuario_certificacoes uc ON u.id_usuario = uc.id_usuario
JOIN certificacoes cert ON cert.id_certificacao = uc.id_certificacao;

CREATE OR REPLACE VIEW vw_habilidades_requisitadas AS
SELECT 
    h.nome AS habilidade,
    COUNT(vh.id_vaga) AS total_vagas
FROM habilidades h
JOIN vaga_habilidades vh ON h.id_habilidade = vh.id_habilidade
GROUP BY h.nome;
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