WITH RECURSIVE RecommendationChain AS (
    SELECT memid, firstname, surname
    FROM cd.members
    WHERE memid = 1
    
    UNION ALL
    
    SELECT m.memid, m.firstname, m.surname
    FROM cd.members m
    JOIN RecommendationChain rc ON m.recommendedby = rc.memid
)

SELECT memid, firstname, surname
FROM RecommendationChain
WHERE memid != 1
ORDER BY memid;
