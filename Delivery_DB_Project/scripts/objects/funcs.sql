CREATE OR REPLACE FUNCTION dp.get_most_active_client()
RETURNS INTEGER
LANGUAGE plpgsql
AS $$
DECLARE
    result INTEGER;
BEGIN
    SELECT client_id INTO result
    FROM dp.clients
    WHERE value = (SELECT MAX(value) FROM dp.clients)
    LIMIT 1;  -- на случай, если клиентов с максимальным значением несколько, берем одного

    RETURN result;
END;
$$;

CREATE OR REPLACE FUNCTION dp.count_load_factor(finding_cafe_id INTEGER)
RETURNS REAL
LANGUAGE plpgsql
AS $$
DECLARE
  result REAL;  -- тип с плавающей точкой
BEGIN
  SELECT COUNT(order_id)::REAL / COUNT(*)::REAL 
  INTO result
  FROM dp.orders_in_cafe
  WHERE cafe_id = finding_cafe_id;
  
  RETURN result;
END;
$$;

CREATE OR REPLACE FUNCTION dp.count_client_value(finding_client_id INTEGER)
RETURNS REAL
LANGUAGE plpgsql
AS $$
DECLARE
  result REAL;  -- тип с плавающей точкой
BEGIN
  SELECT COUNT(client_id)::REAL / COUNT(*)::REAL 
  INTO result
  FROM dp.h_orders
  WHERE client_id = finding_client_id;
  
  RETURN result;
END;
$$;

CREATE TYPE dp.order_type AS (
    Order_id INTEGER,
    Order_item TEXT,
    Client_id INTEGER,
    Quantity INTEGER,
    Date DATE,
    cafe_id INTEGER,
    courier_id INTEGER
);

CREATE OR REPLACE PROCEDURE dp.add_orders(orders dp.order_type[])
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO dp.a_orders (Order_id, Order_item, Client_id, Quantity, Date)
    SELECT (o).Order_id, (o).Order_item, (o).Client_id, (o).Quantity, (o).Date
    FROM unnest(orders) AS o;

    INSERT INTO dp.orders_in_cafe (Order_id, Cafe_id)
    SELECT (o).Order_id, (o).Cafe_id
    FROM unnest(orders) AS o;

    INSERT INTO dp.active_couriers (order_id, courier_id, cafe_id)
    SELECT (o).order_id, (o).courier_id, (o).cafe_id
    FROM unnest(orders) AS o;

    INSERT INTO dp.h_orders (Order_id, Order_item, Client_id, Quantity, Date, cafe_id, courier_id)
    SELECT (o).Order_id, (o).Order_item, (o).Client_id, (o).Quantity, (o).Date, (o).cafe_id, (o).courier_id
    FROM unnest(orders) AS o; --unnest преобразует массив в таблицу
END;
$$;
