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

CREATE TABLE tipos_vagas(
    id_tipo_vaga SERIAL PRIMARY KEY,
    nome_tipo VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE vagas (
    id_vaga SERIAL PRIMARY KEY,

    titulo VARCHAR(150) NOT NULL,
    descricao TEXT NOT NULL,

    data_publicacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    data_limite DATE NOT NULL,

    quantidade_vagas INTEGER DEFAULT 1,

    status VARCHAR(20) DEFAULT 'ABERTA',

    id_empresa INTEGER NOT NULL,
    id_tipo_vaga INTEGER NOT NULL,

    CONSTRAINT fk_vaga_empresa
        FOREIGN KEY (id_empresa)
        REFERENCES empresas(id_empresa),

    CONSTRAINT fk_vaga_tipo
        FOREIGN KEY (id_tipo_vaga)
        REFERENCES tipos_vaga(id_tipo_vaga)
);


CREATE TABLE requisitos_vaga (
    id_requisito SERIAL PRIMARY KEY,

    descricao TEXT NOT NULL,

    id_vaga INTEGER NOT NULL,

    CONSTRAINT fk_requisito_vaga
        FOREIGN KEY (id_vaga)
        REFERENCES vagas(id_vaga)
);


CREATE TABLE vaga_habilidades (
    id_vaga INTEGER NOT NULL,
    id_habilidade INTEGER NOT NULL,

    PRIMARY KEY (
        id_vaga,
        id_habilidade
    ),

    CONSTRAINT fk_vh_vaga
        FOREIGN KEY (id_vaga)
        REFERENCES vagas(id_vaga),

    CONSTRAINT fk_vh_habilidade
        FOREIGN KEY (id_habilidade)
        REFERENCES habilidades(id_habilidade)
);
CREATE TABLE eventos(
    id_evento SERIAL PRIMARY KEY,
    titulo VARCHAR (150) NOT NULL,
    descricao TEXT,
    data_inicio TIMESTAMP not NULL,
    data_fim TIMESTAMP NOT NULL,
    local VARCHAR (150),
    vagas VARCHAR(150),
    carga_horaria  INTEGER,
    status VARCHAR(20) DEFAULT 'Aberto'
);

CREATE TABLE participacoes (
    id_participacao SERIAL PRIMARY KEY,
    id_usuario INTEGER NOT NULL,
    id_evento INTEGER not NULL,
    data_inscricao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    presenca BOOLEAN DEFAULT FALSE,

    CONSTRAINT fk_participacao_usuario
        FOREIGN KEY (id_usuario)
        REFERENCES usuarios(id_usuario),
    
    CONSTRAINT fk_participacao_evento
        FOREIGN KEY (id_evento)
        REFERENCES eventos(id_evento),

    CONSTRAINT uk_usuario_evento
        UNIQUE (id_usuario, id_evento)
    );

    CREATE TABLE certificados (
        id_certificado SERIAL PRIMARY KEY,
        id_participacao INTEGER UNIQUE NOT NULL,
        codigo_validacao VARCHAR(100) UNIQUE,
        data_emissao TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

        CONSTRAINT fk_certificado_participacao
            FOREIGN KEY (id_participacao)
            REFERENCES participacoes(id_participacao)
    );
CREATE TABLE empresas (
    id_empresa SERIAL PRIMARY KEY,
    razao_social VARCHAR(150) NOT NULL,
    nome_empresa VARCHAR(150),
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
