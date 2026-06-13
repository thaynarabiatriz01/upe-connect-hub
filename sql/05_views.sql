CREATE VIEW habilidades_usuarios AS
SELECT
    usuarios.id_usuario,
    usuarios.nome AS usuario,
    habilidades.nome AS habilidade,
    usuario_habilidades.nivel
FROM usuarios
INNER JOIN usuario_habilidades
ON usuarios.id_usuario = usuario_habilidades.id_usuario
INNER JOIN habilidades
ON habilidades.id_habilidade = usuario_habilidades.id_habilidade;

CREATE VIEW certificacoes_usuarios AS
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

CREATE VIEW areas_interesse_usuarios AS
SELECT
    usuarios.nome AS usuario,
    areas_interesse.nome AS area_interesse
FROM usuarios
INNER JOIN usuario_areas_interesse
ON usuarios.id_usuario = usuario_areas_interesse.id_usuario
INNER JOIN areas_interesse
ON areas_interesse.id_area = usuario_areas_interesse.id_area;

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
