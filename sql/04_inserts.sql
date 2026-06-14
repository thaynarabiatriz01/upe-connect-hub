INSERT INTO habilidades (nome, descricao)
VALUES
('Python', 'Programação e automação de processos'),
('SQL', 'Consultas e gerenciamento de banco de dados'),
('Git e GitHub', 'Controle de versão de projetos');

INSERT INTO certificacoes(nome, instituicao, carga_horaria)
VALUES
('Python para Desenvolvimento', 'Nexus Time', 40),
('Fundamentos de Banco de Dados', 'Inovação', 30),
('Git e GitHub na Prática', 'Futuro Futurama', 20);

INSERT INTO areas_interesse(nome, descricao)
VALUES
('Desenvolvimento Web', 'Criação de sistemas web'),
('Ciência de Dados', 'Análise de dados'),
('Banco de Dados', 'Modelagem e gerenciamento de dados');

INSERT INTO usuario_habilidades (id_usuario, id_habilidade, nivel)
VALUES
(1, 1, 'Avançado'),
(1, 2, 'Intermediário'),
(2, 2, 'Avançado'),
(2, 3, 'Intermediário'),
(3, 1, 'Básico'),
(3, 3, 'Avançado'),
(4, 1, 'Avançado'),
(4, 2, 'Avançado'),
(5, 2, 'Intermediário'),
(5, 3, 'Básico');

INSERT INTO usuario_certificacoes (id_usuario, id_certificacao, data_conclusao)
VALUES
(1, 1, '2025-05-10'),
(2, 2, '2025-05-20'),
(3, 3, '2025-06-01'),
(4, 1, '2025-04-15'),
(5, 2, '2025-03-10');

INSERT INTO usuario_areas_interesse (id_usuario, id_area)
VALUES
(1, 1),
(1, 3),
(2, 2),
(3, 1),
(3, 2),
(4, 1),
(4, 2),
(4, 3),
(5, 2);
