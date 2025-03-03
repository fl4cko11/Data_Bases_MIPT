CREATE TABLE IF NOT EXISTS HW_1.HW (
    ID INTEGER,
    HEIGHT FLOAT4,
    WEIGHT FLOAT4
);

\copy HW_1.HW (ID, HEIGHT, WEIGHT)
FROM '/home/vladh/git-repos/Data_Bases_MIPT/HW_1_SIMPLE_QUERIES/hw.csv'
WITH (
    FORMAT CSV,
    DELIMITER ',',
    NULL '',
    HEADER true
);
