SELECT dt, high_price, vol FROM HW_1.coins
WHERE symbol = 'DOGE' AND avg_price > 0.001 AND (dt LIKE '2018-%');
