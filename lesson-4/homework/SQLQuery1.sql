CREATE DATABASE CLASS4;
USE CLASS4

--TASK1
CREATE TABLE [dbo].[TestMultipleZero]
(
    [A] [int] NULL,
    [B] [int] NULL,
    [C] [int] NULL,
    [D] [int] NULL
);
GO

INSERT INTO [dbo].[TestMultipleZero](A,B,C,D)
VALUES 
    (0,0,0,1),
    (0,0,1,0),
    (0,1,0,0),
    (1,0,0,0),
    (0,0,0,0),
    (1,1,1,0);

SELECT * FROM [dbo].[TestMultipleZero]
WHERE NOT (A = 0 AND B = 0 AND C = 0 AND D = 0);


--TASK2
CREATE TABLE TestMax
(
    Year1 INT,
    Max1 INT,
    Max2 INT,
    Max3 INT
);
GO

INSERT INTO TestMax 
VALUES
    (2001,10,101,87),
    (2002,103,19,88),
    (2003,21,23,89),
    (2004,27,28,91);


SELECT 
    Year1,
    (SELECT MAX(val) 
     FROM (VALUES (Max1), (Max2), (Max3)) AS value_table(val)) AS MaxValue
FROM TestMax;



--TASK 3
CREATE TABLE EmpBirth
(
    EmpId INT IDENTITY(1,1),
    EmpName VARCHAR(50),
    BirthDate DATETIME
);

INSERT INTO EmpBirth(EmpName,BirthDate)
SELECT 'Pawan' , '1983-04-12'
UNION ALL
SELECT 'Zuzu' , '1986-11-28'
UNION ALL
SELECT 'Parveen', '1977-05-07'
UNION ALL
SELECT 'Mahesh', '1983-01-13'
UNION ALL
SELECT 'Ramesh', '1983-05-09';


SELECT * FROM EmpBirth
WHERE MONTH(BirthDate) = 5 AND DAY(BirthDate) BETWEEN 7 AND 15;



--TASK4
CREATE TABLE letters
(
    letter CHAR(1)
);
INSERT INTO letters(letter)
VALUES 
    ('a'), ('a'), ('a'), 
    ('b'), ('c'), ('d'), 
    ('e'), ('f');


SELECT * FROM letters
ORDER BY CASE WHEN letter = 'b' THEN 0 ELSE 1 END, letter;

SELECT * FROM (
    SELECT letter, 
           CASE 
               WHEN letter = 'a' THEN 1
               WHEN letter = 'c' THEN 2
               WHEN letter = 'b' THEN 3
               WHEN letter = 'd' THEN 4
               WHEN letter = 'e' THEN 5
               WHEN letter = 'f' THEN 6
           END AS sort_order
    FROM letters
) AS ordered_letters
ORDER BY sort_order;
