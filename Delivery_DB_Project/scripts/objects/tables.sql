CREATE TABLE IF NOT EXISTS dp.clients (
    client_id int PRIMARY KEY,
    address TEXT NOT NULL,
    name TEXT NOT NULL,
    birth DATE NOT NULL CHECK (birth <= CURRENT_DATE),
    gender CHAR CHECK (gender = 'M' OR gender = 'F'),
    value REAL CHECK (value >= 0 AND value <= 1) DEFAULT 0
);

CREATE TABLE IF NOT EXISTS dp.cafes (
    cafe_id int PRIMARY KEY,
    address TEXT NOT NULL,
    name TEXT NOT NULL,
    rating int NOT NULL CHECK (rating >= 0) DEFAULT 0,
    loaded_factor REAL NOT NULL CHECK (loaded_factor >= 0 AND loaded_factor <= 1) DEFAULT 0
);

CREATE TABLE IF NOT EXISTS dp.bikes (
    bike_id int PRIMARY KEY,
    bike_name TEXT NOT NULL,
    price int NOT NULL CHECK (price > 0),
    date_of_capture DATE NOT NULL CHECK (date_of_capture <= CURRENT_DATE)
);

CREATE TABLE IF NOT EXISTS dp.couriers (
    courier_id int PRIMARY KEY,
    bike_id int,
    name TEXT NOT NULL,
    bank_details TEXT NOT NULL,
    FOREIGN KEY(bike_id) REFERENCES dp.bikes(bike_id)
);

CREATE TABLE IF NOT EXISTS dp.a_orders (
    order_id int UNIQUE,
    order_item TEXT,
    date DATE CHECK (date < CURRENT_DATE),
    client_id int,
    quantity int NOT NULL CHECK (quantity > 0),
    PRIMARY KEY(order_id, order_item, date),
    FOREIGN KEY(client_id) REFERENCES dp.clients(client_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS dp.h_orders (
    order_id int,
    order_item TEXT,
    client_id int NOT NULL,
    quantity int NOT NULL CHECK (quantity > 0),
    date DATE CHECK (date <= CURRENT_DATE),
    cafe_id int NOT NULL,
    courier_id int NOT NULL,
    PRIMARY KEY(order_id, order_item, date)
);

CREATE TABLE IF NOT EXISTS dp.orders_in_cafe (
    order_id int,
    cafe_id int,
    PRIMARY KEY (order_id, cafe_id),
    FOREIGN KEY (order_id) REFERENCES dp.a_orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (cafe_id) REFERENCES dp.cafes(cafe_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS dp.active_couriers (
    order_id int,
    courier_id int,
    cafe_id int,
    PRIMARY KEY (order_id, cafe_id, courier_id),
    FOREIGN KEY (order_id, cafe_id) REFERENCES dp.orders_in_cafe(order_id, cafe_id) ON DELETE CASCADE,
    FOREIGN KEY (courier_id) REFERENCES dp.couriers(courier_id) ON DELETE CASCADE
);
