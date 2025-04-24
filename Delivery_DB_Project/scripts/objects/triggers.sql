CREATE OR REPLACE FUNCTION dp.update_bike_dates()
RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN
  UPDATE dp.bikes
  SET date_of_capture = now()
  WHERE courier_id = NEW.courier_id; -- NEW. => смотрим в active_couriers

  RETURN NEW; -- NEW тк меняем
END;
$$;

CREATE OR REPLACE TRIGGER update_date_of_capture
AFTER INSERT ON dp.couriers
FOR EACH ROW -- чтобы для каждой вставленной
EXECUTE FUNCTION dp.update_bike_dates();

CREATE OR REPLACE FUNCTION dp.update_load_factor()
RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN
  IF TG_OP = 'INSERT' THEN
    UPDATE dp.cafes
    SET loaded_factor = dp.count_load_factor(NEW.cafe_id) -- тк триггер после вставки, то подсчёт по обновлённой будет идти
    WHERE cafe_id = NEW.cafe_id; -- NEW. => смотрим в orders_in_cafe на вставленные

    RETURN NEW; --формальность
  ELSIF TG_OP = 'DELETE' THEN
    UPDATE dp.cafes
    SET loaded_factor = dp.count_load_factor(OLD.cafe_id)
    WHERE cafe_id = OLD.cafe_id; -- NEW. => смотрим в orders_in_cafe на удалённые

    RETURN OLD; --формальность
  END IF;
END;
$$;

CREATE OR REPLACE TRIGGER update_load_factor
AFTER INSERT OR DELETE ON dp.orders_in_cafe
FOR EACH ROW -- чтобы для каждой вставленной
EXECUTE FUNCTION dp.update_load_factor();

CREATE OR REPLACE FUNCTION dp.update_client_value()
RETURNS trigger
LANGUAGE plpgsql
AS $$
DECLARE
    v_client_id int;
BEGIN
  IF TG_OP = 'INSERT' THEN
    -- Получаем client_id по NEW.order_id
    SELECT client_id INTO v_client_id
    FROM dp.a_orders
    WHERE order_id = NEW.order_id
    LIMIT 1;

    -- Обновляем значение value у клиента
    UPDATE dp.clients
    SET value = dp.count_client_value(v_client_id)
    WHERE client_id = v_client_id;

    RETURN NEW;
  ELSIF TG_OP = 'DELETE' THEN
    SELECT client_id INTO v_client_id
    FROM dp.a_orders
    WHERE order_id = OLD.order_id
    LIMIT 1;

    UPDATE dp.clients
    SET value = dp.count_client_value(v_client_id)
    WHERE client_id = v_client_id;

    RETURN OLD;
  END IF;
END;
$$;

CREATE OR REPLACE TRIGGER update_client_value
AFTER INSERT OR DELETE ON dp.orders_in_cafe
FOR EACH ROW -- чтобы для каждой вставленной
EXECUTE FUNCTION dp.update_client_value();
