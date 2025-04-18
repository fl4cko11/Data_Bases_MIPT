CREATE OR REPLACE FUNCTION count_non_volatile_days(full_nm_par TEXT) 
RETURNS INT AS
$$
DECLARE
    non_volatile_day_count INT; --здесь храним кол-во
BEGIN
    SELECT COUNT(*) INTO non_volatile_day_count
    FROM coins
    WHERE full_nm = full_nm_par AND high_price = low_price;

    IF NOT EXISTS (SELECT 1 FROM coins WHERE full_nm = full_nm_par) THEN
        RAISE EXCEPTION 'Crypto currency with name "%s" is absent in database!', full_nm_par
        USING ERRCODE = '02000';
    END IF;

    RETURN non_volatile_day_count;
END;
$$
LANGUAGE plpgsql;
