-- PL SQL IMPORTANT POINTS.
/* Basic Syntax of PL SQL */
DECLARE
    -- Variable declaration
BEGIN
    --Execution section <MANDOTORY>
EXCEPTION
    --Exception handling seciton
END;

/* Comments in PL SQL - This is a PL Multiline Comment */
-- Comments in PL SQL - This is a PL Single Line Comment

/* Printing Values in PL SQL */
DECLARE 
BEGIN
    DBMS_OUTPUT.PUT_LINE("Printing Message");
END;
/

/* Declare a Variable and Print the Value */
DECLARE 
    message VARCHAR2(50) := 'Printing Message';
BEGIN
    DBMS_OUTPUT.PUT_LINE(message);
END;
/

/* Declare NOT NULL variables */
DECLARE 
    message VARCHAR2(50) NOT NULL := 'Printing Message';
BEGIN
    DBMS_OUTPUT.PUT_LINE(message);
END;
/

/* Query data injetion and String concatenation */
DECLARE 
        var_cname varchar(12);
        var_clno char(3) :='c01';
BEGIN
    SELECT c.name INTO var_cname
    FROM client c
    WHERE c.clno = var_clno

    DBMS_OUTPUT.PUT_LINE('Name of the client with : ' || var_clno || ' is ' || var_cname);
END;
/

/* Query data injetion to Multiple Variables */
DECLARE
    c_id Customers.id%type := 1;
    c_name Customers.name%type;
    c_addr Customers.address%type;
    c_sal Customer.salary%type;
BEGIN
    SELECT name, address, salary INTO c_name, c_address, c_sal
    FROM Customers
    WHERE id = c_id;

    -- OUTPUT
    DBMS_OUTPUT.PUT_LINE('Customer '||c_name||' from ' || ' earns ' || c_sal);
END;
/

/* Local and Global Variables */
/*
    Inner variables can't be used in outside scopes, Outside scoped
    variables can be used in inner scopes.
*/
DECLARE
    var_number_1 number;
BEGIN   
    DECLARE 
        var_number_2 number;
    BEGIN
        var_number_1 = var_number_2 + var_number_1;a
    END;
END;
/

/* Declare record variables - Method 1 */
/* This is ideal if the row is based on multiple tables */
DECLARE 
TYPE employee_type IS RECORD 
(
    employee_id number;
);

/* Create a record based on the type defined. */
employee_rec employee_type;

/* If the row is based on a column of a table - Method 2 */
/* This is basically storing the data in vertical manner */
DECLARE 
employee_rec employee%ROWTYPE;

/* Example usage of ROWTYPE in Oracle DB */
DECLARE 
    emp_rec   employees%ROWTYPE;
    my_empno  employees.employee_id%TYPE := 100;
BEGIN
    SELECT * INTO emp_rec FROM employee WHERE employee_id = my_empno;
    -- Printing the Column values in the ROWTYPE
     DBMS_OUTPUT.PUT_LINE('Department ID  '|| emp_rec.departmentId);
     DBMS_OUTPUT.PUT_LINE('Employee Name  '|| emp_rec.name);
END;
/

/* Conditional Statement in PL SQL */
DECLARE
A  number(2) := 20;
BEGIN
    IF(a < 20) THEN
         DBMS_OUTPUT.PUT_LINE('a is less than 20');
    END IF
    DBMS_OUTPUT.PUT_LINE('Value of a is ' || a);
END;
/

/* Conditional Statement IF with ELSIF (else if) clause */
DECLARE
    a number(2) := 10;
BEGIN
    IF (a < 20) THEN
        DBMS_OUTPUT.PUT_LINE("a is less than 20");
    ELSE
        DBMS_OUTPUT.PUT_LINE("a is not less than 20");
    END IF;
    DBMS_OUTPUT.PUT_LINE("value of a is " || a);
END;
/

/* Loops | Iterations in PL SQL */
/* Basic Simple Loop*/
DECLARE 
    i Integer := 1;
BEGIN
    LOOP
    DBMS_OUTPUT.PUT_LINE(i);
    i = i +1;
    EXIT;
    END LOOP;
END;

/* Basic Simple Loop*/
DECLARE
    x number :=10;
BEGIN
    LOOP
        DBMS_OUTPUT_PUT_LINE(x);
        x = x+10;
        EXIT WHEN x > 50;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE("After Exit x is " || x);
END;
/

/* Basic while Loop*/
DECLARE
    a number(2) := 10;
BEGIN
    WHILE a<20 LOOP
    DBMS_OUTPUT.PUT_LINE('Value of a is ' || a);
    a = a + 1;
    END LOOP;
END;

/* For Loop example in PL SQL */
DECLARE
    a number(2);
BEGIN
    FOR a in 10 .. 20 LOOP
    DBMS_OUTPUT.PUT_LINE('Value of a is ' || a);
    END LOOP;
END;
/

/* PL SQL Labels | Similar to giving a name to the loop | Only used with loops*/ 
DECLARE
    a number(2);
BEGIN
    <<This is a LOOP>> FOR a in 10 .. 20 LOOP
    DBMS_OUTPUT.PUT_LINE('Value of a is ' || a);
    END LOOP;
END;
/

/* PL SQL Cursors [Implicit cursors and Explicit cursors]*/ 
/* Upon any DML update implicit cursor get created automatically */
/* Example Implicit Cursor given in the Lab Sheet */
DECLARE
BEGIN
    UPDATE purchase
    SET p.qty = p.qty + 100;

    IF SQL%NOTFOUND THEN 
        DBMS_OUTPUT.PUT_LINE("Execute Statement 1")
    ELSIF SQL%FOUND THEN
        var rows := SQL%ROWCOUNT;
        DBMS_OUTPUT.PUT_LINE("Execute Statement 2 | Updated Row Count - " || rows)
    END IF;
END;
/

/* Printing Values of A Select Statement with Cursors */
DECLARE
    CURSOR stock_cur IS
        SELECT s.company, s.price
        FROM stock salary
    stock_rec stock_cur%rowtype;
BEGIN
    FOR stock_rec in stock_cur LOOP
    DBMS_OUTPUT.PUT_LINE('Company : ' || stock_rec.company || ' Current Price: ' || stock_rec.current_price);
    END LOOP;
END;
/

/* Example Explicit Cusor given in the Lab Sheet */
/* NOTE: This type of Cursors are created by the programmer, Do not get 
create automatically | There are main 4 steps to create and use the explicit cursor*/
/* Declaration of the Explicit Cursor */

DECLARE
    CURSOR emp_cur IS
    SELECT * 
    FROM emp_tab
    WHERE salary > 5000;

/* Explicit Cursor need to be opened. In the execution section BEGIN*/
OPEN emp_cur;

/* Fetching record into the Cursor In the BEGIN section*/
FETCH cursor_name INTO variable_list;

/* After closing the cursor */
CLOSE cursor_name;

/* Example usage of Explicit Cursors.*/
DECLARE 
    CURSOR stock_cur IS
        SELECT s.company, s.price
        FROM stock salary
    stock_rec stock_cur%rowtype;
BEGIN

    IF NOT stock_cur%ISOPEN THEN
        OPEN stock_cur;
    END IF

    LOOP
    FETCH stock_cur INTO stock_rec;
    EXIT WHEN stock_cur%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE("Printing a Statement")
   END LOOP
END;
/