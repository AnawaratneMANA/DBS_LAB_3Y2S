/* Printing for LOOP */
/* Strange behavior also print out the last element in the array */
DECLARE 
 a number (2);
BEGIN 
    FOR a IN REVERSE 10 .. 20 LOOP
        dbms_output.put_line(a);
    END LOOP;
dbms_output.put_line('Last Line ' || a);
END;
/

/* Printing values with While LOOP */
/* This loop act similar to that in Java. */
DECLARE 
    a number(2) := 1;
BEGIN
    WHILE a<5 LOOP
    dbms_output.put_line(a);
    a := a + 1;
    END LOOP;
END;
/

/* Simple loop evaluation */
/* Have the normal behavior to a do-while loop in Java */
DECLARE 
    a number(2) := 1;
BEGIN
    LOOP
    dbms_output.put_line(a);
    a := a + 1;
    EXIT WHEN a > 5;
    END LOOP;
END;
/

/* In PL SQL <> means, NOT EQUAL TO Similar to that in != Java */
DECLARE 
    a number(1):= 2;
     b number(1) :=1;
BEGIN
    IF a <> b THEN
    dbms_output.put_line('Printed');
    END IF;
END;
/
