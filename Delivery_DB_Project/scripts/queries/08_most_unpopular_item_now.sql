SELECT order_item AS name
FROM (
    SELECT order_item, SUM(quantity) AS quantity
    FROM dp.a_orders
    GROUP BY order_item
    ORDER BY quantity ASC
    LIMIT 1
);
