SELECT courier_id
FROM (
    SELECT courier_id, COUNT(dp.active_couriers.courier_id) AS count
    FROM dp.active_couriers
    GROUP BY courier_id
    ORDER BY count ASC
    LIMIT 1
);
