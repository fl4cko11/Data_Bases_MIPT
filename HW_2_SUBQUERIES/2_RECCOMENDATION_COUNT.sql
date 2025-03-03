SELECT recommendedby, COUNT(recommendedby) AS count
FROM hw_2.members
WHERE recommendedby IS NOT NULL
GROUP BY recommendedby
ORDER BY recommendedby;
