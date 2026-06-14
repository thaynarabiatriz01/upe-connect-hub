-- Inserção de Oportunidades Fictícias (Vagas) para popular o banco em testes
-- Considerando que existem empresas cadastradas com IDs 1, 2, etc, e tipos de vaga com IDs 1 (Estágio), 2 (Monitoria)
INSERT INTO vagas (id_vaga, titulo, descricao, data_publicacao, data_limite, quantidade_vagas, id_empresa, id_tipo_vaga, status) VALUES
(4, 'Estágio em Desenvolvimento Web', 'Vaga para atuar no desenvolvimento frontend.', '2026-06-01 08:00:00', '2026-06-30', 1, 1, 1, 'ABERTA'),
(5, 'Monitoria de Redes', 'Vaga destinada a alunos do curso.', '2026-06-05 10:00:00', '2026-06-15', 1, 2, 2, 'FECHADA'),
(6, 'Bolsa de Pesquisa em Visão Computacional', 'Projeto de extensão e pesquisa.', '2026-06-10 09:30:00', '2026-07-10', 1, 3, 3, 'ABERTA');

SELECT setval('vagas_id_vaga_seq', (SELECT MAX(id_vaga) FROM vagas));

-- Inserção de Candidaturas Fictícias
INSERT INTO candidaturas (id_candidatura, data_candidatura, status_candidatura, id_usuario, id_vaga) VALUES
(1, '2026-06-02 14:00:00', 1, 1, 4),
(2, '2026-06-03 15:30:00', 2, 2, 4),
(3, '2026-06-06 09:00:00', 4, 3, 5),
(4, '2026-06-11 11:20:00', 1, 1, 6);

SELECT setval('candidaturas_id_candidatura_seq', (SELECT MAX(id_candidatura) FROM candidaturas));

-- Feedback mockado
INSERT INTO feedback_candidatura (id_feedback_candidatura, data_feedback, comentario, id_candidatura) VALUES
(1, '2026-06-05 10:00:00', 'Currículo muito bom, avançou para a etapa de entrevistas.', 2),
(2, '2026-06-07 14:00:00', 'Infelizmente o aluno ainda não atendeu os pré-requisitos da disciplina.', 3);

SELECT setval('feedback_candidatura_id_feedback_candidatura_seq', (SELECT MAX(id_feedback_candidatura) FROM feedback_candidatura));
