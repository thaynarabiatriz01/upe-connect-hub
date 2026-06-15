-- Relacionamentos para a tabela candidaturas
ALTER TABLE candidaturas
    ADD CONSTRAINT fk_candidatura_usuario
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario);

ALTER TABLE candidaturas
    ADD CONSTRAINT fk_candidatura_vaga
    FOREIGN KEY (id_vaga) REFERENCES vagas(id_vaga);

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
