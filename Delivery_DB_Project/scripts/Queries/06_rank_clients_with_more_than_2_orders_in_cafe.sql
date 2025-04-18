SELECT 
    c.client_id,
    c.name, 
    SUM(h.quantity) AS total_quantity, 
    RANK() OVER (ORDER BY SUM(h.quantity) DESC) AS rank
FROM 
    dp.Clients c
INNER JOIN 
    dp.H_Orders h ON c.client_id = h.client_id
WHERE 
    EXISTS (
        SELECT 1 
        FROM dp.Cafes cafe 
        WHERE cafe.cafe_id = 1
    )
GROUP BY 
    c.client_id, c.name
HAVING 
    SUM(h.quantity) > 2;
