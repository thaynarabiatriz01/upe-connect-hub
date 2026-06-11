
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

