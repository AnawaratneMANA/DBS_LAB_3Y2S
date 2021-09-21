/* Untype and Type XML Example in Create Table */
/* Untype Example */
CREATE TABLE AdminDocs (
    id int PRIMARY KEY,
    xDoc XML NOT NULL
)

CREATE TABLE AdminDocs (
    id int PRIMARY KEY,
    xDoc XML (CONTENT myCollection)
)

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

/* Inserting a Untype XML example */
INSERT INTO AdminDocs VALUES (2,
'<doc id="123">
    <sections>
        <section num="1"><title>XML Schema</title></section>
        <section num="3"><title>Benefits</title></section>
        <section num="4"><title>Features</title></section>
    </sections>
</doc>')