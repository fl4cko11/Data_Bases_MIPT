CREATE TABLE hw_1.facilities (
   facid               INTEGER                NOT NULL, 
   name                CHARACTER VARYING(100) NOT NULL, 
   membercost          NUMERIC                NOT NULL, 
   guestcost           NUMERIC                NOT NULL, 
   initialoutlay       NUMERIC                NOT NULL, 
   monthlymaintenance  NUMERIC                NOT NULL
);

\copy hw_1.facilities (facid, name, membercost, guestcost, initialoutlay, monthlymaintenance)
FROM '/home/vladh/git-repos/Data_Bases_MIPT/HW_1_SIMPLE_QUERIES/facilities.csv'
WITH (
    FORMAT CSV,
    DELIMITER ',',
    NULL '',
    HEADER true
);
