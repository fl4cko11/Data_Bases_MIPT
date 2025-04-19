CREATE VIEW dp.all_time_quantity AS
SELECT order_item, SUM(quantity) AS all_tmie_quantity
FROM dp.h_orders
GROUP BY order_item
ORDER BY all_tmie_quantity DESC;

CREATE VIEW dp.most_loaded_couriers AS
SELECT courier_id, COUNT(courier_id) AS number_of_orders
FROM dp.active_couriers
GROUP BY courier_id
ORDER BY number_of_orders DESC;
