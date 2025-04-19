SELECT name
FROM (
    SELECT dp.couriers.name AS name, COUNT(dp.active_couriers.courier_id) AS count
    FROM dp.active_couriers
    LEFT JOIN dp.couriers ON (dp.active_couriers.courier_id = dp.couriers.courier_id)
    GROUP BY dp.couriers.name, dp.active_couriers.courier_id
    ORDER BY count DESC
    LIMIT 1
);
