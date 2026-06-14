CREATE OR REPLACE FUNCTION registrar_log()
RETURNS TRIGGER
AS $$
BEGIN

    INSERT INTO logs(
        tabela_afetada,
        operacao,
        descricao
    )
    VALUES(
        TG_TABLE_NAME,
        TG_OP,
        'Operação executada automaticamente'
    );

    RETURN NEW;

END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tg_log_notificacoes
AFTER INSERT
ON notificacoes
FOR EACH ROW
EXECUTE FUNCTION registrar_log();


CREATE OR REPLACE FUNCTION registrar_auditoria()
RETURNS TRIGGER
AS $$
BEGIN

    INSERT INTO auditoria(
        tabela_afetada,
        operacao,
        dados_novos
    )
    VALUES(
        TG_TABLE_NAME,
        TG_OP,
        row_to_json(NEW)::TEXT
    );

    RETURN NEW;

END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER tg_auditoria_notificacoes
AFTER INSERT
ON notificacoes
FOR EACH ROW
EXECUTE FUNCTION registrar_auditoria();