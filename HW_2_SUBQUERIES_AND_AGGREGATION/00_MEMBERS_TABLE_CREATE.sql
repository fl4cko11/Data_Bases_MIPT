CREATE TABLE hw_2.members(
    memid          INTEGER                NOT NULL,
    surname        CHARACTER VARYING(200) NOT NULL,
    firstname      CHARACTER VARYING(200) NOT NULL,
    address        CHARACTER VARYING(300) NOT NULL,
    zipcode        INTEGER                NOT NULL,
    telephone      CHARACTER VARYING(20)  NOT NULL,
    recommendedby  INTEGER,
    joindate       TIMESTAMP              NOT NULL
);

\copy HW_2.members (memid, surname, firstname, address, zipcode, telephone, recommendedby, joindate)
FROM '/home/vladh/git-repos/Data_Bases_MIPT/HW_2_SUBQUERIES_AND_AGGREGATION/members.csv'
WITH (
    FORMAT CSV,
    DELIMITER ',',
    NULL '',
    HEADER true
);
