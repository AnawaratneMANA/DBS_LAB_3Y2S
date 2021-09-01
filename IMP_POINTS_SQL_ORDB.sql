-- CREATING A VARRAY FOR THE EXCHANGE TRADED.
CREATE TYPE exchanges_varray as VARRAY(3)
OF VARCHAR(40)
/

-- INCLUDE CRATED VARRAY IN A OBJECT BLUEPRINT.
CREATE TYPE stock_type AS OBJECT 
(
    companyName VARCHAR(20),
    currentPrice NUMBER (6,2),
    exchanges exchanges_varray,
    lastDivident NUMBER (4,2),
    eps NUMBER (4,2)
)
/

-- CREATE A TABLE WITH REF
CREATE TYPE MenuType2 AS OBJECT (
	bar		REF BarType,
	beer		REF BeerType,
	price	FLOAT)
/
-- CREATE A TABLE WITH THE OBJECT TYPE
CREATE TABLE Sells OF MenuType2;

-- INSERT VALUES INTO THE TABLE CREATED WIHT MenuType2
INSERT INTO sells VALUES(
	(SELECT REF(b) FROM bars b WHERE name='Jim''s'),
	(SELECT REF(e) FROM beers e WHERE name='Swan'),
	2.40);


-- CREATING NESTED TABLES. 
-- CREATING THE OBJECT TEMPLATE FOR THE NESTED TABLE.
CREATE TYPE investment_type AS OBJECT 
(
    company REF stock_type,
    purchasePrice NUMBER (6,2),
    purchaseDate DATE,
    quantity NUMBER(6)
)
/

-- CREATE THE NESTED TABLE FOR THE INVESTMENTS USING THE ABOVE TEMPLATE (DIFFERNET THAN CREATING A TABLE)
CREATE TYPE investment_nestedtbl_type AS TABLE OF investment_type
/

-- CREATING THE PARENT TEMPLATE FOR PARENT TABLE.
-- CREATING THE OBJECT FOR THE CLIENTS. (REFER TO THE NESTED TABLE CREATED ABOVE)
CREATE TYPE client_type AS OBJECT 
(
    name VARCHAR (40),
    address adress_type,
    investment investment_nestedtbl_type
)
/

-- CREATING THE PARENT TABLE.
CREATE TABLE client of client_type 
(
    CONSTRAINT client_pk PRIMARY KEY(name)
) NESTED TABLE investment STORE AS investment_tab
/


