-- Gerar os logs de candidatura automaticamente nas operações de INSERT e UPDATE (RN11)
CREATE TRIGGER trg_log_candidatura
AFTER INSERT OR UPDATE OF status_candidatura ON candidaturas
FOR EACH ROW
EXECUTE FUNCTION fn_log_candidatura_trigger();

CREATE TRIGGER verificar_cnpj_empresa
BEFORE INSERT OR UPDATE
ON empresas
FOR EACH ROW
EXECUTE FUNCTION verificar_cnpj_empresa();

CREATE TRIGGER verificar_nivel_habilidade
BEFORE INSERT OR UPDATE
ON usuario_habilidades
FOR EACH ROW
EXECUTE FUNCTION validar_nivel_habilidade();

CREATE TRIGGER definir_data_certificacao
BEFORE INSERT
ON usuario_certificacoes
FOR EACH ROW
EXECUTE FUNCTION preencher_data_certificacao();

CREATE OR REPLACE FUNCTION fechar_vagas_expiradas()
RETURNS TRIGGER
AS
$$
BEGIN

IF NEW.data_limite < CURRENT_DATE THEN

    NEW.status := 'ENCERRADA';

END IF;

RETURN NEW;

END;
$$
LANGUAGE plpgsql;

CREATE TRIGGER tg_fechar_vaga

BEFORE INSERT OR UPDATE

ON vagas

FOR EACH ROW

EXECUTE FUNCTION fechar_vagas_expiradas();