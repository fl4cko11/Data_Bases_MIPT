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
),

groups_CTE AS (
    SELECT name, NTILE(3) OVER (ORDER BY sum_money DESC) AS revenue_wo_name
    FROM sums_CTE
)

SELECT name, CASE
    WHEN revenue_wo_name = 1 THEN 'high'
    WHEN revenue_wo_name = 2 THEN 'average'
    WHEN revenue_wo_name = 3 THEN 'low'
END AS revenue
FROM groups_CTE
ORDER BY revenue_wo_name, name;
