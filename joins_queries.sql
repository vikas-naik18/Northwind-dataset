CREATE DATABASE northwind_db;
USE northwind_db;
-- Customers
DROP TABLE customers;
CREATE TABLE customers (
    CustomerID VARCHAR(10) PRIMARY KEY,
    CompanyName TEXT,
    ContactName TEXT,
    ContactTitle TEXT,
    Address TEXT,
    City TEXT,
    Region TEXT,
    PostalCode TEXT,
    Country TEXT,
    Phone TEXT,
    Fax TEXT
);

-- Orders
CREATE TABLE orders (
    OrderID INT PRIMARY KEY,
    CustomerID VARCHAR(10),
    EmployeeID INT,
    OrderDate DATE,
    RequiredDate DATE,
    ShippedDate DATE,
    ShipVia INT,
    Freight NUMERIC,
    ShipName TEXT,
    ShipAddress TEXT,
    ShipCity TEXT,
    ShipRegion TEXT,
    ShipPostalCode TEXT,
    ShipCountry TEXT,
    FOREIGN KEY (CustomerID) REFERENCES customers(CustomerID)
);

-- Products
CREATE TABLE products (
    ProductID INT PRIMARY KEY,
    ProductName TEXT,
    SupplierID INT,
    CategoryID INT,
    QuantityPerUnit TEXT,
    UnitPrice NUMERIC,
    UnitsInStock INT,
    UnitsOnOrder INT,
    ReorderLevel INT,
    Discontinued INT
);

-- Categories
DROP TABLE categories;
CREATE TABLE categories (
    CategoryID INT PRIMARY KEY,
    CategoryName TEXT,
    Description TEXT
);

-- Order Details
CREATE TABLE order_details (
    OrderID INT,
    ProductID INT,
    UnitPrice NUMERIC,
    Quantity INT,
    Discount NUMERIC,
    PRIMARY KEY (OrderID, ProductID),
    FOREIGN KEY (OrderID) REFERENCES orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES products(ProductID)
);
SELECT COUNT(*) FROM categories;
SELECT COUNT(*) FROM customers;
SELECT COUNT(*) FROM products;
SELECT COUNT(*) FROM orders;
SELECT COUNT(*) FROM order_details;

SELECT 
    o.OrderID,
    c.CompanyName,
    o.OrderDate
FROM orders o
INNER JOIN customers c
ON o.CustomerID = c.CustomerID;

SELECT 
    c.CustomerID,
    c.CompanyName,
    c.Country
FROM customers c
LEFT JOIN orders o
ON c.CustomerID = o.CustomerID
WHERE o.OrderID IS NULL;

SELECT 
    p.ProductID,
    p.ProductName,
    ROUND(SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)), 2) AS total_revenue
FROM order_details od
INNER JOIN products p
ON od.ProductID = p.ProductID
GROUP BY p.ProductID, p.ProductName
ORDER BY total_revenue DESC;

SELECT 
    c.CategoryName,
    ROUND(SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)), 2) AS category_revenue
FROM order_details od
INNER JOIN products p ON od.ProductID = p.ProductID
INNER JOIN categories c ON p.CategoryID = c.CategoryID
GROUP BY c.CategoryName
ORDER BY category_revenue DESC;

SELECT 
    o.OrderID,
    o.OrderDate,
    c.CompanyName,
    c.Country,
    ROUND(SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)), 2) AS order_value
FROM orders o
INNER JOIN customers c ON o.CustomerID = c.CustomerID
INNER JOIN order_details od ON o.OrderID = od.OrderID
WHERE c.Country = 'USA'
  AND o.OrderDate BETWEEN '1997-01-01' AND '1997-12-31'
GROUP BY o.OrderID, o.OrderDate, c.CompanyName, c.Country
ORDER BY order_value DESC;

SELECT 
    c.CompanyName,
    o.OrderID,
    o.OrderDate,
    ROUND(SUM(od.UnitPrice * od.Quantity * (1 - od.Discount)), 2) AS total_amount
FROM orders o
JOIN customers c ON o.CustomerID = c.CustomerID
JOIN order_details od ON o.OrderID = od.OrderID
GROUP BY c.CompanyName, o.OrderID, o.OrderDate
INTO OUTFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/joined_output_v2.csv'
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n';
