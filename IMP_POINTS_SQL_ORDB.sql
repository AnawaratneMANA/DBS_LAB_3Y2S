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
