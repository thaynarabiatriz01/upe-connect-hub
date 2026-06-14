
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
