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
    DBMS_OUTPUT_PUT_LINE('Customer '||c_name||' from ' || ' earns ' || c_sal);
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
DECLARE 
TYPE employee_type IS RECORD 
(
    employee_id number;
);

/* Create a record based on the type defined. */
employee_rec employee_type;


