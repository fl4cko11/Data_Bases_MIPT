SELECT firstname, surname
FROM hw_2.members
WHERE memid IN (SELECT recommendedby FROM hw_2.members) --выбираем тольк те имя и фамилию, у которых значение memid есть в столбце recommendedby
GROUP BY firstname, surname
ORDER BY surname, firstname;
