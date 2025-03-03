SELECT surname, firstname, MIN(memid) AS memid, MIN(joindate) AS starttime
FROM hw_2.members
GROUP BY surname, firstname
HAVING MIN(joindate) >= '2012-09-02 00:00:00'
ORDER BY memid;
