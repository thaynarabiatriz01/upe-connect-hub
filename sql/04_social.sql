CREATE TABLE conexoes (
    id_conexao INT,
    id_usuario_origem INT,
    id_usuario_destino INT,
    data_conexao DATE,
    status_conexao VARCHAR(20),
    PRIMARY KEY (id_conexao)
);

CREATE TABLE mensagens (
    id_mensagem INT,
    id_remetente INT,
    id_destinatario INT,
    conteudo TEXT,
    data_envio DATE,
    hora_envio TIME,
    PRIMARY KEY (id_mensagem)
);

CREATE TABLE grupos (
    id_grupo INT,
    nome_grupo VARCHAR(100),
    descricao TEXT,
    data_criacao DATE,
    PRIMARY KEY (id_grupo)
);

CREATE TABLE membros_grupo (
    id_membro_grupo INT,
    id_grupo INT,
    id_usuario INT,
    data_entrada DATE,
    PRIMARY KEY (id_membro_grupo)
);

CREATE TABLE postagens (
    id_postagem INT,
    id_usuario INT,
    conteudo TEXT,
    data_postagem DATE,
    PRIMARY KEY (id_postagem)
);

CREATE TABLE comentarios (
    id_comentario INT,
    id_postagem INT,
    id_usuario INT,
    comentario TEXT,
    data_comentario DATE,
    PRIMARY KEY (id_comentario)
);
