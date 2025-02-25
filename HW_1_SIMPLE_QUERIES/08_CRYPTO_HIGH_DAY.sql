SELECT UPPER(c.full_nm) AS full_name, c.dt, c.high_price AS price
FROM hw_1.coins c
JOIN ( --формируем таблицу для каждой монеты - макс прайс
    SELECT full_nm, MAX(high_price) AS price
    FROM hw_1.coins
    GROUP BY full_nm
) m --m ссылка на резуьтат подзапроса
ON c.full_nm = m.full_nm AND c.high_price = m.price --меняем основную таблицу: пересекаем по результатам подзапроса
WHERE c.dt = (
    SELECT MIN(dt)
    FROM hw_1.coins --смотрим на изначальную таблицу
    WHERE full_nm = c.full_nm AND high_price = c.high_price --условие, чтобы для каждого имени и макс цены мин дату найти
)
ORDER BY c.high_price DESC, c.full_nm;
