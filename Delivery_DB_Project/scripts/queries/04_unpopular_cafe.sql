SELECT cafe_id
FROM (
    SELECT cafe_id, COUNT(dp.h_orders.cafe_id) AS count
    FROM dp.h_orders
    GROUP BY dp.h_orders.cafe_id
    ORDER BY count ASC
    LIMIT 1
);
