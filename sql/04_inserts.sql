-- Inserção dos dados estáticos (domínios) para as tabelas do módulo de Candidaturas

INSERT INTO status_candidatura (id_status_candidatura, descricao) VALUES
(1, 'Em Análise'),
(2, 'Aprovado para Entrevista'),
(3, 'Selecionado'),
(4, 'Não Selecionado'),
(5, 'Cancelado pelo Usuário')
ON CONFLICT (id_status_candidatura) DO NOTHING;

-- Ajusta a sequência após as inserções manuais para evitar conflitos de IDs
SELECT setval('status_candidatura_id_status_candidatura_seq', (SELECT MAX(id_status_candidatura) FROM status_candidatura));
