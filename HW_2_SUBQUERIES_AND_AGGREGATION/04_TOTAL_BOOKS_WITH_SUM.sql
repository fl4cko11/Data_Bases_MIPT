SELECT facid,
       EXTRACT(MONTH FROM starttime) AS month,
       SUM(slots) AS slots
FROM hw_2.bookings
WHERE TO_CHAR(starttime, 'YYYY-MM-DD') LIKE '2012-%'
GROUP BY facid, EXTRACT(MONTH FROM starttime)

UNION ALL

SELECT facid,
       NULL AS month,
       SUM(slots) AS slots
FROM hw_2.bookings
WHERE TO_CHAR(starttime, 'YYYY-MM-DD') LIKE '2012-%'
GROUP BY facid

UNION ALL

SELECT NULL AS facid,
       NULL AS month,
       SUM(slots) AS slots
FROM hw_2.bookings
WHERE TO_CHAR(starttime, 'YYYY-MM-DD') LIKE '2012-%'

ORDER BY facid, month;
