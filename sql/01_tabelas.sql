CREATE TABLE habilidades (
    id_habilidade SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL UNIQUE,
    descricao TEXT
);

CREATE TABLE usuario_habilidades (
    id_usuario INTEGER NOT NULL,
    id_habilidade INTEGER NOT NULL,
    nivel VARCHAR(30),
    PRIMARY KEY (id_usuario, id_habilidade),
    CONSTRAINT fk_usuario_habilidades_usuario
        FOREIGN KEY (id_usuario)
        REFERENCES usuarios(id_usuario),
    CONSTRAINT fk_usuario_habilidades_habilidade
        FOREIGN KEY (id_habilidade)
        REFERENCES habilidades(id_habilidade)
);

CREATE TABLE certificacoes (
    id_certificacao SERIAL PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    instituicao VARCHAR(150),
    carga_horaria INTEGER
);

CREATE TABLE usuario_certificacoes (
    id_usuario INTEGER NOT NULL,
    id_certificacao INTEGER NOT NULL,
    data_conclusao DATE,
    arquivo_comprovante VARCHAR(255),
    PRIMARY KEY (id_usuario, id_certificacao),
    CONSTRAINT fk_usuario_certificacoes_usuario
        FOREIGN KEY (id_usuario)
        REFERENCES usuarios(id_usuario),
    CONSTRAINT fk_usuario_certificacoes_certificacao
        FOREIGN KEY (id_certificacao)
        REFERENCES certificacoes(id_certificacao)
);

CREATE TABLE areas_interesse (
    id_area SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL UNIQUE,
    descricao TEXT
);

CREATE TABLE usuario_areas_interesse (
    id_usuario INTEGER NOT NULL,
    id_area INTEGER NOT NULL,
    PRIMARY KEY (id_usuario, id_area),
    CONSTRAINT fk_usuario_areas_interesse_usuario
        FOREIGN KEY (id_usuario)
        REFERENCES usuarios(id_usuario),
    CONSTRAINT fk_usuario_areas_interesse_area
        FOREIGN KEY (id_area)
        REFERENCES areas_interesse(id_area)
);
CREATE TABLE empresas (
    id_empresa SERIAL PRIMARY KEY,
    razao_social VARCHAR(150) NOT NULL,
    nome_fantasia VARCHAR(150),
    cnpj VARCHAR(20) UNIQUE,
    email VARCHAR(150),
    telefone VARCHAR(20),
    site VARCHAR(255)
);

CREATE TABLE representantes_empresa (
    id_representante SERIAL PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    email VARCHAR(150),
    telefone VARCHAR(20),
    cargo VARCHAR(100),
    id_empresa INTEGER NOT NULL,
    CONSTRAINT fk_representante_empresa_empresa
        FOREIGN KEY (id_empresa)
        REFERENCES empresas(id_empresa)
);
