CREATE INDEX idx_usuario_email
ON usuarios(email);

CREATE INDEX idx_usuario_matricula
ON usuarios(matricula);

CREATE INDEX idx_usuario_tipo
ON usuarios(id_tipo_usuario);

CREATE INDEX idx_perfil_curso
ON perfis(id_curso);

CREATE INDEX idx_curso_departamento
ON cursos(id_departamento);
CREATE INDEX idx_usuario_email 
ON usuarios(email);

CREATE INDEX idx_usuario_status 
ON usuarios(ativo);

CREATE INDEX idx_oportunidade_status
ON oportunidades(status_oportunidade);

CREATE INDEX idx_oportunidade_tipo
ON oportunidades(tipo_oportunidade);

