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

CREATE TRIGGER update_date_of_capture
AFTER INSERT ON dp.active_couriers
FOR EACH ROW -- чтобы для каждой вставленной
EXECUTE FUNCTION dp.update_bike_dates();

CREATE OR REPLACE FUNCTION dp.update_load_factor()
RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN
  UPDATE dp.cafes
  SET loaded_factor = dp.count_load_factor(NEW.cafe_id)
  WHERE cafe_id = NEW.cafe_id; -- NEW. => смотрим в orders_in_cafe

  RETURN NEW; -- NEW тк меняем
END;
$$;

CREATE TRIGGER update_load_factor
AFTER INSERT ON dp.orders_in_cafe
FOR EACH ROW -- чтобы для каждой вставленной
EXECUTE FUNCTION dp.update_load_factor();

CREATE OR REPLACE FUNCTION dp.update_client_value()
RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN
  UPDATE dp.clients
  SET value = dp.count_client_value(NEW.client_id)
  WHERE client_id = NEW.client_id; -- NEW. => смотрим в orders_in_cafe

  RETURN NEW; -- NEW тк меняем
END;
$$;

CREATE TRIGGER update_client_value
AFTER INSERT ON dp.orders_in_cafe
FOR EACH ROW -- чтобы для каждой вставленной
EXECUTE FUNCTION dp.update_client_value();
