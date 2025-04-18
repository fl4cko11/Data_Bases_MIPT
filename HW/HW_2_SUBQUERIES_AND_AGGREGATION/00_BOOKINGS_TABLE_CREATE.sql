CREATE TABLE hw_2.bookings(
   bookid     INTEGER   NOT NULL, 
   facid      INTEGER   NOT NULL, 
   memid      INTEGER   NOT NULL, 
   starttime  TIMESTAMP NOT NULL,
   slots      INTEGER   NOT NULL
);

\copy HW_2.bookings (bookid, facid, memid, starttime, slots)
FROM '/home/vladh/git-repos/Data_Bases_MIPT/HW_2_SUBQUERIES_AND_AGGREGATION/bookings.csv'
WITH (
    FORMAT CSV,
    DELIMITER ',',
    NULL '',
    HEADER true
);
