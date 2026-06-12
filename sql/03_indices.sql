CREATE INDEX idx_evento_data
ON eventos(data_inicio);

CREATE INDEX idx_participacao_usuario
ON participacoes(id_usuario);

CREATE INDEX idx_participacao_evento
ON participacaoes(id_evento);