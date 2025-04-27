/*1. DELETE vs TRUNCATE vs DROP (with IDENTITY example)
Create a table test_identity with an IDENTITY(1,1) column and insert 5 rows.
Use DELETE, TRUNCATE, and DROP one by one (in different test cases) and observe how they behave.
Answer the following questions:
What happens to the identity column when you use DELETE?
What happens to the identity column when you use TRUNCATE?
What happens to the table when you use DROP?*/


CREATE TABLE test_identity (
    id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(50)
);

INSERT INTO test_identity (name) VALUES 
('mosh'), ('Bob'), ('Charlie'), ('josh'), ('Ethan');



Delete test_identity;
Truncate test_identity;
Drop test_identity;

SELECT * FROM test_identity;
-- drop will delate the table fully
--Delete and Truncate will delete its elements but the table will still be there


/*2. Common Data Types
Create a table data_types_demo with columns covering at least one example of each data type covered in class.
Insert values into the table.
Retrieve and display the values.
*/
create table data_types_demo(
   id INT PRIMARY KEY,
    name NVARCHAR(100),
    created_at DATETIME,
    profile_picture VARBINARY(MAX)
	);
INSERT INTO data_types_demo(id, name, created_at, profile_picture)
select  1,'Josh', GETDATE(),NUll;

Select * FROM data_types_demo;


/*3. Inserting and Retrieving an Image
Create a photos table with an id column and a varbinary(max) column.
Insert an image into the table using OPENROWSET.
Write a Python script to retrieve the image and save it as a file.
*/

CREATE TABLE photo (
    id INT IDENTITY(1,1) PRIMARY KEY,
    photo VARBINARY(MAX)
);

INSERT INTO photo(photo)
SELECT BulkColumn
FROM OPENROWSET(
    BULK 'D:\warrior\Desktop\apple.png',
    SINGLE_BLOB
) AS img;
select * from photo;
/*4. Computed Columns
Create a student table with a computed column total_tuition as classes * tuition_per_class.
Insert 3 sample rows.
Retrieve all data and check if the computed column works correctly.*/
CREATE TABLE student(
    id INT PRIMARY KEY,
    classes INT,
    tuition_per_class DECIMAL(10,2),
    total_tuition AS (classes * tuition_per_class) 
);


INSERT INTO student(id, classes, tuition_per_class)
SELECT 1, 5, 1000
UNION ALL
SELECT 2, 3, 1200
UNION ALL
SELECT 3, 4, 950;


SELECT * FROM student;

/*5. CSV to SQL Server
Download or create a CSV file with at least 5 rows of worker data (id, name).
Use BULK INSERT to import the CSV file into the worker table.
Verify the imported data.*/

CREATE TABLE worker(
id INT,
name varchar(100)
);

BULK insert worker
FROM 'D:\warrior\Desktop\sample.csv'
WITH(
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '\n',
   FIRSTROW = 1
 );
 select * from worker




