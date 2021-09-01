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

-- ADDING SCOPE TO THE INVESTMENT TABLE (NESTED TABLE)
/**
Purpose of adding this is to point the REF to a specific value 
than pointing it to a object based on the table. 
**/
ALTER TABLE investment_tab
ADD SCOPE FOR (companyName) IS stock
/

-- ACCESSING DATA IN THE REF TABLES. 
SELECT s.beer.name 
	FROM Sells s 
	WHERE s.bar.name = 'Joe''s Bar'; 

-- GETTING VALUES FROM A QUERY.
SELECT pno, s.COLUMN_VALUE price
	FROM pricelist p, TABLE(p.prices) s;

-- HOW TO USE REF COLOUMN WHEN SEARCHING.
SELECT b.name
FROM TABLE( SELECT beers
			   FROM Manfs
			   WHERE name = ’Anheuser-Busch’) b
WHERE b.kind = ’ale’;

-- WORKING WITH VARRAYS. CREATING, INSERTING, FETCHING
CREATE TYPE price_arr AS 
	VARRAY(10) OF NUMBER(12,2)
/
CREATE TABLE pricelist (
	pno integer, 
	prices price_arr);

INSERT INTO pricelist 
	VALUES(1, price_arr(2.50,3.75,4.25));

SELECT pno, s.COLUMN_VALUE price
	FROM pricelist p, TABLE(p.prices) s;

-- NESTED TABLES DETAILED BRAKE DOWN.
CREATE TYPE BeerType AS OBJECT (
	name	CHAR(20),
	kind	CHAR(10),
	colour CHAR(10))
/
CREATE TYPE BeerTableType AS 
	TABLE OF BeerType
/
CREATE TABLE Manfs (
			name CHAR(30),
			addr	CHAR(50),
			beers beerTableType)
	NESTED TABLE beers STORE AS beer_table;

-- INSERTING VALUES INTO THE NESTED TABLE AND FETCHING.
INSERT INTO employees VALUES(1000, proj_list(
    proj_t(101, 'Avionics'), 
    proj_t(102, 'Cruise control')
));

-- THIS IS IF GETTING DATA ENTIRELY FROM THE NESTED TABLE.
/**
If we want to get data from the parent or outer table, Then we have to 
use the table() function to communicate with the nested table or varray. 
**/
SELECT * 
	FROM TABLE(SELECT t.projects FROM employees t 
	WHERE t.eno = 1000);





