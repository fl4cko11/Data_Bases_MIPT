WITH RECURSIVE Fibonacci(nth, value, prev_value) AS (
    SELECT 0 AS nth, CAST(1 AS bigint) AS value, CAST(0 AS bigint) AS prev_value

    UNION ALL

    SELECT (f.nth + 1) AS nth, f.value + f.prev_value AS value, f.value AS prev_value
    FROM Fibonacci f
    WHERE f.nth < 100
)

SELECT nth, value
FROM Fibonacci
ORDER BY nth;
