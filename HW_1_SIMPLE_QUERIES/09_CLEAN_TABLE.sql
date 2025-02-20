DELETE FROM HW_1.coins
WHERE vol = 0.0 OR vol IS NULL 
   OR active_addr_cnt = 0.0 OR active_addr_cnt IS NULL;
