SELECT name
FROM (
    SELECT dp.clients.name AS name, COUNT(dp.h_orders.client_id) AS count
    FROM dp.h_orders
    LEFT JOIN dp.clients ON (dp.clients.client_id = dp.h_orders.client_id)
    GROUP BY dp.h_orders.client_id, dp.clients.name
    ORDER BY count DESC
    LIMIT 1
);
