Create database class5;

CREATE TABLE Employees (
    EmployeeID INT PRIMARY KEY,
    Name VARCHAR(50),
    Department VARCHAR(50),
    Salary DECIMAL(10,2),
    HireDate DATE
);


INSERT INTO Employees (EmployeeID, Name, Department, Salary, HireDate) VALUES
(1, 'Alice', 'HR', 5000, '2022-01-01'),
(2, 'Bob', 'IT', 6000, '2022-03-01'),
(3, 'Charlie', 'IT', 6000, '2022-04-01'),
(4, 'Diana', 'HR', 4500, '2022-05-01'),
(5, 'Eve', 'Finance', 7000, '2022-02-01'),
(6, 'Frank', 'Finance', 7000, '2022-06-01'),
(7, 'Grace', 'IT', 5500, '2022-07-01'),
(8, 'Heidi', 'HR', 5200, '2022-08-01');


SELECT 
    EmployeeID, Name, Salary,
    RANK() OVER (ORDER BY Salary DESC) AS SalaryRank
FROM Employees;


SELECT 
    EmployeeID, Name, Salary,
    DENSE_RANK() OVER (ORDER BY Salary DESC) AS SalaryRank,
    COUNT(*) OVER (PARTITION BY Salary) AS CountWithSameSalary
FROM Employees;

WITH RankedSalaries AS (
    SELECT *,
           DENSE_RANK() OVER (PARTITION BY Department ORDER BY Salary DESC) AS DeptSalaryRank
    FROM Employees
)
SELECT * 
FROM RankedSalaries
WHERE DeptSalaryRank <= 2;


WITH RankedLowest AS (
    SELECT *,
           RANK() OVER (PARTITION BY Department ORDER BY Salary ASC) AS SalaryRank
    FROM Employees
)
SELECT * 
FROM RankedLowest
WHERE SalaryRank = 1;

SELECT *,
    SUM(Salary) OVER (PARTITION BY Department ORDER BY HireDate ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS RunningTotal
FROM Employees;


SELECT *,
    SUM(Salary) OVER (PARTITION BY Department) AS DeptTotalSalary
FROM Employees;


SELECT *,
    AVG(Salary) OVER (PARTITION BY Department) AS DeptAvgSalary
FROM Employees;

SELECT *,
    Salary - AVG(Salary) OVER (PARTITION BY Department) AS DiffFromDeptAvg
FROM Employees;

SELECT *,
    AVG(Salary) OVER (ORDER BY HireDate ROWS BETWEEN 1 PRECEDING AND 1 FOLLOWING) AS MovingAvg3
FROM Employees;


SELECT SUM(Salary) AS TotalLast3
FROM (
    SELECT TOP 3 Salary
    FROM Employees
    ORDER BY HireDate DESC
) AS Last3Employees;


SELECT *,
    AVG(Salary) OVER (ORDER BY HireDate ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS RunningAvg
FROM Employees;
r
--------------------------------------------------
SELECT *,
    MAX(Salary) OVER (ORDER BY HireDate ROWS BETWEEN 2 PRECEDING AND 2 FOLLOWING) AS MaxSlidingWindow
FROM Employees;

SELECT *,
    ROUND(Salary * 100.0 / SUM(Salary) OVER (PARTITION BY Department), 2) AS PercentContribution
FROM Employees;
