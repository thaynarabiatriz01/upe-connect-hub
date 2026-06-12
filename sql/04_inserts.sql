INSERT INTO habilidades (nome, descricao)
VALUES
('Python', 'Programação e automação de processos'),
('SQL', 'Consultas e gerenciamento de banco de dados'),
('Git e GitHub', 'Controle de versão de projetos');

INSERT INTO certificacoes(nome, instituicao, carga_horaria)
VALUES
('Python para Desenvolvimento', 'Academia Tech', 40),
('Fundamentos de Banco de Dados', 'Instituto Digital', 30),
('Git e GitHub na Prática', 'Centro de Tecnologia Aplicada', 20);

INSERT INTO areas_interesse(nome, descricao)
VALUES
('Desenvolvimento Web', 'Criação de sistemas web'),
('Ciência de Dados', 'Análise de dados'),
('Banco de Dados', 'Modelagem e gerenciamento de dados');

INSERT INTO empresas(razao_social, nome, cnpj, email, telefone, site) 
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
