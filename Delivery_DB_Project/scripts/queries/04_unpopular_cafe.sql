SELECT cafe_id
FROM (
    SELECT dp.cafes.cafe_id AS cafe_id, COUNT(dp.h_orders.cafe_id) AS count
    FROM dp.h_orders
    LEFT JOIN dp.cafes ON (dp.cafes.cafe_id = dp.h_orders.cafe_id)
    GROUP BY dp.h_orders.cafe_id, dp.cafes.cafe_id
    ORDER BY count ASC
    LIMIT 1
);
