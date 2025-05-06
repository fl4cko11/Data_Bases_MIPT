SELECT client_id
FROM (
    SELECT client_id, COUNT(dp.h_orders.client_id) AS count
    FROM dp.h_orders
    GROUP BY dp.h_orders.client_id
    ORDER BY count ASC
    LIMIT 1
);
