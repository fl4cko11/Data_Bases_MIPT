SELECT facid, 
       CASE
           WHEN TO_CHAR(starttime, 'YYYY-MM-DD') LIKE '2012-07-%' THEN 7
           WHEN TO_CHAR(starttime, 'YYYY-MM-DD') LIKE '2012-08-%' THEN 8
           WHEN TO_CHAR(starttime, 'YYYY-MM-DD') LIKE '2012-09-%' THEN 9
        END AS month,
        SUM(slots) AS total_slots
FROM hw_2.bookings
WHERE TO_CHAR(starttime, 'YYYY-MM-DD') LIKE '2012-%'
GROUP BY facid, month
ORDER BY facid, month;
