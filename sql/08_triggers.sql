CREATE TRIGGER verificar_cnpj_empresa
BEFORE INSERT OR UPDATE
ON empresas
FOR EACH ROW
EXECUTE FUNCTION verificar_cnpj_empresa();
