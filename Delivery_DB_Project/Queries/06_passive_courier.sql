SELECT passport
FROM (
    SELECT dp.couriers.passport AS passport, COUNT(dp.h_orders.courier_id) AS count
    FROM dp.h_orders
    LEFT JOIN dp.couriers ON (dp.couriers.courier_id = dp.h_orders.courier_id)
    GROUP BY dp.h_orders.courier_id, dp.couriers.passport
    ORDER BY count ASC
    LIMIT 1
);
