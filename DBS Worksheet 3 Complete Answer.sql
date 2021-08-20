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

-- CREATING OBJECT FOR RECORD INVESTMENT DETAILS
CREATE TYPE investment_type AS OBJECT 
(
    company REF stock_type,
    purchasePrice NUMBER (6,2),
    purchaseDate DATE,
    quantity NUMBER(6)
)

-- CREATE THE NESTED TABLE FOR THE INVESTMENTS (DIFFERNET THAN CREATING A TABLE)
CREATE TYPE investment_nestedtbl_type AS TABLE OF investment_type
/

-- CREATING THE OBJECT FOR THE CLIENTS. (REFER TO THE NESTED TABLE CREATED ABOVE)
CREATE TYPE client_type AS OBJECT 
(
    name VARCHAR (40),
    address adress_type,
    investment investment_nestedtbl_type
)


-- CREATING THE TABLE FOR THE STOCK TABLE.
CREATE TABLE stock of stock_type 
(
    CONSTRAINT stock_pk PRIMARY KEY (companyName)
)