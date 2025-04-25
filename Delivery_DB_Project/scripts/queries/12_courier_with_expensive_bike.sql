SELECT dp.couriers.courier_id, dp.bikes.price
FROM dp.active_couriers
LEFT JOIN dp.couriers ON (dp.active_couriers.courier_id = dp.couriers.courier_id)
LEFT JOIN dp.bikes ON (dp.couriers.bike_id = dp.bikes.bike_id)
WHERE dp.bikes.price = (SELECT MAX(dp.bikes.price) 
                        FROM dp.active_couriers
                        LEFT JOIN dp.couriers ON (dp.active_couriers.courier_id = dp.couriers.courier_id)
                        LEFT JOIN dp.bikes ON (dp.couriers.bike_id = dp.bikes.bike_id)
                        WHERE dp.active_couriers.courier_id IS NOT NULL)
LIMIT 1;
