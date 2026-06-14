CREATE INDEX indice_nome_empresa
ON empresas(nome_empresa);
CREATE INDEX indice_cnpj_empresa
ON empresas(cnpj);
CREATE INDEX indice_representante_empresa
ON representantes_empresa(id_empresa);
