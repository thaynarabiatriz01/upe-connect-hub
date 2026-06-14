ALTER TABLE notificacoes
ADD CONSTRAINT fk_notificacao_usuario
FOREIGN KEY (id_usuario)
REFERENCES usuarios(id_usuario);