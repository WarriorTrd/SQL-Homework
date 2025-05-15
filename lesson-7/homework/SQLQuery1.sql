
CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100)
);

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT FOREIGN KEY REFERENCES Customers(CustomerID),
    OrderDate DATE
);

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50)
);

CREATE TABLE OrderDetails (
    OrderDetailID INT PRIMARY KEY,
    OrderID INT FOREIGN KEY REFERENCES Orders(OrderID),
    ProductID INT FOREIGN KEY REFERENCES Products(ProductID),
    Quantity INT,
    Price DECIMAL(10,2)
);


INSERT INTO Customers VALUES 
(1, 'Alice'), 
(2, 'Bob'), 
(3, 'Charlie');

INSERT INTO Orders VALUES 
(101, 1, '2024-01-01'), 
(102, 1, '2024-02-15'),
(103, 2, '2024-03-10'), 
(104, 2, '2024-04-20');

INSERT INTO Products VALUES 
(1, 'Laptop', 'Electronics'), 
(2, 'Mouse', 'Electronics'),
(3, 'Book', 'Stationery');

INSERT INTO OrderDetails VALUES 
(1, 101, 1, 2, 10.00), 
(2, 101, 2, 1, 20.00),
(3, 102, 1, 3, 10.00), 
(4, 103, 3, 5, 15.00),
(5, 104, 1, 1, 10.00), 
(6, 104, 2, 2, 20.00);

SELECT 
    c.CustomerID,
    c.CustomerName,
    o.OrderID,
    o.OrderDate
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID;


SELECT 
    c.CustomerID,
    c.CustomerName
FROM Customers c
LEFT JOIN Orders o ON c.CustomerID = o.CustomerID
WHERE o.OrderID IS NULL;


SELECT 
    o.OrderID,
    p.ProductName,
    od.Quantity
FROM Orders o
JOIN OrderDetails od ON o.OrderID = od.OrderID
JOIN Products p ON od.ProductID = p.ProductID;


SELECT 
    c.CustomerID,
    c.CustomerName,
    COUNT(o.OrderID) AS OrderCount
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.CustomerID, c.CustomerName
HAVING COUNT(o.OrderID) > 1;


SELECT 
    od.OrderID,
    p.ProductName,
    od.Price
FROM OrderDetails od
JOIN Products p ON od.ProductID = p.ProductID
WHERE od.Price = (
    SELECT MAX(od2.Price)
    FROM OrderDetails od2
    WHERE od2.OrderID = od.OrderID
);


SELECT 
    o.CustomerID,
    c.CustomerName,
    o.OrderID,
    o.OrderDate
FROM Orders o
JOIN Customers c ON o.CustomerID = c.CustomerID
WHERE o.OrderDate = (
    SELECT MAX(o2.OrderDate)
    FROM Orders o2
    WHERE o2.CustomerID = o.CustomerID
);


SELECT DISTINCT c.CustomerID, c.CustomerName
FROM Customers c
FROM Orders o
JOIN OrderDetails od ON o.OrderID = od.OrderID
JOIN Products p ON od.ProductID = p.ProductID
WHERE o.CustomerID = c.CustomerID
  AND p.Category <> 'Electronics'
)
AND EXISTS (
    SELECT 1
    FROM Orders o
    JOIN OrderDetails od ON o.OrderID = od.OrderID
    JOIN Products p ON od.ProductID = p.ProductID
    WHERE o.CustomerID = c.CustomerID
     
);


SELECT DISTINCT c.CustomerID, c.CustomerName
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN OrderDetails od ON o.OrderID = od.OrderID
JOIN Products p ON od.ProductID = p.ProductID
WHERE p.Category = 'Stationery';


SELECT 
    c.CustomerID,
    c.CustomerName,
    SUM(od.Quantity * od.Price) AS TotalSpent
FROM Customers c
JOIN Orders o ON c.CustomerID = o.CustomerID
JOIN OrderDetails od ON o.OrderID = od.OrderID
GROUP BY c.CustomerID, c.CustomerName;
