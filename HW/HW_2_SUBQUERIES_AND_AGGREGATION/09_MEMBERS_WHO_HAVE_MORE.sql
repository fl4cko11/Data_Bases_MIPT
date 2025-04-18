WITH under_consideration_info AS ( -- по рассматриваемой дате нужную информацию
    SELECT facid, memid, slots
    FROM hw_2.bookings
    WHERE EXTRACT(YEAR FROM starttime) = 2012 AND EXTRACT(MONTH FROM starttime) = 9 AND EXTRACT(DAY FROM starttime) = 14
),

cost_calculation AS ( -- соответственно рассматриваемой информации имена участников и цены
    SELECT 
        CASE 
            WHEN uci.memid = 0 THEN 'GUEST GUEST'
            ELSE CONCAT(m.firstname, ' ', m.surname)
        END AS member,
        f.name AS facility,
        CASE 
            WHEN uci.memid = 0 THEN f.guestcost * uci.slots
            ELSE f.membercost * uci.slots
        END AS cost
    FROM under_consideration_info uci, hw_1.facilities f, hw_2.members m
    WHERE f.facid = uci.facid AND uci.memid = m.memid
)

SELECT * FROM cost_calculation
WHERE cost > 30
ORDER BY cost DESC, member, facility;
