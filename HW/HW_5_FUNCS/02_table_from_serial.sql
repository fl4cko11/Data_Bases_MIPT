CREATE OR REPLACE FUNCTION serial_generator(start_val_inc INTEGER, last_val_ex INTEGER)
RETURNS TABLE (serial_generator INTEGER)
LANGUAGE plpgsql AS $$
DECLARE
    current_val INTEGER := start_val_inc; -- начальное значение
BEGIN
    WHILE current_val < last_val_ex LOOP
        RETURN QUERY SELECT current_val;  -- Возвращает текущее значение
        current_val := current_val + 1;  -- Увеличивает значение на 1
    END LOOP;
END;
$$;
