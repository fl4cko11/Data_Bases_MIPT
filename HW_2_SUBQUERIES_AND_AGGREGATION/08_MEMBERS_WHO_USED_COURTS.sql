SELECT CONCAT(hw_2.members.firstname, ' ', hw_2.members.surname) AS member, hw_1.facilities.name AS facility
FROM hw_2.bookings
JOIN hw_2.members ON hw_2.bookings.memid = hw_2.members.memid --джойню по memid, чтобы в добавить информаци о клиентах
JOIN hw_1.facilities ON hw_2.bookings.facid = hw_1.facilities.facid --джойню по facid, чтобы в добавить информаци об удобствах
WHERE hw_1.facilities.facid = 0 OR hw_1.facilities.facid = 1 --оставляю только тенисные корты
GROUP BY member, facility
ORDER BY member, facility;
