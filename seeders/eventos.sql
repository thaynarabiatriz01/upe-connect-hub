INSERT INTO participacoes
(id_usuario, id_evento, tipo_participacao)
VALUES
(1, 1, 'Ouvinte'),
(2, 1, 'Monitor'),
(3, 1, 'Ouvinte'),
(1, 2, 'Monitor'),
(5, 2, 'Ouvinte');

INSERT INTO certificados
(id_participacao, codigo_validacao)
VALUES
(1, 'CERT-UPE-2026-001'),
(2, 'CERT-UPE-2026-002');