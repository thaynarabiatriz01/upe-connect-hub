CREATE INDEX idx_usuario_email 
ON usuarios(email);

CREATE INDEX idx_usuario_status 
ON usuarios(ativo);

CREATE INDEX idx_oportunidade_status
ON oportunidades(status_oportunidade);

CREATE INDEX idx_oportunidade_tipo
ON oportunidades(tipo_oportunidade);

