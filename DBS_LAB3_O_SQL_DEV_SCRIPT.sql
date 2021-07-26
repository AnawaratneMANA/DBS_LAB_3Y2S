-- CREATING DATABASE AND INSERT DATA.
CREATE TABLE client (
clno char(3),
name varchar(12),
Address varchar(30),
CONSTRAINT client_PK PRIMARY KEY(clno)
)

CREATE TABLE stock (
company char(7),
price number(6,2),
divident number(4,2),
eps number (4,2),
CONSTRAINT stock_PK PRIMARY KEY(company)
)

CREATE TABLE trading(
company char(7),
exchange varchar(12),
CONSTRAINT trading_PK PRIMARY KEY(company, exchange),
CONSTRAINT trading_exchange_FK FOREIGN KEY(company) REFERENCES stock
)

CREATE TABLE purchase (
clno char(3),
company char(7), 
pdate date,
qty number(6),
price number(6,2),
CONSTRAINT purchase_PK PRIMARY KEY (clno, company, pdate),
CONSTRAINT purchase_FK1 FOREIGN KEY (clno) REFERENCES client,
CONSTRAINT purchase_FK2 FOREIGN KEY(company) REFERENCES stock
)

INSERT INTO client VALUES ('100','John smith', '3 East Av Bently WA 6120');
INSERT INTO client VALUES ('101','Nimith Aka', '5 Bakers Street BS123');

SELECT * FROM CLIENT;

INSERT INTO stock VALUES('BHP', 10.50, 1.50, 3.20);
INSERT INTO stock VALUES('IBM', 70.00, 4.25, 10.00);
INSERT INTO stock VALUES('INTEL', 76.50, 5.00, 12.40);
INSERT INTO stock VALUES('FORD', 40.00, 2.00, 8.50);
INSERT INTO stock VALUES('GM', 60.00, 2.50, 9.20);
INSERT INTO stock VALUES('INFOSYS', 45.00, 3.00, 7.80);

SELECT * FROM STOCK;
DELETE FROM STOCK WHERE COMPANY = 'IDB';

INSERT INTO trading VALUES('BHP', 'Sydney');
INSERT INTO trading VALUES('BHP', 'New York');
INSERT INTO trading VALUES('IBM', 'New York');
INSERT INTO trading VALUES('IBM', 'London');
INSERT INTO trading VALUES('IBM', 'Tokyo');
INSERT INTO trading VALUES('INTEL', 'New York');  
INSERT INTO trading VALUES('INTEL', 'London');
INSERT INTO trading VALUES('FORD', 'New York');
INSERT INTO trading VALUES('GM', 'New York');
INSERT INTO trading VALUES('INFOSYS', 'New York');

SELECT * FROM TRADING;

INSERT INTO purchase VALUES('100', 'BHP', '08-JUN-2002', 2000, 10.50);
INSERT INTO purchase VALUES('100', 'IBM', '12-FEB-2000', 500, 58.00);
INSERT INTO purchase VALUES('100', 'IBM', '10-APR-2001', 1200, 65.00);
INSERT INTO purchase VALUES('100', 'INFOSYS', '11-AUG-2001', 1000, 64.00);
INSERT INTO purchase VALUES('101', 'INTEL', '30-JUN-2000', 300, 35.00);
INSERT INTO purchase VALUES('101', 'INTEL', '30-JUN-2001', 400, 54.50);
INSERT INTO purchase VALUES('101', 'INTEL', '02-OCT-2001', 200, 60.00);
INSERT INTO purchase VALUES('101', 'FORD', '05-OCT-1999', 300, 40.00);
INSERT INTO purchase VALUES('101', 'GM', '12-DEC-2000', 500, 55.50);

SELECT * FROM PURCHASE;

-- ANSWERS AND QUERIES.
-- Answer 1
SELECT DISTINCT c.name, p.company, s.price, s.divident, s.eps
FROM client c, purchase p, stock s
WHERE c.clno = p.clno and p.company = s.company;

-- Answer 2
SELECT c.name, p.company, SUM(p.qty) TOTAL_QTY, SUM(p.qty* p.price)/SUM(p.qty) APP
FROM client c, purchase p
WHERE c.clno = p.clno
GROUP BY c.name, p.company;

--Answer 3
SELECT p.company, c.name, SUM(p.qty) total_qty, SUM(p.qty*s.price) current_value
FROM client c, purchase p, stock s, trading t 
WHERE c.clno=p.clno and p.company = s.company and s.company= t.company and t.exchange='New York'
GROUP BY p.company, c.name;

-- Answer 4
SELECT c.name, SUM(p.qty * p.price)
FROM client c, purchase p
WHERE c.clno = p.clno
GROUP BY c.name;

-- Answer 5
SELECT c.name, SUM(p.qty*(s.price - p.price)) book_profit
FROM client c, purchase p, stock s
WHERE c.clno = p.clno and p.company = s.company
GROUP BY c.name
