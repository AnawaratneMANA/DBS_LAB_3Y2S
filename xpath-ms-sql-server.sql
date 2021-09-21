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

