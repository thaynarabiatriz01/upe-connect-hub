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

CREATE TABLE perfis(
    id_perfil SERIAL
);