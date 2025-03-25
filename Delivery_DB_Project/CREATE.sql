CREATE TABLE dp.Clients (
    client_id int PRIMARY KEY,
    address TEXT NOT NULL,
    name TEXT NOT NULL,
    birth DATE NOT NULL,
    gender CHAR
);

CREATE TABLE dp.Cafes (
    cafe_id int PRIMARY KEY,
    address TEXT NOT NULL,
    name TEXT NOT NULL,
    raitng int NOT NULL
);

CREATE TABLE dp.Bikes (
    bike_id int PRIMARY KEY,
    bike_name TEXT NOT NULL,
    price int NOT NULL,
    date_of_capture DATE NOT NULL
);

CREATE TABLE dp.Couriers (
    courier_id int PRIMARY KEY,
    bike_id int,
    passport TEXT NOT NULL,
    bank_details TEXT NOT NULL,
    location TEXT NOT NULL,
    status BOOLEAN NOT NULL,
    FOREIGN KEY(bike_id) REFERENCES dp.Bikes(bike_id)
);

CREATE TABLE dp.A_Orders (
    order_id int,
    order_item TEXT,
    client_id int,
    quantity int NOT NULL,
    date DATE,
    PRIMARY KEY(order_id, order_item, date),
    FOREIGN KEY(client_id) REFERENCES dp.Clients(client_id)
);

CREATE TABLE dp.H_Orders (
    order_id int,
    order_item TEXT,
    client_id int NOT NULL,
    quantity int NOT NULL,
    date DATE,
    PRIMARY KEY(order_id, order_item, date),
    FOREIGN KEY(order_id, order_item, date) REFERENCES dp.A_Orders(order_id, order_item, date)
);

CREATE TABLE dp.Orders_in_cafe (
    order_id int,
    order_item TEXT,
    date DATE,
    cafe_id int,
    PRIMARY KEY(order_id, order_item, date, cafe_id),
    FOREIGN KEY(order_id, order_item, date) REFERENCES dp.A_Orders(order_id, order_item, date),
    FOREIGN KEY(cafe_id) REFERENCES dp.Cafes(cafe_id)
);

CREATE TABLE dp.Couriers_on_work (
    order_id int,
    order_item TEXT,
    date DATE,
    courier_id int,
    cafe_id int,
    PRIMARY KEY(order_id, order_item, date, cafe_id, courier_id),
    FOREIGN KEY(order_id, order_item, date, cafe_id) REFERENCES dp.Orders_in_cafe(order_id, order_item, date, cafe_id),
    FOREIGN KEY(courier_id) REFERENCES dp.Couriers(courier_id)
);
