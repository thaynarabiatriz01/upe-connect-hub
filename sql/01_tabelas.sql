CREATE TABLE departamentos (
    id_departamento SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL UNIQUE,
    descricao TEXT
);

CREATE TABLE cursos (
    id_curso SERIAL PRIMARY KEY,
    nome VARCHAR(100) NOT NULL UNIQUE,
    sigla VARCHAR(20),
    id_departamento INTEGER NOT NULL,

    CONSTRAINT fk_curso_departamento
        FOREIGN KEY (id_departamento)
        REFERENCES departamentos(id_departamento)
);

CREATE TABLE tipos_usuario (
    id_tipo_usuario SERIAL PRIMARY KEY,
    nome_tipo VARCHAR(30) NOT NULL UNIQUE
);

CREATE TABLE usuarios (
    id_usuario SERIAL PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    senha VARCHAR(255) NOT NULL,
    matricula VARCHAR(20) UNIQUE,
    telefone VARCHAR(20),
    data_cadastro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    ativo BOOLEAN DEFAULT TRUE,

    id_tipo_usuario INTEGER NOT NULL,

    CONSTRAINT fk_usuario_tipo
        FOREIGN KEY (id_tipo_usuario)
        REFERENCES tipos_usuario(id_tipo_usuario)
);

CREATE TABLE perfis (
    id_perfil SERIAL PRIMARY KEY,

    id_usuario INTEGER NOT NULL UNIQUE,

    foto_perfil VARCHAR(255),
    biografia TEXT,
    periodo INTEGER CHECK (periodo > 0),
    linkedin VARCHAR(255),
    github VARCHAR(255),

    id_curso INTEGER NOT NULL,

    CONSTRAINT fk_perfil_usuario
        FOREIGN KEY (id_usuario)
        REFERENCES usuarios(id_usuario),

    CONSTRAINT fk_perfil_curso
        FOREIGN KEY (id_curso)
        REFERENCES cursos(id_curso)
);

CREATE TABLE oportunidades (
    id_oportunidade SERIAL PRIMARY KEY,
    titulo VARCHAR(100) NOT NULL,
    descricao TEXT NOT NULL,
    data_criacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    data_encerramento DATE,
    id_empresa INTEGER,
    id_tipo_vaga INTEGER,
    status VARCHAR(20) DEFAULT 'ABERTA'
);

CREATE TABLE status_candidatura (
    id_status_candidatura SERIAL PRIMARY KEY,
    descricao VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE candidaturas (
    id_candidatura SERIAL PRIMARY KEY,
    data_candidatura TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status_candidatura INTEGER NOT NULL,
    id_usuario INTEGER NOT NULL,
    id_oportunidade INTEGER NOT NULL
);

CREATE TABLE feedback_candidatura (
    id_feedback_candidatura SERIAL PRIMARY KEY,
    data_feedback TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    comentario TEXT NOT NULL,
    id_candidatura INTEGER NOT NULL
);

CREATE TABLE log_candidatura (
    id_log_candidatura SERIAL PRIMARY KEY,
    data_log TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    descricao TEXT NOT NULL,
    id_candidatura INTEGER NOT NULL,
    id_usuario INTEGER NOT NULL
);