/* Re Attempting the ORDB SQL LAB 3 */
/* Creating the VARRAY for storing exchange rates */
CREATE TYPE exchange_rate$lab3 AS VARRAY(3)OF VARCHAR(50);

/* Creating a object type for the stock table */
CREATE TYPE stock_type$lab3 AS OBJECT 
(
    compnayName VARCHAR(20),
    currentPrice NUMBER(6,2),
    exchange exchange_rate$lab3,
    lastDivident NUMBER(4,2),
    eps NUMBER(4,2)
)

/* Crating a object for Address type */
CREATE TYPE address_type$lab3 AS OBJECT (
    streetNo CHAR(10),
    streetName CHAR(15),
    subrub CHAR(20),
    state CHAR(15),
    pin CHAR(10)
)

/* Creating a Obejct for the nested table investment type */
CREATE TYPE investment_type$lab3 AS OBJECT (
    company REF stock_type$lab3,
    purchasePrice NUMBER(6,2),
    purchaseDate DATE,
    quantity NUMBER(6)
)

/* IMP#2 Creating a Nested Table */
CREATE TYPE invest_tab$lab3 AS TABLE OF investment_type$lab3
/

/* Creating a Type for Clients */
CREATE TYPE client_type$lab3 AS OBJECT 
(
    name VARCHAR(40),
    address address_type$lab3,
    investment_table invest_tab$lab3
)

/* Creating a table for the stocks using the type created before */
/* PRIMARY KEYS can be define at the time of creating the table */
CREATE TABLE stock$lab3 OF stock_type$lab3 (
    CONSTRAINT stock_pk PRIMARY KEY(compnayName)
)
/

/* Creating a table for the clients using the client type created before */
CREATE TABLE client$lab3 OF client_type$lab3 (
    CONSTRAINT client_pk PRIMARY KEY (name)
) NESTED TABLE investment_table STORE AS investment_tab
/

/* Assign the scope for the REF in investment table to the stock table */
ALTER TABLE investment_tab ADD SCOPE FOR (company) IS stock$lab3
/

/* Insert data into the stock table */
INSERT INTO stock$lab3 VALUES (stock_type$lab3('ORACLE', 60.00, exchange_rate$lab3('Colombo', 'New York', 'Boston'), 2.50, 9.20));
INSERT INTO stock$lab3 VALUES (stock_type$lab3('DMG', 70.00, exchange_rate$lab3('Katubadda', 'New York', 'New Mexico'), 3.50, 5.20));

/* Adding data to the client table */
/* When inserting the data to a REF data should be inserted via a SELECT Query */
INSERT INTO client$lab3 VALUES (
client_type$lab3(
    'Nirmith Akash', 
    address_type$lab3('48/8','KD Place','Ratmalana','N/A','N/A'), 
    invest_tab$lab3(
        investment_type$lab3((SELECT REF(d) FROM stock$lab3 d WHERE compnayName='ORACLE'),12.00,TO_DATE('2003/05/03 21:02:44', 'yyyy/mm/dd hh24:mi:ss'),100)
        )
    )
)
/
