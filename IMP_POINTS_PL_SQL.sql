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

