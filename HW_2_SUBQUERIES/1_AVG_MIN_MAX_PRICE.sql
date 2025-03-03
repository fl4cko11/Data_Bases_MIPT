SELECT full_nm AS full_name, 
       AVG(avg_price) AS avg_price, 
       MAX(high_price) AS max_price, 
       MIN (low_price) AS min_price
FROM hw_1.coins
GROUP BY full_nm;
