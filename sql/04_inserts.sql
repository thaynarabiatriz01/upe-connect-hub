
-- adicionando departamentos
INSERT INTO departamentos(nome, descricao)
VALUES
('Computação', 'Departamento de Computação'),
('Engenharia', 'Departamento de Engenharia'),
('Psicologia', 'Departamento de Psicologia'),
('Matemática', 'Departamento de Matemática'),
('Medicina', 'Departamento de Medicina');


-- adicionando e cadastrando os cursos com seus nomes e siglas

INSERT INTO cursos (nome, sigla, id_departamento)
VALUES
('Licenciatura em Computação', 'CC', 1),
('Engenharia de Software', 'ES', 2),
('Psicologia', 'PSI', 3),
('Matemática', 'MAT', 4),
('Medicina', 'MED', 5);

-- Inserindo os tipos de usuarios que acessaram ao upe_connec_thub
INSERT INTO tipos_usuario (nome_tipo)
VALUES
('Aluno'),
('Professor'),
('Coordenador'),
('Pesquisador'),
('Monitor'),
('Administrador');

INSERT INTO usuarios (nome, email, senha, matricula, telefone, id_tipo_usuario)
VALUES
('Maria Luísa Maurício',
 'maria.mauricio@upe.br',
 '123456',
 '20230001',
 '(11) 11111-1111',
 1),
('Everton Vilela de Sá',
 'everton.sa@upe.br',
 '1234567',
 20230002',
 '(33) 33333-3333',
 1),
('Thaynara Biatriz',
 'thaynara.biatriz@upe.br',
 '12345678',
 '20230003',
 '(44) 44444-4444',
 1),
('Sarah Cavalvante',
 'sarah.cavalcante@upe.br',
 '123456',
 '20230004',
 '(55) 55555-5555',
 2),
('Gisele Andrade',
 'gisele.andrade@upe.br',
 '123456',
 '20230005',
 '(87) 99999-5555',
 3);

-- Inserção dos dados estáticos (domínios) para as tabelas do módulo de Candidaturas

INSERT INTO status_candidatura (id_status_candidatura, descricao) VALUES
(1, 'Em Análise'),
(2, 'Aprovado para Entrevista'),
(3, 'Selecionado'),
(4, 'Não Selecionado'),
(5, 'Cancelado pelo Usuário')
ON CONFLICT (id_status_candidatura) DO NOTHING;

-- Ajusta a sequência após as inserções manuais para evitar conflitos de IDs
SELECT setval('status_candidatura_id_status_candidatura_seq', (SELECT MAX(id_status_candidatura) FROM status_candidatura));

INSERT INTO empresas(razao_social, nome_empresa, cnpj, email, telefone, site) 
VALUES
('Inovação aqui é a solução', 
 'Inovação', 
 '11.111.111/0001-11',
 'contato@inovação.com',
 '(11) 11111-1111',
 'www.inovação.com'),
('Nexus Time aqui tem tempo', 
 'Nexus Time', 
 '22.222.222/0001-22',
 'contato@nexustime.com',
 '(22) 22222-2222',
 'www.nexustime.com'),
('Futuro do Futurama é Tecnologia',
 'FuturoFuturama',
 '33.333.333/0001-33',
 'contato@futurofuturama.com',
 '(33) 33333-3333',
 'www.futurecode.com');

INSERT INTO representantes_empresa(nome, email, telefone, cargo, id_empresa)
VALUES
('Maria Luísa Maurício',
 'maria.mauricio@inovatech.com',
 '(44) 44444-4444',
 'Analista de Recrutamento',
 1),
('Everton Vilela de Sá',
 'everton.sa@nexussistemas.com',
 '(55) 55555-5555',
 'Coordenador de Talentos',
 2),
('Thaynara Biatriz',
 'thaynara.biatriz@futurecode.com',
 '(66) 66666-6666',
 'Gestora de Pessoas',
  3);

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
