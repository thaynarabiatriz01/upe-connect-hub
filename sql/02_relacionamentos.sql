-- Relacionamentos para a tabela oportunidades
ALTER TABLE oportunidades
    ADD CONSTRAINT fk_oportunidade_empresa
    FOREIGN KEY (id_empresa) REFERENCES empresas(id_empresa);

ALTER TABLE oportunidades
    ADD CONSTRAINT fk_oportunidade_tipo_vaga
    FOREIGN KEY (id_tipo_vaga) REFERENCES tipos_vaga(id_tipo_vaga);

-- Relacionamentos para a tabela candidaturas
ALTER TABLE candidaturas
    ADD CONSTRAINT fk_candidatura_usuario
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario);

ALTER TABLE candidaturas
    ADD CONSTRAINT fk_candidatura_oportunidade
    FOREIGN KEY (id_oportunidade) REFERENCES oportunidades(id_oportunidade);

ALTER TABLE candidaturas
    ADD CONSTRAINT fk_candidatura_status
    FOREIGN KEY (status_candidatura) REFERENCES status_candidatura(id_status_candidatura);

-- Relacionamentos para a tabela feedback_candidatura
ALTER TABLE feedback_candidatura
    ADD CONSTRAINT fk_feedback_candidatura
    FOREIGN KEY (id_candidatura) REFERENCES candidaturas(id_candidatura);

-- Relacionamentos para a tabela log_candidatura
ALTER TABLE log_candidatura
    ADD CONSTRAINT fk_log_candidatura
    FOREIGN KEY (id_candidatura) REFERENCES candidaturas(id_candidatura);

ALTER TABLE log_candidatura
    ADD CONSTRAINT fk_log_usuario
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario);
