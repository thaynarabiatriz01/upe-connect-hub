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