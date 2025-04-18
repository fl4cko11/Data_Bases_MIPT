CREATE TABLE IF NOT EXISTS HW_1.coins (
    dt VARCHAR(16),
    avg_price NUMERIC,
    tx_cnt NUMERIC,
    tx_vol NUMERIC,
    active_addr_cnt NUMERIC,
    symbol VARCHAR(8),
    full_nm VARCHAR(128),
    open_price NUMERIC,
    high_price NUMERIC,
    low_price NUMERIC,
    close_price NUMERIC,
    vol NUMERIC,
    market NUMERIC
);

\copy HW_1.coins (dt, avg_price, tx_cnt, tx_vol, active_addr_cnt, symbol, full_nm, open_price, high_price, low_price, close_price, vol, market)
FROM '/home/vladh/git-repos/Data_Bases_MIPT/HW_1_SIMPLE_QUERIES/coins.csv'
WITH (
    FORMAT CSV,
    DELIMITER ',',
    NULL '',
    HEADER true
);
