SELECT
    empresas.nome_empresa AS empresa,
    representantes_empresa.nome AS representante,
    representantes_empresa.cargo
FROM empresas
INNER JOIN representantes_empresa
    ON empresas.id_empresa = representantes_empresa.id_empresa;

SELECT
    empresas.nome_empresa AS empresa,
    COUNT(representantes_empresa.id_representante) AS quantidade_representantes
FROM empresas
LEFT JOIN representantes_empresa
    ON empresas.id_empresa = representantes_empresa.id_empresa
GROUP BY empresas.nome_empresa;
