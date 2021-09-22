/* Untype and Type XML Example in Create Table */
/* Untype Example */
CREATE TABLE AdminDocs (
    id int PRIMARY KEY,
    xDoc XML NOT NULL
)

/* Typed Example */
CREATE TABLE AdminDocs (
    id int PRIMARY KEY,
    xDoc XML (CONTENT myCollection)
)

/* Inserting a Untype XML example */
INSERT INTO AdminDocs VALUES (2,
'<doc id="123">
    <sections>
        <section num="1"><title>XML Schema</title></section>
        <section num="3"><title>Benefits</title></section>
        <section num="4"><title>Features</title></section>
    </sections>
</doc>')


/* Extract Scaler values using Value() method */
SELECT xDoc.value('data((/doc/section[@num = 3]/title)[1]', 'nvarchar(max)')
FROM AdminDocs

/* Using modify() method add new section to the XML */
UPDATE AdminDocs SET xDoc.modify('
    insert
    <section num = "2">
        <title>Background</title>
    </section>
after(/doc//section[@num = 1])[1]')



/* Select the whole table */
SELECT * FROM AdminDocs;

/* Using Query() method | filter sections */
/* If XML don't contains such section, then it will not show that file */
SELECT id, xDoc.query('/catalog')
FROM AdminDocs

/* Filter nested sections using Query() method */
SELECT id, xDoc.query('/catelog/product')
FROM AdminDocs

/* Directly calling a leaf section in the XML */
SELECT id, xDoc.query('//product')
FROM AdminDocs

/* Using the wild card method */
/* Can call lower levels direclty but each level should be
    showed with * mark between //    
*/
SELECT id, xDoc.query('/*/product')
FROM AdminDocs

/* Searching the XML file using @ attribute */
/* Using the wild card method to navigate to the product */
SELECT id, xDoc.query('/*/product[@dept="WMN"]') 
FROM AdminDocs
/* Using the direct accessing method to access the product section */
SELECT id, xDoc.query('//product[@dept="WMN"]') 
FROM AdminDocs

/* Alternative method of searching the section using child method.*/
/* Path should be defined to the exact level with wild card method*/
SELECT id, xDoc.query('/*/child::product[attribute::dept="WMN"]') 
FROM AdminDocs

/* Similar and alternative query to filter data.*/
/* No need to be at the exact level to retrive the data*/
SELECT id, xDoc.query('descendant-or-self::name[attribute::language="en"]') 
FROM AdminDocs

/* Filter parent section using the attributes in the child section*/
SELECT id, xDoc.query('//product[number < 500]') 
FROM AdminDocs
where id=6

/* Alternative Filtering Query using the gt/lt/le/ge methods */
SELECT id, xDoc.query('//product/number[. le 500]') 
FROM AdminDocs
where id=6

/* Array Like indexing with XML files using []*/
SELECT id, xDoc.query('/catalog/product[4]') 
FROM AdminDocs
where id=6

/* Checking multiple filtering condition mentioned above.*/
/* Check both the conditions and print out the one that satisfy the combination*/
SELECT id, xDoc.query('//product[number > 500][@dept="ACC"]')
FROM AdminDocs
where id=6

/* ? */
SELECT id, xDoc.query('//product[number < 500][1]')
FROM AdminDocs
where id=6

/* Running a loop of nested sections and fetch any child element in each section*/
SELECT xDoc.query(' for $prod in //product 
let $x:=$prod/name
return $x')
FROM AdminDocs
where id=6

/* Same thing with a loop but with a filtering with Where clause in the query*/
SELECT xDoc.query(' for $prod in //product 
let $x:=$prod/number
where $x>500
return $x')
FROM AdminDocs
where id=6

/* Wrap the output in our own HTML/XML tag. */
SELECT xDoc.query('for $prod in //product 
let $x:=$prod/number
where $x>500
return (<Item>{$x}</Item>)')
FROM AdminDocs
where id=6

/* Applying a filtering condition to the section array */
SELECT xDoc.query(' for $prod in //product[number > 500] 
let $x:=$prod/number
where $x>500
return (<Item>{$x}</Item>)')
FROM AdminDocs
where id=6

/* Same thing but without wrapping packing the data into the custom defined tag.*/
SELECT xDoc.query('for $prod in //product 
let $x:=$prod/number
where $x>500
return (<Item>{data($x)}</Item>)')
FROM AdminDocs
where id=6

/* Conditionally add the wrapper tag to the filtered items , Two or more items*/              
SELECT xDoc.query('for $prod in //product 
let $x:=$prod/number
return if ($x>500) 
then <book>{$x}</book>
else <paper>{$x}</paper>')
FROM AdminDocs
where id=6

/*While conditionally adding wrapper, Inserting the data directly to the custom wrappers.*/
SELECT xDoc.query('for $prod in //product 
let $x:=$prod/number
return if ($x>500) 
then <book>{data($x)}</book>
else <paper>{data($x)}</paper>')
FROM AdminDocs
where id=6

/*Filter using SQL where clause, from XML data | with exist function */
SELECT id 
FROM AdminDocs
WHERE xDoc.exist ('/doc[@id = 123]') = 1

/* Nested search into the XML file and extract the value not the section */
SELECT xDoc.value('(/doc//section[@num = 3]/title)[1]', 'varchar(100)')
FROM AdminDocs

/* Normal Query with where clause */
select * from AdminDocs where id=2

/* Removing and Inserting sections from the XML file*/
/* Inserting a section */
UPDATE AdminDocs SET xDoc.modify('
 insert 
 <section num="2"> 
 <title>Background</title>
 </section>
 after (/doc//section[@num=1])[1]')

/* Removing a section */
UPDATE AdminDocs SET xDoc.modify('
 delete 
 //section[@num="2"]')






