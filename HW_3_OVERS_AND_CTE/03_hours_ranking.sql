SELECT firstname, surname, hours, RANK() OVER (ORDER BY hours DESC) AS rank
FROM (
    SELECT --подзапрос, чтобы rank() располагал информацией о hours
        cd.members.firstname, 
        cd.members.surname, 
        ROUND((SUM(cd.bookings.slots) * 30) / 60, -1) AS hours
    FROM cd.bookings
    LEFT JOIN cd.members ON (cd.bookings.memid = cd.members.memid)
    GROUP BY cd.members.firstname, cd.members.surname
) AS smth
ORDER BY rank, surname, firstname;
