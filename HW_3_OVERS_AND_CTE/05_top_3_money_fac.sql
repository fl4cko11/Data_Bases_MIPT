WITH moneys_CTE AS (
    SELECT name, CASE
        WHEN cd.bookings.memid = 0 THEN cd.bookings.slots * cd.facilities.guestcost
        WHEN cd.bookings.memid != 0 THEN cd.bookings.slots * cd.facilities.membercost
    END AS moneys
    FROM cd.facilities
    LEFT JOIN cd.bookings ON (cd.facilities.facid = cd.bookings.facid)
),

sums_CTE AS (
    SELECT name, SUM(moneys) AS sum_money
    FROM moneys_CTE
    GROUP BY name
)

SELECT name, RANK() OVER (ORDER BY sum_money DESC) AS rank
FROM sums_CTE
ORDER by rank
LIMIT 3;
