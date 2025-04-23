SELECT courier_id
FROM (
    SELECT dp.couriers.courier_id AS courier_id, COUNT(dp.h_orders.courier_id) AS count
    FROM dp.h_orders
    LEFT JOIN dp.couriers ON (dp.couriers.courier_id = dp.h_orders.courier_id)
    GROUP BY dp.h_orders.courier_id, dp.couriers.courier_id
    ORDER BY count DESC
    LIMIT 1
);
