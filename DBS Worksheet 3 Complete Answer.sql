-- CREATING A VARRAY FOR THE EXCHANGE TRADED.
CREATE TYPE exchanges_varray as VARRAY(3)
OF VARCHAR(40)
/

-- CRATETING A OBJECT FOR THE STOCK TABLE DATA.
CREATE TYPE stock_type AS OBJECT 
(
    companyName VARCHAR(20),
    currentPrice NUMBER (6,2),
    exchanges exchanges_varray,
    lastDivident NUMBER (4,2),
    eps NUMBER (4,2)
) 

-- CREATING A ADDRESS TYPE OBJECT 
CREATE TYPE address_type AS OBJECT 
(
    streeNo char (10),
    streetName char (15),
    subrub char(20),
    state char(15),
    pin char(10)

)

-- CREATING THE OBJECT FOR THE CLIENTS. 


-- CREATING THE TABLE FOR THE STOCK TABLE.
CREATE TABLE 