INSERT INTO tipos_vaga (nome_tipo)
VALUES
('Estágio'),
('Monitoria'),
('Bolsa de Pesquisa'),
('Projeto de Extensão'),
('Emprego');

INSERT INTO vagas
(
titulo,
descricao,
data_limite,
quantidade_vagas,
id_empresa,
id_tipo_vaga
)
VALUES

(
'Estágio Backend Python',
'Atuação com APIs e PostgreSQL',
'2026-12-20',
2,
1,
1
),

(
'Monitoria Banco de Dados',
'Apoio em disciplinas de BD',
'2026-10-15',
1,
2,
2
),

(
'Bolsa PIBIC',
'Pesquisa em Inteligência Artificial',
'2026-11-30',
3,
3,
3
);


INSERT INTO requisitos_vaga
(
descricao,
id_vaga
)
VALUES

(
'Conhecimento em Python',
1
),

(
'Conhecimento em PostgreSQL',
1
),

(
'Ter cursado Banco de Dados',
2
),

(
'Conhecimento em IA',
3
);