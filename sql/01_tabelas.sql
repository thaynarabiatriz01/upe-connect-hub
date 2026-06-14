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