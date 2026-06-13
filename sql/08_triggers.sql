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