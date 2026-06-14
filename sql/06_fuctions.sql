CREATE OR REPLACE FUNCTION verificar_cnpj_empresa()
RETURNS TRIGGER
AS $$
BEGIN
    IF NEW.cnpj IS NULL OR NEW.cnpj = '' THEN
        RAISE EXCEPTION 'O CNPJ da empresa é obrigatório.';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION validar_nivel_habilidade()
RETURNS TRIGGER
AS $$
BEGIN
    IF NEW.nivel NOT IN ('Básico', 'Intermediário', 'Avançado') THEN
        RAISE EXCEPTION 'Nível de habilidade inválido.';
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION preencher_data_certificacao()
RETURNS TRIGGER
AS $$
BEGIN
    IF NEW.data_conclusao IS NULL THEN
        NEW.data_conclusao := CURRENT_DATE;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;
