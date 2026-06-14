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


CREATE INDEX indice_nome_empresa
ON empresas(nome_empresa);
CREATE INDEX indice_cnpj_empresa
ON empresas(cnpj);
CREATE INDEX indice_representante_empresa
ON representantes_empresa(id_empresa);

CREATE INDEX indice_nome_habilidade
ON habilidades(nome);
CREATE INDEX indice_usuario_habilidade_usuario
ON usuario_habilidades(id_usuario);
CREATE INDEX indice_usuario_habilidade_habilidade
ON usuario_habilidades(id_habilidade);

CREATE INDEX indice_nome_certificacao
ON certificacoes(nome);
CREATE INDEX indice_usuario_certificacao_usuario
ON usuario_certificacoes(id_usuario);

CREATE INDEX indice_nome_area_interesse
ON areas_interesse(nome);
CREATE INDEX indice_usuario_area_interesse
ON usuario_areas_interesse(id_usuario);
