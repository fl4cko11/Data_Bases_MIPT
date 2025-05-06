SELECT courier_id
FROM (
    SELECT courier_id, COUNT(dp.h_orders.courier_id) AS count
    FROM dp.h_orders
    GROUP BY dp.h_orders.courier_id
    ORDER BY count DESC
    LIMIT 1
);
