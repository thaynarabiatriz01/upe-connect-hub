SELECT
    usuarios.nome AS usuario,
    habilidades.nome AS habilidade,
    usuario_habilidades.nivel
FROM usuarios
INNER JOIN usuario_habilidades
    ON usuarios.id_usuario = usuario_habilidades.id_usuario
INNER JOIN habilidades
    ON habilidades.id_habilidade = usuario_habilidades.id_habilidade;

SELECT
    usuarios.nome,
    usuario_habilidades.nivel
FROM usuarios
INNER JOIN usuario_habilidades
    ON usuarios.id_usuario = usuario_habilidades.id_usuario
INNER JOIN habilidades
    ON habilidades.id_habilidade = usuario_habilidades.id_habilidade
WHERE habilidades.nome = 'SQL';

SELECT
    usuarios.nome AS usuario,
    certificacoes.nome AS certificacao,
    certificacoes.instituicao,
    usuario_certificacoes.data_conclusao
FROM usuarios
INNER JOIN usuario_certificacoes
    ON usuarios.id_usuario = usuario_certificacoes.id_usuario
INNER JOIN certificacoes
    ON certificacoes.id_certificacao = usuario_certificacoes.id_certificacao;

SELECT
    usuarios.nome AS usuario,
    areas_interesse.nome AS area_interesse
FROM usuarios
INNER JOIN usuario_areas_interesse
    ON usuarios.id_usuario = usuario_areas_interesse.id_usuario
INNER JOIN areas_interesse
    ON areas_interesse.id_area = usuario_areas_interesse.id_area;

SELECT
    empresas.nome AS empresa,
    representantes_empresa.nome AS representante,
    representantes_empresa.cargo
FROM empresas
INNER JOIN representantes_empresa
    ON empresas.id_empresa = representantes_empresa.id_empresa;

SELECT
    empresas.nome AS empresa,
    COUNT(representantes_empresa.id_representante) AS quantidade_representantes
FROM empresas
LEFT JOIN representantes_empresa
    ON empresas.id_empresa = representantes_empresa.id_empresa
GROUP BY empresas.nome;
