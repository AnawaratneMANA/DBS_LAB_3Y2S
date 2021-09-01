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

-- ACCESSING THE NESTED TABLE WITH THE PARENT TABLE. 
SELECT e.eno, p.* 
FROM employees e, TABLE (e.projects) p;

-- UPDATE VALUES IN NESTED TABLE (UPDATE, INSERT, DELETE)
INSERT INTO TABLE(SELECT e.projects 
				     FROM employees e 
				     WHERE e.eno = 1000) 
   VALUES (103, 'Project Neptune');

UPDATE TABLE(SELECT e.projects 
			         FROM employees e 
				     WHERE e.eno = 1000) p 
   SET p.projname = 'Project Pluto' 
   WHERE p.projno = 103;

DELETE TABLE(SELECT e.projects 
			         FROM employees e 
				     WHERE e.eno = 1000) p
   WHERE p.projno = 103; 

-- DROP A NESTED TABLE COLUMN
UPDATE employees e
	SET e.projects = NULL 
	WHERE e.eno = 1000; 

-- ADD BACK A NESTED TABLE COLUMN.
UPDATE employees e
	SET e.projects = proj_list(proj_t(103, 'Project Pluto'))
	WHERE e.eno=1000;


-- LECTURE PART II METHODS AND INHERITANCE.
-- FIRST ADD THE METHOD DECLARATION.
CREATE TYPE MenuType AS OBJECT ( 
   bar REF BarType, 
   beer REF BeerType, 
   price FLOAT, 
   MEMBER FUNCTION priceInYen(rate IN FLOAT)
      RETURN FLOAT
)
/

-- DEFINE THE BODY OF THE METHOD.
CREATE TYPE BODY MenuType AS 
MEMBER FUNCTION 
priceInYen(rate FLOAT) 
RETURN FLOAT IS 
	BEGIN 
		RETURN rate * SELF.price; 
	END; 
END; 
/ 

-- CREATE A TABLE ON THE TYPE.
CREATE TABLE Sells OF MenuType; 

-- ALTERING AND ADDING A NEW FUNCTION
ALTER TYPE MenuType 
     ADD MEMBER FUNCTION priceInUSD(rate FLOAT)
     RETURN FLOAT CASCADE;	

-- ENTIRE FUNCTION SHOULD BE REWRITE WITH THE NEW FUNCTION INTANCT.
CREATE OR REPLACE TYPE BODY MenuType AS 
MEMBER FUNCTION 
priceInYen(rate FLOAT) 
RETURN FLOAT IS 
	BEGIN 
		RETURN rate * SELF.price; 
	END priceInYen; 
MEMBER FUNCTION 
priceInUSD(rate FLOAT) 
RETURN FLOAT IS 
	BEGIN 
		RETURN rate * SELF.price; 
	END priceInUSD; 
END; 
/

-- MAP METHOD FOR OBJECT COMPARISON. (PARAMETERLESS)
CREATE TYPE Rectangle_type AS OBJECT 
( length NUMBER, 
   width NUMBER, 
  MAP MEMBER FUNCTION area RETURN NUMBER
); 
CREATE TYPE BODY Rectangle_type AS MAP MEMBER FUNCTION area RETURN NUMBER IS 
	BEGIN 
		RETURN length * width; 
   END area; 
END;

-- ORDER METHODS FOR DIRECT OBJECT TO OBEJCT COMPARISON WITH MINIMAL COMPLEXITY
CREATE TYPE Customer_typ AS OBJECT 
	( id NUMBER, 
	  name VARCHAR2(20), 
	  addr VARCHAR2(30), 
	  ORDER MEMBER FUNCTION match (c Customer_typ) RETURN INTEGER ); 
	/ 

-- DECLARATION
CREATE TYPE BODY Customer_typ AS 
	ORDER MEMBER FUNCTION match (c Customer_typ) RETURN INTEGER IS
	BEGIN 
		IF id < c.id THEN RETURN -1; -- any num <0 
		ELSIF id > c.id THEN RETURN 1; -- any num >0 	ELSE RETURN 0; 
		END IF; 
	END; 
	END; 
/ 

-- CREATE INHERITANCE RELATIONSHIPS IN ORACLE
CREATE TYPE Person_type AS OBJECT
	( pid NUMBER,
 	  name VARCHAR2(30),
 	  address VARCHAR2(100) )   NOT FINAL;

-- NOT FINAL SHOULD BE THERE TO CREATE SUB TYPES
-- THIS CAN BE ALTERED AS WELL AFTER CREATING.
ALTER TYPE Person_type FINAL;

-- CREATE SUBTYPES 
CREATE TYPE Student_type UNDER Person_type 
	  ( deptid NUMBER,
       major VARCHAR2(30)) NOT FINAL;
/

-- WHEN INSERTING DATA TO PARENT WE ALSO CAN INSERT DATA TO SUBTYPES AS WELL.
CREATE TABLE person_tab of person_type
(pid PRIMARY KEY);

INSERT INTO person_tab VALUES
	( student_type(4, 'Edward Learn', 
          '65 Marina Blvd, Ocean Surf, WA, 6725',
          40, 'CS')
   );

-- SELECTING INSTANCES. (FROM PARENT TO SUB LEVELS)
-- ALL
SELECT VALUE(p) FROM person_tab p; 
-- SUB LEVEL ONWARDS.
SELECT VALUE(s) 
FROM person_tab s 
WHERE VALUE(s) IS OF (Student_type);
-- ONLY A PARTICULAR LEVEL.
SELECT VALUE(s) 
FROM person_tab s 
WHERE VALUE(s) IS OF (ONLY student_type);

-- ACCESSING SUBLEVEL ATTRIBUTES WITH TREAT() FUNCTION
SELECT Name, TREAT(VALUE(p) AS PartTimeStudent_type).numhours hours
FROM person_tab p 
WHERE VALUE(p) IS OF (ONLY PartTimeStudent_type); 

-- NOT INSTANTIABLE OBJECTS. (SIMILAR TO ABSTRACT CLASSES)
CREATE TYPE Address_typ AS OBJECT(...) NOT INSTANTIABLE NOT FINAL;* 
CREATE TYPE AusAddress_typ UNDER Address_typ(...); 
CREATE TYPE IntlAddress_typ UNDER Address_typ(...); 













