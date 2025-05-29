create database class11;
go 
use class11
go



-- ==============================================================
--                          Puzzle 1 DDL                         
-- ==============================================================

CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    Name VARCHAR(50),
    Department VARCHAR(50),
    Salary DECIMAL(10,2)
);

INSERT INTO Employees (EmployeeID, Name, Department, Salary)
VALUES
    (1, 'Alice', 'HR', 5000),
    (2, 'Bob', 'IT', 7000),
    (3, 'Charlie', 'Sales', 6000),
    (4, 'David', 'HR', 5500),
    (5, 'Emma', 'IT', 7200);


-- ==============================================================
--                          Puzzle 2 DDL
-- ==============================================================

CREATE TABLE Orders_DB1 (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(50),
    Product VARCHAR(50),
    Quantity INT
);

INSERT INTO Orders_DB1 VALUES
(101, 'Alice', 'Laptop', 1),
(102, 'Bob', 'Phone', 2),
(103, 'Charlie', 'Tablet', 1),
(104, 'David', 'Monitor', 1);

CREATE TABLE Orders_DB2 (
    OrderID INT PRIMARY KEY,
    CustomerName VARCHAR(50),
    Product VARCHAR(50),
    Quantity INT
);

INSERT INTO Orders_DB2 VALUES
(101, 'Alice', 'Laptop', 1),
(103, 'Charlie', 'Tablet', 1);


-- ==============================================================
--                          Puzzle 3 DDL
-- ==============================================================

CREATE TABLE WorkLog (
    EmployeeID INT,
    EmployeeName VARCHAR(50),
    Department VARCHAR(50),
    WorkDate DATE,
    HoursWorked INT
);

INSERT INTO WorkLog VALUES
(1, 'Alice', 'HR', '2024-03-01', 8),
(2, 'Bob', 'IT', '2024-03-01', 9),
(3, 'Charlie', 'Sales', '2024-03-02', 7),
(1, 'Alice', 'HR', '2024-03-03', 6),
(2, 'Bob', 'IT', '2024-03-03', 8),
(3, 'Charlie', 'Sales', '2024-03-04', 9);

CREATE TABLE #EmployeeTransfers (
    EmployeeID INT,
    Name VARCHAR(50),
    Department VARCHAR(50),
    Salary INT
);


INSERT INTO #EmployeeTransfers (EmployeeID, Name, Department, Salary)
SELECT 
    EmployeeID,
    Name,
    CASE 
        WHEN Department = 'HR' THEN 'IT'
        WHEN Department = 'IT' THEN 'Sales'
        WHEN Department = 'Sales' THEN 'HR'
        ELSE Department
    END AS Department,
    Salary
FROM Employees;


SELECT * FROM #EmployeeTransfers;





--task 2

DECLARE @MissingOrders TABLE (
    OrderID INT,
    CustomerName VARCHAR(100),
    Product VARCHAR(100),
    Quantity INT
);

INSERT INTO @MissingOrders (OrderID, CustomerName, Product, Quantity)
SELECT o1.OrderID, o1.CustomerName, o1.Product, o1.Quantity
FROM Orders_DB1 o1
LEFT JOIN Orders_DB2 o2 ON o1.OrderID = o2.OrderID
WHERE o2.OrderID IS NULL;


SELECT * FROM @MissingOrders;



--task 3

CREATE VIEW vw_MonthlyWorkSummary AS
SELECT
    w.EmployeeID,
    w.EmployeeName,
    w.Department,
    SUM(w.HoursWorked) AS TotalHoursWorked,
    d.TotalHoursDepartment,
    d.AvgHoursDepartment
FROM WorkLog w
JOIN (
    SELECT
        Department,
        SUM(HoursWorked) AS TotalHoursDepartment,
        AVG(CAST(HoursWorked AS FLOAT)) AS AvgHoursDepartment
    FROM WorkLog
    GROUP BY Department
) d ON w.Department = d.Department
GROUP BY w.EmployeeID, w.EmployeeName, w.Department, d.TotalHoursDepartment, d.AvgHoursDepartment;



SELECT * FROM vw_MonthlyWorkSummary;


