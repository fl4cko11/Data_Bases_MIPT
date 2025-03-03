SELECT firstname, surname
FROM hw_2.members
WHERE memid IN (SELECT recommendedby FROM hw_2.members)
GROUP BY firstname, surname
ORDER BY surname, firstname;
