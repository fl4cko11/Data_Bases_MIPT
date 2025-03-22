SELECT
    CONCAT(m2.firstname, ' ', m2.surname) AS member,
    (SELECT CONCAT(m1.firstname, ' ', m1.surname) FROM hw_2.members m1 WHERE m2.recommendedby = m1.memid) AS recommender
FROM hw_2.members m2 
ORDER BY member, recommender;
