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
