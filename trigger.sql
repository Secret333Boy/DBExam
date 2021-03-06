---trigger
DROP TRIGGER IF EXISTS taxPayed ON PayedTax;
CREATE OR REPLACE FUNCTION taxPayedFunc () RETURNS TRIGGER
AS
$$
    BEGIN
        RAISE NOTICE 'Tax has been payed: %', NEW.ID;
        RETURN NEW;
    END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER taxPayed AFTER INSERT ON PayedTax EXECUTE FUNCTION taxPayedFunc();