\copy dp.clients (client_id, address, name, birth, gender,value)
FROM 'csv/clients.csv' --запускать из Delivery_DB_Project
WITH (
    FORMAT CSV,
    DELIMITER ',',
    NULL '',
    HEADER true
);

\copy dp.cafes (cafe_id, address, name, rating, loaded_factor)
FROM 'csv/cafes.csv'
WITH (
    FORMAT CSV,
    DELIMITER ',',
    NULL '',
    HEADER true
);

\copy dp.bikes (bike_id, bike_name, price, date_of_capture)
FROM 'csv/bikes.csv'
WITH (
    FORMAT CSV,
    DELIMITER ',',
    NULL '',
    HEADER true
);

\copy dp.couriers (courier_id, bike_id, name, bank_details)
FROM 'csv/couriers.csv'
WITH (
    FORMAT CSV,
    DELIMITER ',',
    NULL '',
    HEADER true
);

\copy dp.a_orders (order_id, order_item, client_id, quantity, date)
FROM 'csv/a_orders.csv'
WITH (
    FORMAT CSV,
    DELIMITER ',',
    NULL '',
    HEADER true
);

\copy dp.h_orders (order_id, order_item, client_id, quantity, date, cafe_id, courier_id)
FROM 'csv/h_orders.csv'
WITH (
    FORMAT CSV,
    DELIMITER ',',
    NULL '',
    HEADER true
);

\copy dp.orders_in_cafe (order_id, cafe_id)
FROM 'csv/orders_in_cafe.csv'
WITH (
    FORMAT CSV,
    DELIMITER ',',
    NULL '',
    HEADER true
);

\copy dp.active_couriers (order_id, cafe_id, courier_id)
FROM 'csv/active_couriers.csv'
WITH (
    FORMAT CSV,
    DELIMITER ',',
    NULL '',
    HEADER true
);
