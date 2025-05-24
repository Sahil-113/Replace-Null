-- 1. List of all customers

SELECT * FROM Sales.Customer;

-- 2. List of all customers where company name ends in 'N'

SELECT * FROM Sales.Customer WHERE CompanyName LIKE '%N';

-- 3. List of all customers who live in Berlin or London

SELECT * FROM Sales.vIndividualCustomer WHERE City IN ('Berlin', 'London');

-- 4. List of all customers who live in UK or USA

SELECT * FROM Sales.vIndividualCustomer WHERE CountryRegionCode IN ('UK', 'US');

-- 5. List of all products sorted by product name

SELECT * FROM Production.Product ORDER BY Name;

-- 6. List of all products where product name starts with 'A'

SELECT * FROM Production.Product WHERE Name LIKE 'A%';

-- 7. List of customers who ever placed an order

SELECT DISTINCT CustomerID FROM Sales.SalesOrderHeader;

--8. List of customers who live in London and have bought chai

SELECT DISTINCT c.CustomerID, c.CompanyName
FROM Sales.Customer c
JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
JOIN Production.Product p ON sod.ProductID = p.ProductID
JOIN Sales.vIndividualCustomer vic ON c.CustomerID = vic.CustomerID
WHERE vic.City = 'London' AND p.Name = 'Chai';

-- 9. List of customers who never placed an order

SELECT * FROM Sales.Customer WHERE CustomerID NOT IN (SELECT DISTINCT CustomerID FROM Sales.SalesOrderHeader);

-- 10. List of customers who ordered Tofu

SELECT DISTINCT c.CustomerID, c.CompanyName
FROM Sales.Customer c
JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
JOIN Production.Product p ON sod.ProductID = p.ProductID
WHERE p.Name = 'Tofu';

-- 11. Details of first order of the system

SELECT TOP 1 * FROM Sales.SalesOrderHeader ORDER BY OrderDate;

-- 12. Find the details of most expensive order date

SELECT TOP 1 soh.OrderDate, SUM(sod.LineTotal) AS Total
FROM Sales.SalesOrderHeader soh
JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
GROUP BY soh.OrderDate
ORDER BY Total DESC;

-- 13. For each order get the OrderID and Average quantity of items in that order

SELECT SalesOrderID, AVG(OrderQty) AS AvgQty FROM Sales.SalesOrderDetail GROUP BY SalesOrderID;

-- 14. For each order get the OrderID, minimum quantity and maximum quantity for that order

SELECT SalesOrderID, MIN(OrderQty) AS MinQty, MAX(OrderQty) AS MaxQty FROM Sales.SalesOrderDetail GROUP BY SalesOrderID;

-- 15. Get a list of all managers and total number of employees who report to them

SELECT ManagerID, COUNT(*) AS NumberOfReports FROM HumanResources.Employee WHERE ManagerID IS NOT NULL GROUP BY ManagerID;

-- 16. Get the OrderID and the total quantity for each order that has a total quantity greater than 300

SELECT SalesOrderID, SUM(OrderQty) AS TotalQty FROM Sales.SalesOrderDetail GROUP BY SalesOrderID HAVING SUM(OrderQty) > 300;

-- 17. List of all orders placed on or after 1996-12-31

SELECT * FROM Sales.SalesOrderHeader WHERE OrderDate >= '1996-12-31';

-- 18. List of all orders shipped to Canada

SELECT * FROM Sales.SalesOrderHeader WHERE ShipToAddressID IN (SELECT AddressID FROM Person.Address WHERE CountryRegionCode = 'CA');

-- 19. List of all orders with order total > 200

SELECT SalesOrderID, SUM(LineTotal) AS Total FROM Sales.SalesOrderDetail GROUP BY SalesOrderID HAVING SUM(LineTotal) > 200;

-- 20. List of countries and sales made in each country

SELECT a.CountryRegionCode, SUM(sod.LineTotal) AS TotalSales
FROM Sales.SalesOrderHeader soh
JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
JOIN Person.Address a ON soh.ShipToAddressID = a.AddressID
GROUP BY a.CountryRegionCode;

-- 21. List of Customer ContactName and number of orders they placed

SELECT c.CustomerID, p.FirstName + ' ' + p.LastName AS ContactName, COUNT(soh.SalesOrderID) AS NumberOfOrders
FROM Sales.Customer c
JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
GROUP BY c.CustomerID, p.FirstName, p.LastName;

-- 22. List of customer contact names who have placed more than 3 orders

SELECT p.FirstName + ' ' + p.LastName AS ContactName, COUNT(soh.SalesOrderID) AS OrdersCount
FROM Sales.Customer c
JOIN Sales.SalesOrderHeader soh ON c.CustomerID = soh.CustomerID
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
GROUP BY p.FirstName, p.LastName
HAVING COUNT(soh.SalesOrderID) > 3;

-- 23. List of discontinued products which were ordered between 1997-01-01 and 1998-01-01

SELECT DISTINCT p.Name
FROM Production.Product p
JOIN Sales.SalesOrderDetail sod ON p.ProductID = sod.ProductID
JOIN Sales.SalesOrderHeader soh ON sod.SalesOrderID = soh.SalesOrderID
WHERE p.SellEndDate IS NOT NULL AND soh.OrderDate BETWEEN '1997-01-01' AND '1998-01-01';

-- 24. List of employee FirstName, LastName, supervisor FirstName, LastName

SELECT e.BusinessEntityID, pe.FirstName, pe.LastName,
       m.BusinessEntityID AS ManagerID, pm.FirstName AS ManagerFirstName, pm.LastName AS ManagerLastName
FROM HumanResources.Employee e
JOIN HumanResources.Employee m ON e.ManagerID = m.BusinessEntityID
JOIN Person.Person pe ON e.BusinessEntityID = pe.BusinessEntityID
JOIN Person.Person pm ON m.BusinessEntityID = pm.BusinessEntityID;

-- 25. List of Employees id and total sale conducted by employee

SELECT SalesPersonID, SUM(TotalDue) AS TotalSales
FROM Sales.SalesOrderHeader
WHERE SalesPersonID IS NOT NULL
GROUP BY SalesPersonID;

-- 26. List of employees whose FirstName contains character a

SELECT * FROM Person.Person WHERE FirstName LIKE '%a%';

-- 27. List of managers who have more than four people reporting to them

SELECT ManagerID, COUNT(*) AS Reports
FROM HumanResources.Employee
WHERE ManagerID IS NOT NULL
GROUP BY ManagerID
HAVING COUNT(*) > 4;

-- 28. List of Orders and ProductNames

SELECT soh.SalesOrderID, p.Name
FROM Sales.SalesOrderHeader soh
JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
JOIN Production.Product p ON sod.ProductID = p.ProductID;

-- 29. List of orders place by the best customer

SELECT TOP 1 soh.CustomerID, COUNT(*) AS OrderCount
FROM Sales.SalesOrderHeader soh
GROUP BY soh.CustomerID
ORDER BY COUNT(*) DESC;

-- 30. List of orders placed by customers who do not have a Fax number

SELECT soh.*
FROM Sales.SalesOrderHeader soh
JOIN Sales.Customer c ON soh.CustomerID = c.CustomerID
JOIN Person.Person p ON c.PersonID = p.BusinessEntityID
LEFT JOIN Person.PersonPhone pp ON p.BusinessEntityID = pp.BusinessEntityID AND pp.PhoneNumberTypeID = 3
WHERE pp.PhoneNumber IS NULL;

-- 31. List of Postal codes where the product Tofu was shipped

SELECT DISTINCT a.PostalCode
FROM Sales.SalesOrderHeader soh
JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
JOIN Production.Product p ON sod.ProductID = p.ProductID
JOIN Person.Address a ON soh.ShipToAddressID = a.AddressID
WHERE p.Name = 'Tofu';

-- 32. List of Product Names that were shipped to France

SELECT DISTINCT p.Name
FROM Sales.SalesOrderHeader soh
JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
JOIN Production.Product p ON sod.ProductID = p.ProductID
JOIN Person.Address a ON soh.ShipToAddressID = a.AddressID
WHERE a.CountryRegionCode = 'FR';

-- 33. List of ProductNames and Categories for the supplier 'Specialty Biscuits, Ltd.'

SELECT p.Name, pc.Name AS Category
FROM Production.Product p
JOIN Production.ProductSubcategory psc ON p.ProductSubcategoryID = psc.ProductSubcategoryID
JOIN Production.ProductCategory pc ON psc.ProductCategoryID = pc.ProductCategoryID
JOIN Purchasing.ProductVendor pv ON p.ProductID = pv.ProductID
JOIN Purchasing.Vendor v ON pv.BusinessEntityID = v.BusinessEntityID
WHERE v.Name = 'Specialty Biscuits, Ltd.';

-- 34. List of products that were never ordered

SELECT * FROM Production.Product
WHERE ProductID NOT IN (SELECT DISTINCT ProductID FROM Sales.SalesOrderDetail);

-- 35. List of products where units in stock is less than 10 and units on order are 0

SELECT * FROM Production.Product WHERE SafetyStockLevel < 10 AND ReorderPoint = 0;

-- 36. List of top 10 countries by sales

SELECT TOP 10 a.CountryRegionCode, SUM(sod.LineTotal) AS Sales
FROM Sales.SalesOrderHeader soh
JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
JOIN Person.Address a ON soh.ShipToAddressID = a.AddressID
GROUP BY a.CountryRegionCode
ORDER BY Sales DESC;

-- 37. Number of orders each employee has taken for customers with CustomerIDs between A and AO

SELECT SalesPersonID, COUNT(*) AS OrdersCount
FROM Sales.SalesOrderHeader
WHERE CustomerID BETWEEN 1 AND 100 -- Replace with actual A and AO values if applicable
GROUP BY SalesPersonID;

-- 38. Order date of most expensive order

SELECT TOP 1 OrderDate
FROM Sales.SalesOrderHeader soh
JOIN Sales.SalesOrderDetail sod ON soh.SalesOrderID = sod.SalesOrderID
GROUP BY OrderDate
ORDER BY SUM(sod.LineTotal) DESC;

-- 39. Product name and total revenue from that product

SELECT p.Name, SUM(sod.LineTotal) AS Revenue
FROM Production.Product p
JOIN Sales.SalesOrderDetail sod ON p.ProductID = sod.ProductID
GROUP BY p.Name;

-- 40. Supplier and number of products offered

SELECT v.Name AS Supplier, COUNT(pv.ProductID) AS ProductsOffered
FROM Purchasing.ProductVendor pv
JOIN Purchasing.Vendor v ON pv.BusinessEntityID = v.BusinessEntityID
GROUP BY v.Name;

--41. Top ten customers based on their business

SELECT TOP 10 CustomerID, SUM(TotalDue) AS TotalSpent
FROM Sales.SalesOrderHeader
GROUP BY CustomerID
ORDER BY TotalSpent DESC;

--42. What is the total revenue of the company

SELECT SUM(TotalDue) AS TotalRevenue FROM Sales.SalesOrderHeader;

