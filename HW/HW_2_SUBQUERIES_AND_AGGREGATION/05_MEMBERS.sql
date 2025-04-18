SELECT m.surname, m.firstname, MIN(m.memid) AS memid, MIN(b.starttime) AS starttime
FROM hw_2.members m
LEFT JOIN hw_2.bookings b ON m.memid = b.memid
WHERE b.starttime >= '2012-09-01 00:00:00'
GROUP BY m.surname, m.firstname
ORDER BY memid;
