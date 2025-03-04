SELECT 
    m.firstname AS memfname, 
    m.surname AS memsname, 
    r.firstname AS recfname, 
    r.surname AS recsname
FROM 
    hw_2.members m
LEFT JOIN 
    hw_2.members r ON m.recommendedby = r.memid --добавляем информацию о тех кто сделал рекомендацию через джойн слева
ORDER BY 
    m.surname, m.firstname;
