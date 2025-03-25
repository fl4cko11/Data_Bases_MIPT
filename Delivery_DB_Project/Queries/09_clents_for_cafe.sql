SELECT cafe_id, name
FROM (
    SELECT dp.cafes.cafe_id AS cafe_id, MAX(dp.clients.name) AS name
    FROM dp.h_orders
    LEFT JOIN dp.clients ON (dp.h_orders.client_id = dp.clients.client_id)
    LEFT JOIN dp.cafes ON (dp.h_orders.cafe_id = dp.cafes.cafe_id)
    GROUP BY dp.cafes.cafe_id, dp.clients.name
);
