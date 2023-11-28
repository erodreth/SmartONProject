-- Database Creation
CREATE DATABASE ECommerce;

-- Customers Table
IF NOT EXISTS(SELECT 1 FROM sys.tables WHERE name = 'Customers') 
BEGIN
    CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    Email VARCHAR(100),
    Phone VARCHAR(20),
    Address VARCHAR(100)
);

-- Products table
CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    SupplierID INT,
    Category VARCHAR(50),
    UnitPrice DECIMAL(10, 2),
    Stock INT,
    FOREIGN KEY (SupplierID) REFERENCES Suppliers(SupplierID)
);

-- Suppliers Table
CREATE TABLE Suppliers (
    SupplierID INT PRIMARY KEY,
    SupplierName VARCHAR(100),
    ContactName VARCHAR(100),
    Address VARCHAR(100),
    Phone VARCHAR(20),
    Email VARCHAR(100)
);

-- Orders Table
CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE,
    ShipDate DATE,
    ShippingAddress VARCHAR(100),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- OrderDetails Table
CREATE TABLE OrderDetails (
    OrderDetailID INT PRIMARY KEY,
    OrderID INT,
    ProductID INT,
    Quantity INT,
    UnitPrice DECIMAL(10, 2),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- Add data
INSERT INTO Customers VALUES (1, 'John', 'Doe', 'johndoe@email.com', '123-456-7890', '123 Elm St');
INSERT INTO Customers VALUES (2, 'Jane', 'Smith', 'janesmith@email.com', '098-765-4321', '456 Maple Ave');

INSERT INTO Products VALUES (1, 'Laptop', 1, 'Electronics', 1200, 30);
INSERT INTO Products VALUES (2, 'T-Shirt', 2, 'Clothing', 20, 100);

INSERT INTO Suppliers VALUES (1, 'TechGoods Inc.', 'Alice Brown', '123 Tech Rd', '555-1234', 'alice@techgoods.com');
INSERT INTO Suppliers VALUES (2, 'FashionFiesta', 'Bob Clark', '456 Fashion Ave', '555-5678', 'bob@fashionfiesta.com');

INSERT INTO Orders VALUES (1, 1, '2023-11-01', '2023-11-03', '123 Elm St');
INSERT INTO Orders VALUES (2, 2, '2023-11-02', '2023-11-04', '456 Maple Ave');

INSERT INTO OrderDetails VALUES (1, 1, 1, 1, 1200);
INSERT INTO OrderDetails VALUES (2, 2, 2, 3, 20);

-- Bringing products that are out of stock
SELECT * FROM Products WHERE Stock < 10;

-- Bringing customers who have placed more than X orders in the last year
SELECT Customers.CustomerID, Customers.FirstName, Customers.LastName, COUNT(Orders.OrderID) AS PurchaseCount
FROM Customers
JOIN Orders ON Customers.CustomerID = Orders.CustomerID
WHERE OrderDate >= DATEADD(year, -1, GETDATE())
GROUP BY Customers.CustomerID, Customers.FirstName, Customers.LastName
HAVING COUNT(Orders.OrderID) > X;

-- Total sales report by product categories
SELECT Products.Category, SUM(OrderDetails.Quantity * OrderDetails.UnitPrice) AS TotalSales
FROM OrderDetails
JOIN Products ON OrderDetails.ProductID = Products.ProductID
GROUP BY Products.Category;

-- Update customer information
UPDATE Customers SET FirstName = 'NewFirstName', LastName = 'NewLastName' WHERE CustomerID = 1;

-- Applying a percentage discount to certain products
UPDATE Products SET UnitPrice = UnitPrice * (1 - DiscountPercentage) WHERE ProductID IN (1, 2, 3);

-- Securely delete the order and related details
DELETE FROM OrderDetails WHERE OrderID = 1;
DELETE FROM Orders WHERE OrderID = 1;

-- Remove discontinued products
DELETE FROM Products WHERE Discontinued = 1;

-- Top 5 selling products of the month
SELECT TOP 5 Products.ProductID, Products.ProductName, SUM(OrderDetails.Quantity) AS TotalQuantitySold
FROM OrderDetails
JOIN Products ON OrderDetails.ProductID = Products.ProductID
JOIN Orders ON OrderDetails.OrderID = Orders.OrderID
WHERE MONTH(Orders.OrderDate) = MONTH(GETDATE())
GROUP BY Products.ProductID, Products.ProductName
ORDER BY TotalQuantitySold DESC;

-- Total order amount of each customer
SELECT Customers.CustomerID, Customers.FirstName, Customers.LastName, SUM(OrderDetails.Quantity * OrderDetails.UnitPrice) AS TotalOrderSum
FROM Customers
JOIN Orders ON Customers.CustomerID = Orders.CustomerID
JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID
GROUP BY Customers.CustomerID, Customers.FirstName, Customers.LastName;

-- Number of sales of each product of the month not provided by a specific supplier
SELECT Products.ProductID, Products.ProductName, SUM(OrderDetails.Quantity) AS TotalQuantitySold
FROM OrderDetails
JOIN Products ON OrderDetails.ProductID = Products.ProductID
JOIN Orders ON OrderDetails.OrderID = Orders.OrderID
WHERE MONTH(Orders.OrderDate) = MONTH(GETDATE())
AND Products.SupplierID <> X
GROUP BY Products.ProductID, Products.ProductName;

-- Performance Optimization
CREATE INDEX idx_Customers_CustomerID ON Customers (CustomerID);
CREATE INDEX idx_Products_ProductName ON Products (ProductName);
END