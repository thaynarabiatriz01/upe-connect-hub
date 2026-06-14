CREATE OR REPLACE FUNCTION validar_cnpj_empresa()
RETURNS TRIGGER
AS $$
BEGIN
    IF NEW.cnpj IS NULL OR NEW.cnpj = '' THEN
        RAISE EXCEPTION 'O CNPJ da empresa é obrigatório.';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
