CREATE VIEW representantes_empresas AS
SELECT
    empresas.nome,
    representantes_empresa.nome AS representante,
    representantes_empresa.cargo,
    representantes_empresa.email,
    representantes_empresa.telefone
FROM empresas
INNER JOIN representantes_empresa
ON empresas.id_empresa = representantes_empresa.id_empresa;
