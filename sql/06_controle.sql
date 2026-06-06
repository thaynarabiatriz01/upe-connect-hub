CREATE TABLE notificacoes (
    id_notificacao INT,
    id_usuario INT,
    titulo VARCHAR(100),
    mensagem TEXT,
    data_notificacao DATE,
    PRIMARY KEY (id_notificacao)
);

CREATE TABLE logs (
    id_log INT,
    id_usuario INT,
    acao_realizada VARCHAR(200),
    data_log DATE,
    hora_log TIME,
    PRIMARY KEY (id_log)
);

CREATE TABLE auditoria (
    id_auditoria INT,
    tabela_afetada VARCHAR(100),
    operacao_realizada VARCHAR(20),
    usuario_responsavel INT,
    data_auditoria DATE,
    PRIMARY KEY (id_auditoria)
);

CREATE TABLE recomendacoes (
    id_recomendacao INT,
    id_usuario INT,
    id_vaga INT,
    motivo VARCHAR(200),
    data_recomendacao DATE,
    PRIMARY KEY (id_recomendacao)
);
