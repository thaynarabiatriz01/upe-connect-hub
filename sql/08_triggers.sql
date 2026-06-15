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

CREATE TRIGGER tg_fechar_vaga
BEFORE INSERT OR UPDATE
ON vagas
FOR EACH ROW
EXECUTE FUNCTION fechar_vagas_expiradas();

-- Geração automática de notificações
CREATE TRIGGER tg_notificacao_vaga
AFTER INSERT
ON vagas
FOR EACH ROW
EXECUTE FUNCTION fn_notificacao_nova_vaga_trigger();

CREATE TRIGGER tg_log_notificacoes
AFTER INSERT
ON notificacoes
FOR EACH ROW
EXECUTE FUNCTION registrar_log();

CREATE TRIGGER tg_auditoria_notificacoes
AFTER INSERT
ON notificacoes
FOR EACH ROW
EXECUTE FUNCTION registrar_auditoria();

-- Auditoria Universal para Monitoramento Administrativo
CREATE TRIGGER tg_auditoria_vagas
AFTER INSERT OR UPDATE OR DELETE
ON vagas
FOR EACH ROW
EXECUTE FUNCTION registrar_auditoria();

CREATE TRIGGER tg_auditoria_eventos
AFTER INSERT OR UPDATE OR DELETE
ON eventos
FOR EACH ROW
EXECUTE FUNCTION registrar_auditoria();