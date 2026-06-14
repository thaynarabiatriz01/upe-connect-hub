-- Inserção de Oportunidades Fictícias (Vagas) para popular o banco em testes
-- Considerando que existem empresas cadastradas com IDs 1, 2, etc, e tipos de vaga com IDs 1 (Estágio), 2 (Monitoria)
INSERT INTO oportunidades (id_oportunidade, titulo, descricao, data_criacao, data_encerramento, id_empresa, id_tipo_vaga, status) VALUES
(1, 'Estágio em Desenvolvimento de Software', 'Vaga para atuar no desenvolvimento de sistemas web em Python e React.', '2026-06-01 08:00:00', '2026-06-30', 1, 1, 'ABERTA'),
(2, 'Monitoria de Banco de Dados', 'Vaga destinada a alunos do curso de Licenciatura em Computação que já cursaram a disciplina.', '2026-06-05 10:00:00', '2026-06-15', NULL, 2, 'FECHADA'),
(3, 'Bolsa de Pesquisa em IA', 'Projeto de extensão e pesquisa aplicada em modelos de linguagem no laboratório.', '2026-06-10 09:30:00', '2026-07-10', NULL, 3, 'ABERTA');

SELECT setval('oportunidades_id_oportunidade_seq', (SELECT MAX(id_oportunidade) FROM oportunidades));

-- Inserção de Candidaturas Fictícias
-- Assumindo usuários de ID 1, 2 e 3 existentes no sistema
INSERT INTO candidaturas (id_candidatura, data_candidatura, status_candidatura, id_usuario, id_oportunidade) VALUES
(1, '2026-06-02 14:00:00', 1, 1, 1),
(2, '2026-06-03 15:30:00', 2, 2, 1),
(3, '2026-06-06 09:00:00', 4, 3, 2),
(4, '2026-06-11 11:20:00', 1, 1, 3);

SELECT setval('candidaturas_id_candidatura_seq', (SELECT MAX(id_candidatura) FROM candidaturas));

-- Feedback mockado
INSERT INTO feedback_candidatura (id_feedback_candidatura, data_feedback, comentario, id_candidatura) VALUES
(1, '2026-06-05 10:00:00', 'Currículo muito bom, avançou para a etapa de entrevistas.', 2),
(2, '2026-06-07 14:00:00', 'Infelizmente o aluno ainda não atendeu os pré-requisitos da disciplina.', 3);

SELECT setval('feedback_candidatura_id_feedback_candidatura_seq', (SELECT MAX(id_feedback_candidatura) FROM feedback_candidatura));
