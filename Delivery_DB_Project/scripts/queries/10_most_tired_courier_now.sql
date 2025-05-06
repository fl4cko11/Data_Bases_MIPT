SELECT courier_id
FROM (
    SELECT courier_id, COUNT(courier_id) AS count
    FROM dp.active_couriers
    GROUP BY courier_id
    ORDER BY count DESC
    LIMIT 1
);
