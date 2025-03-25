SELECT passport
FROM (
    SELECT dp.couriers.passport AS passport, COUNT(dp.couriers_on_work.courier_id) AS count
    FROM dp.couriers_on_work
    LEFT JOIN dp.couriers ON (dp.couriers_on_work.courier_id = dp.couriers.courier_id)
    GROUP BY dp.couriers.passport, dp.couriers_on_work.courier_id
    ORDER BY count DESC
    LIMIT 1
);
