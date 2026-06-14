CREATE TRIGGER verificar_nivel_habilidade
BEFORE INSERT OR UPDATE
ON usuario_habilidades
FOR EACH ROW
EXECUTE FUNCTION verificar_nivel_habilidade();

CREATE TRIGGER definir_data_certificacao
BEFORE INSERT
ON usuario_certificacoes
FOR EACH ROW
EXECUTE FUNCTION definir_data_certificacao();
