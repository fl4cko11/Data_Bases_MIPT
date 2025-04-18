SELECT
    name,
    CASE
        WHEN monthlymaintenance > 100 THEN 'expensive'
        ELSE 'cheap'
    END as cost
FROM hw_1.facilities;
