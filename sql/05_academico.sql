CREATE TABLE projetos (
    id_projeto INT,
    titulo VARCHAR(150),
    descricao TEXT,
    tipo_projeto VARCHAR(50),
    data_inicio DATE,
    data_fim DATE,
    PRIMARY KEY (id_projeto)
);

CREATE TABLE orientadores (
    id_orientador INT,
    id_usuario INT,
    area_atuacao VARCHAR(100),
    PRIMARY KEY (id_orientador)
);

CREATE TABLE participantes_projeto (
    id_participante INT,
    id_projeto INT,
    id_usuario INT,
    funcao VARCHAR(50),
    PRIMARY KEY (id_participante)
);

CREATE TABLE eventos (
    id_evento INT,
    nome_evento VARCHAR(150),
    descricao TEXT,
    local_evento VARCHAR(100),
    data_evento DATE,
    PRIMARY KEY (id_evento)
);

CREATE TABLE participacoes (
    id_participacao INT,
    id_evento INT,
    id_usuario INT,
    status_participacao VARCHAR(30),
    PRIMARY KEY (id_participacao)
);

CREATE TABLE certificados (
    id_certificado INT,
    id_usuario INT,
    id_evento INT,
    carga_horaria INT,
    data_emissao DATE,
    PRIMARY KEY (id_certificado)
);
