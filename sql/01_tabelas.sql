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