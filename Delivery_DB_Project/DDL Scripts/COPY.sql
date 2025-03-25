\copy dp.clients (client_id, address, name, birth, gender)
FROM '/home/vladh/git-repos/Data_Bases_MIPT/Delivery_DB_Project/Data_csv/clients.csv'
WITH (
    FORMAT CSV,
    DELIMITER ',',
    NULL '',
    HEADER true
);

\copy dp.cafes (cafe_id, address, name, rating)
FROM '/home/vladh/git-repos/Data_Bases_MIPT/Delivery_DB_Project/Data_csv/cafes.csv'
WITH (
    FORMAT CSV,
    DELIMITER ',',
    NULL '',
    HEADER true
);

\copy dp.bikes (bike_id, bike_name, price, date_of_capture)
FROM '/home/vladh/git-repos/Data_Bases_MIPT/Delivery_DB_Project/Data_csv/bikes.csv'
WITH (
    FORMAT CSV,
    DELIMITER ',',
    NULL '',
    HEADER true
);

\copy dp.couriers (courier_id, bike_id, passport, bank_details, location, status)
FROM '/home/vladh/git-repos/Data_Bases_MIPT/Delivery_DB_Project/Data_csv/couriers.csv'
WITH (
    FORMAT CSV,
    DELIMITER ',',
    NULL '',
    HEADER true
);

\copy dp.a_orders (order_id, order_item, client_id, quantity, date)
FROM '/home/vladh/git-repos/Data_Bases_MIPT/Delivery_DB_Project/Data_csv/a_orders.csv'
WITH (
    FORMAT CSV,
    DELIMITER ',',
    NULL '',
    HEADER true
);

\copy dp.h_orders (order_id, order_item, client_id, quantity, date, cafe_id, courier_id)
FROM '/home/vladh/git-repos/Data_Bases_MIPT/Delivery_DB_Project/Data_csv/h_orders.csv'
WITH (
    FORMAT CSV,
    DELIMITER ',',
    NULL '',
    HEADER true
);

\copy dp.orders_in_cafe (order_id, order_item, date, cafe_id)
FROM '/home/vladh/git-repos/Data_Bases_MIPT/Delivery_DB_Project/Data_csv/orders_in_cafe.csv'
WITH (
    FORMAT CSV,
    DELIMITER ',',
    NULL '',
    HEADER true
);

\copy dp.couriers_on_work (order_id, order_item, date, cafe_id, courier_id)
FROM '/home/vladh/git-repos/Data_Bases_MIPT/Delivery_DB_Project/Data_csv/couriers_on_work.csv'
WITH (
    FORMAT CSV,
    DELIMITER ',',
    NULL '',
    HEADER true
);
