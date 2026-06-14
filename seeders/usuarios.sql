-- Inserindo manualmente usuários 
INSERT INTO usuarios
(nome, email, senha, matricula, telefone, id_tipo_usuario)
VALUES
('Thaynara Biatriz','thaynara.biatriz@upe.br','123456','20250001','87999990001',1),

('Maria Luisa','maria.luisa@upe.br','123456','20250002','87999990002',1),

('João Pedro','joao@upe.br','123456','20250003','87999990003',1),

('Profº Carlos Melo','carlos.melo@upe.br','123456','20250004','87999990004',1),

('Ana Beatriz','ana@upe.br','123456','20250005','87999990005',1),

('Prof. Eraylson','eraylson@upe.br','123456',NULL,'87999990006',2),

('Prof.Clecia Pereira ','clecia.pereira@upe.br','123456',NULL,'87999990007',2),

('Coordenador Vitor', 'vitor@upe.br','123456',NULL,'87999990008',3),

('Pesquisadora Juliana','juliana@upe.br','123456',NULL,'87999990009',4),

('Administrador Sistema','admin@upe.br','123456',NULL,'87999990010',6);

-- Estrutura de Perfis

INSERT INTO perfis
(id_usuario, biografia, periodo, linkedin, github, id_curso)
VALUES
(1,
'Estudante de Licenciatura da Computação e Cloud/DevOps.',
4,
'https://linkedin.com/in/thaynara',
'https://github.com/thaynarabiatriz01',
1),

(2,
'Estudante interessada em Inteligência Artificial.',
3,
'https://linkedin.com/in/maria',
'https://github.com/maria',
1),

(3,
'Estudante de Engenharia de Software.',
5,
'https://linkedin.com/in/joao',
'https://github.com/joao',
2),

(4,
'Estudante de Psicologia.',
2,
NULL,
NULL,
3),

(5,
'Estudante de Medicina.',
6,
NULL,
NULL,
5);




    