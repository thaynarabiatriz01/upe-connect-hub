-- Gerar os logs de candidatura automaticamente nas operações de INSERT e UPDATE (RN11)
CREATE TRIGGER trg_log_candidatura
AFTER INSERT OR UPDATE OF status_candidatura ON candidaturas
FOR EACH ROW
EXECUTE FUNCTION fn_log_candidatura_trigger();
