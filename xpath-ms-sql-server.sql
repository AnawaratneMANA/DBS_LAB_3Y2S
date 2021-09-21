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