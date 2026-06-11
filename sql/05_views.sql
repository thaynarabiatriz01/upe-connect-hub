CREATE VIEW vw_usuarios_cursos AS SELECT
SELECT
    u.id_usuario,
    u.nome,
    u.email,
    tu.nome_tipo,
    c.nome AS CURSO
FROM usuarios u
JOIN tipos_usuario tu
    ON u.id_tipo_usuario = tu.id_tipo_usuario
LEFT JOIN perfis p  
    ON u.id_usuario = p.id_usuario
LEFT JOIN cursos c  
    ON p.id_curso = c.id_curso;    
