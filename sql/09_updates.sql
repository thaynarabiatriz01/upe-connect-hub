-- =======================================================================================
-- SCRIPT DE ATUALIZAÇÃO (FASE 8)
-- =======================================================================================
-- Este script atualiza a base de dados existente para suportar Autoria (RBAC).
-- O Python já o executou, mas o mantemos aqui como log e documentação.

-- 1. Adiciona a coluna id_usuario na tabela vagas
ALTER TABLE vagas ADD COLUMN IF NOT EXISTS id_usuario INTEGER;

-- 2. Conecta a constraint (Foreign Key)
ALTER TABLE vagas DROP CONSTRAINT IF EXISTS fk_vaga_usuario;
ALTER TABLE vagas ADD CONSTRAINT fk_vaga_usuario
    FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario);

-- 3. Preenche as vagas antigas com um autor padrão (ex: Professor Joao, ID 4) 
-- para não quebrar a listagem de dados legados no painel.
UPDATE vagas SET id_usuario = 4 WHERE id_usuario IS NULL;
