SELECT courier_id
FROM (
    SELECT dp.couriers.courier_id AS courier_id, COUNT(dp.active_couriers.courier_id) AS count
    FROM dp.active_couriers
    LEFT JOIN dp.couriers ON (dp.active_couriers.courier_id = dp.couriers.courier_id)
    GROUP BY dp.couriers.courier_id, dp.active_couriers.courier_id
    ORDER BY count ASC
    LIMIT 1
);
