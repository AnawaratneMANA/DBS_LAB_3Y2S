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
SELECT id, xDoc.query('/*/child::product[attribute::dept="WMN"]') 
FROM AdminDocs




