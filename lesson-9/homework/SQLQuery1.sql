
CREATE DATABASE CLASS8;
GO
USE CLASS8;
GO

--task 1
DROP TABLE IF EXISTS Employees;

CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    ManagerID INT NULL,
    JobTitle VARCHAR(100) NOT NULL
);

INSERT INTO Employees (EmployeeID, ManagerID, JobTitle) 
VALUES
    (1001, NULL, 'President'),
    (2002, 1001, 'Director'),
    (3003, 1001, 'Office Manager'),
    (4004, 2002, 'Engineer'),
    (5005, 2002, 'Engineer'),
    (6006, 2002, 'Engineer');


WITH depth_lvl AS (
    SELECT 
        EmployeeID, ManagerID, JobTitle, 0 AS Depth
    FROM Employees
    WHERE ManagerID IS NULL

    UNION ALL

    SELECT 
        e.EmployeeID,
        e.ManagerID,
        e.JobTitle,
        h.Depth + 1
    FROM Employees AS e
    JOIN depth_lvl AS h ON e.ManagerID = h.EmployeeID
)
SELECT * 
FROM depth_lvl
ORDER BY Depth, EmployeeID;






--task2

DECLARE @N INT = 10;
WITH Factorial_table as (
    SELECT 1 as Num, 1 as Factorial
    UNION ALL
    SELECT Num + 1, Factorial * (Num + 1)
    FROM Factorial_table
    WHERE Num < @N
)
SELECT * FROM Factorial_table


--task 3
DECLARE @f INT = 10;
WITH Fibonacci AS (
    SELECT 1 AS n, 1 AS fib_current, 0 AS fib_previous
    UNION ALL
    SELECT n + 1,
           fib_current + fib_previous,
           fib_current
    FROM Fibonacci
    WHERE n < @f
)
SELECT n, fib_current AS Fibonacci_Number
FROM Fibonacci



