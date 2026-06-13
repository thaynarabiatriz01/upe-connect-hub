CREATE VIEW vw_vagas_abertas AS

SELECT
    v.id_vaga,
    v.titulo,
    e.nome_empresa,
    tv.nome_tipo,
    v.data_limite

FROM vagas v

JOIN empresas e
    ON v.id_empresa = e.id_empresa

JOIN tipos_vaga tv
    ON v.id_tipo_vaga = tv.id_tipo_vaga

WHERE status = 'ABERTA';