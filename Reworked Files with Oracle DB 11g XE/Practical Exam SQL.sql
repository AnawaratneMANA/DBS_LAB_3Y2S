DECLARE 
    message VARCHAR2(50) := 'Printing Message';
BEGIN
    DBMS_OUTPUT.PUT_LINE(message);
END;
/

DECLARE 
    message VARCHAR2(50) NOT NULL := 'Printing Message';
BEGIN
    DBMS_OUTPUT.PUT_LINE(message);
END;
/

DECLARE 
        var_dname varchar(12);
        var_loc varchar(12);
        var_clno char(3) :='20';
BEGIN
    SELECT c.dname, c.loc INTO var_dname, var_loc
    FROM dept c
    WHERE c.deptno = var_clno;

    DBMS_OUTPUT.PUT_LINE('Name of the client with : ' || var_clno || ' is ' || var_dname);
END;
/
/* Column type Row fetching, Here also WHERE clause is madetory to get an output */
DECLARE
    c_id dept.deptno%type := 20;
    c_dname dept.dname%type;
    c_loc dept.loc%type;
BEGIN
    SELECT dname, loc INTO c_dname, c_loc
    FROM dept
    WHERE deptno = c_id;

    -- OUTPUT
    DBMS_OUTPUT.PUT_LINE('Department '||c_dname||' from ' || ' earns ' || c_loc);
END;
/

DECLARE 
TYPE employee_type IS RECORD 
(
    deptno number,
    dname varchar2(15),
    loc varchar2(15)
);

/* Create a record based on the type defined. */
/* WHERE Clause is mandetory to use with this type of Row fetching */
employee_rec employee_type;
BEGIN
    SELECT * INTO employee_rec
    FROM dept
    WHERE deptno='20';
    dbms_output.put_line(employee_rec.dname);
END;
/

/* Example of using ROWTYPE */
/* WHERE Clause is mandetory to use with this type of ROWTYPE fetching */
DECLARE 
    dept_row   dept%ROWTYPE;
    dept_no  dept.deptno%TYPE := 20;
BEGIN
    SELECT * INTO dept_row FROM dept WHERE deptno = dept_no;
    -- Printing the Column values in the ROWTYPE
     DBMS_OUTPUT.PUT_LINE('Department ID  '|| dept_row.dname);
     DBMS_OUTPUT.PUT_LINE('Employee Name  '|| dept_row.loc);
END;
/

/* Conditional Statement in PL SQL */
DECLARE
A  number(2) := 20;
BEGIN
    IF(a < 20) THEN
         DBMS_OUTPUT.PUT_LINE('a is less than 20');
    END IF;
    DBMS_OUTPUT.PUT_LINE('Value of a is ' || a);
END;
/

/* Conditional Statement IF with ELSIF (else if) clause */
DECLARE
    a number(2) := 10;
BEGIN
    IF (a < 20) THEN
        DBMS_OUTPUT.PUT_LINE('a is less than 20');
    ELSE
        DBMS_OUTPUT.PUT_LINE('a is not less than 20');
    END IF;
    DBMS_OUTPUT.PUT_LINE('value of a is ' || a);
END;
/

/*Simple loop with PL SQL*/
DECLARE 
    i Integer := 1;
BEGIN
    LOOP
    DBMS_OUTPUT.PUT_LINE(i);
    i := i +1;
    EXIT;
    END LOOP;
END;

/* Basic Simple Loop | With Exit condition */
DECLARE
    x number :=10;
BEGIN
    LOOP
        DBMS_OUTPUT.PUT_LINE(x);
        x := x+10;
        EXIT WHEN x > 50;
    END LOOP;
    DBMS_OUTPUT.PUT_LINE('After Exit x is ' || x);
END;
/

/* Basic while Loop*/
DECLARE
    a number(2) := 10;
BEGIN
    WHILE a<20 LOOP
    DBMS_OUTPUT.PUT_LINE('Value of a is ' || a);
    a := a + 1;
    END LOOP;
END;
/

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
    <<"This is a LOOP">> FOR a in 10 .. 20 LOOP
    DBMS_OUTPUT.PUT_LINE('Value of a is ' || a);
    END LOOP;
END;
/

/* Example Implicit Cursor given in the Lab Sheet */
DECLARE
    rows number(3);
BEGIN
    UPDATE dept
    SET loc = 'FLORIDA'
    WHERE deptno = 20;

    IF SQL%NOTFOUND THEN 
        DBMS_OUTPUT.PUT_LINE('Execute Statement 1');
    ELSIF SQL%FOUND THEN
        rows := SQL%ROWCOUNT;
        DBMS_OUTPUT.PUT_LINE('Execute Statement 2 ' || ' Updated Row Count - ' || rows);
    END IF;
END;
/

/* Usage of Cursor in PL SQL*/
/* Validation method added to check whether the cursor opened or not*/
DECLARE
    CURSOR dept_cur IS
        SELECT dname, loc
        FROM dept;
    dept_rec dept_cur%rowtype;
BEGIN
    IF NOT dept_cur%ISOPEN THEN
        DBMS_OUTPUT.PUT_LINE('Open');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Close');
    END IF;
    FOR dept_rec in dept_cur LOOP
    DBMS_OUTPUT.PUT_LINE('Department Name : ' || dept_rec.dname || ' LOC: ' || dept_rec.loc);
    END LOOP;
END;
/

/* Explicit Cursor Example with Open and Close Cursor*/
DECLARE 
    CURSOR dept_cur IS
        SELECT dname, loc
        FROM dept;
    dept_rec dept_cur%rowtype;
BEGIN

    IF NOT dept_cur%ISOPEN THEN
        OPEN dept_cur;
    END IF;

    LOOP
    FETCH dept_cur INTO dept_rec;
    EXIT WHEN dept_cur%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE('Printing a Statement');
   END LOOP;
   CLOSE dept_cur;
END;
/



