CREATE TABLE notificacoes (
    id_notificacao SERIAL PRIMARY KEY,
    titulo VARCHAR(150) NOT NULL,
    mensagem TEXT NOT NULL,
    data_envio TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    lida BOOLEAN DEFAULT FALSE,
    id_usuario INTEGER NOT NULL
);

CREATE TABLE logs (
    id_log SERIAL PRIMARY KEY,
    operacao VARCHAR(50),
    tabela_afetada VARCHAR(50),
    descricao TEXT,
    data_operacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE auditoria (
    id_auditoria SERIAL PRIMARY KEY,
    tabela_afetada VARCHAR(50),
    operacao VARCHAR(20),
    dados_antigos TEXT,
    dados_novos TEXT,
    data_operacao TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);