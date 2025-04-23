SELECT client_id
FROM (
    SELECT dp.clients.client_id AS client_id, COUNT(dp.h_orders.client_id) AS count
    FROM dp.h_orders
    LEFT JOIN dp.clients ON (dp.clients.client_id = dp.h_orders.client_id)
    GROUP BY dp.h_orders.client_id, dp.clients.client_id
    ORDER BY count ASC
    LIMIT 1
);
