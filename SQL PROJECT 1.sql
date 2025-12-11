CREATE DATABASE SQLProject;

USE SQLProject;

-- Customer Table

CREATE TABLE Customers (
    CustomerID INT PRIMARY KEY,
    CustomerName VARCHAR(100),
    City VARCHAR(50),
    Age INT
);

INSERT INTO Customers (CustomerID, CustomerName, City, Age) VALUES
(1, 'Amit Sharma', 'Pune', 34),
(2, 'Neha Joshi', 'Mumbai', 27),
(3, 'Rohan Patil', 'Delhi', 42),
(4, 'Priya Singh', 'Hyderabad', 32),
(5, 'Kunal Mehta', 'Bengaluru', 29),
(6, 'Anita Rao', 'Chennai', 39),
(7, 'Vikas Jain', 'Kolkata', 51),
(8, 'Suman Gupta', 'Ahmedabad', 28),
(9, 'Rajveer Khanna', 'Pune', 44),
(10, 'Swati Deshmukh', 'Jaipur', 36);



-- Products Table

CREATE TABLE Products (
    ProductID INT PRIMARY KEY,
    ProductName VARCHAR(100),
    Category VARCHAR(50),
    Price DECIMAL(10,2)
);

INSERT INTO Products (ProductID, ProductName, Category, Price) VALUES
(101, 'HP Pavilion Laptop', 'Electronics', 58000),
(102, 'Steel Water Bottle', 'Kitchen', 450),
(103, 'Office Chair Leather', 'Furniture', 7200),
(104, 'Logitech Keyboard', 'Electronics', 1990),
(105, 'Yoga Mat Premium', 'Fitness', 1250),
(106, 'LED Monitor 24in', 'Electronics', 9100),
(107, 'Reading Lamp', 'Home Decor', 1590),
(108, 'Noise Cancelling Headphones', 'Electronics', 6500),
(109, 'Plant Pot Ceramic', 'Home Decor', 450),
(110, 'Novel: Time Traveler', 'Books', 399);

-- Orders Table

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    CustomerID INT,
    OrderDate DATE,
    StoreCity VARCHAR(50)
);

INSERT INTO Orders (OrderID, CustomerID, OrderDate, StoreCity) VALUES
(5001, 1, '2025-01-04', 'Pune'),
(5002, 4, '2025-02-10', 'Mumbai'),
(5003, 8, '2025-02-14', 'Delhi'),
(5004, 2, '2025-03-09', 'Bengaluru'),
(5005, 9, '2025-03-22', 'Hyderabad'),
(5006, 3, '2025-04-02', 'Mumbai'),
(5007, 5, '2025-04-11', 'Chennai'),
(5008, 6, '2025-04-28', 'Pune'),
(5009, 7, '2025-05-17', 'Delhi'),
(5010, 10, '2025-05-22', 'Mumbai');


-- OrderItems

CREATE TABLE OrderItems (
    ItemID INT PRIMARY KEY,
    OrderID INT,
    ProductID INT,
    Quantity INT
);

INSERT INTO OrderItems VALUES
(1, 5001, 101, 1),
(2, 5001, 102, 2),
(3, 5002, 103, 1),
(4, 5003, 104, 3),
(5, 5004, 101, 1),
(6, 5004, 105, 2),
(7, 5005, 102, 1),
(8, 5006, 105, 1),
(9, 5008, 106, 3),
(10, 5010, 103, 1);

    SELECT* FROM Orders;
    SELECT* FROM Customers;
    SELECT* FROM Products;
    SELECT* FROM OrderItems;

-- 1. Get all customer names along with their order IDs and order dates.

    SELECT customername ,orderid,orderdate 
    from Customers AS C INNER JOIN ORDERS AS O
    ON C.CUSTOMERID = O.CustomerID;

-- 2.List ProductName, its OrderID, and Quantity purchased.

    SELECT PRODUCTNAME,ORDERID, QUANTITY 
    FROM Products AS P INNER JOIN OrderItems AS OI
    ON P.PRODUCTID=OI.ProductID;


-- 3. Show CustomerName, ProductName, Quantity, and OrderDate for all orders.

   SELECT C.CustomerName,P.ProductName,OI.Quantity,O.OrderDate 
   FROM Customers AS C INNER JOIN ORDERS  AS O
   ON C.CustomerID=O.CustomerID
   INNER JOIN OrderItems AS OI
   ON OI.ORDERID =O.OrderID
   INNER JOIN Products AS P 
   ON P.ProductID=OI.ProductID ;
	
-- 4. Display orders with total value (price multiplied by quantity).

    SELECT O.OrderID,SUM(P.PRICE * OI.QUANTITY) AS TOTAL_VALUE 
	FROM Orders AS O INNER JOIN OrderItems AS OI
	ON O.OrderID= OI.OrderID
	INNER JOIN Products AS P
	ON OI.ProductID=P.ProductID
	GROUP BY  O.OrderID;
	 
-- 5. Find total spending by each customer.

    SELECT CustomerName,O.OrderID,SUM(P.PRICE * OI.QUANTITY) AS TOTAL_VALUE 
	FROM Orders AS O INNER JOIN OrderItems AS OI
	ON O.OrderID= OI.OrderID
	INNER JOIN Products AS P
	ON OI.ProductID=P.ProductID
	INNER JOIN Customers AS C 
	ON C.CustomerID= O.CustomerID
	GROUP BY  O.OrderID,CustomerName;

-- 6. List customers who spent more than 40000.

    SELECT CustomerName,O.OrderID,SUM(P.PRICE * OI.QUANTITY) AS TOTAL_VALUE 
	FROM Orders AS O INNER JOIN OrderItems AS OI
	ON O.OrderID= OI.OrderID
	INNER JOIN Products AS P
	ON OI.ProductID=P.ProductID
	INNER JOIN Customers AS C 
	ON C.CustomerID= O.CustomerID
	GROUP BY  O.OrderID,CustomerName
	HAVING SUM(P.PRICE * OI.QUANTITY)>40000;
   
-- 7. Show product-wise total revenue, but only products earning above 10000.

    SELECT p.ProductID,p.productname,sum(p.price*oi.quantity)as TotalRevenue 
	FROM Products AS p inner join OrderItems AS oi 
	ON p.ProductID=oi.ProductID
	GROUP BY p.ProductName,p.ProductID
	HAVING sum(p.price*oi.quantity)>10000;

-- 8. Create a view showing CustomerName, ProductName, Quantity, and Price.

    CREATE VIEW VW_CUSTOMERDETAIL AS 
	SELECT C.CustomerName,P.PRODUCTNAME,OI.QUANTITY,p.price from 
	Customers AS C INNER JOIN Orders AS O 
	ON C.CustomerID=O.CustomerID
	INNER JOIN OrderItems  AS OI
	ON OI.OrderID= O.OrderID
	INNER JOIN Products AS P
	ON P. ProductID= OI.ProductID;
	SELECT * FROM VW_CUSTOMERDETAIL ;

-- 9. Create a view that shows city-wise total revenue.

   create view vw_city_wise_rev as
   SELECT O.StoreCity,SUM(P. price*oi.quantity) as totalrevenue
   FROM Customers as c inner join Orders as o
   ON c.CustomerID= o.customerid 
   inner join OrderItems as oi 
   ON oi.OrderID= o.OrderID
   inner join Products as p 
   ON p.ProductID= oi.ProductID
   GROUP BY O.StoreCity;

   SELECT * FROM vw_city_wise_rev;
   SELECT * FROM Products;

-- 10. Find customers who have ordered electronics products.

    SELECT p.productname, p.CATEGORY,c.customername 
    FROM Customers as c inner join Orders as o 
    ON c.CustomerID = o.CustomerID
    inner join OrderItems as oi
    ON oi.OrderID= o.OrderID
    inner join Products as p
    ON p. ProductID = oi.ProductID
    WHERE Category= 'ELECTRONICS'
    GROUP BY Category,PRODUCTNAME,CustomerName;


-- 11.List products that have never been ordered.

    SELECT *FROM Products
	WHERE ProductID NOT IN (
	SELECT ProductID FROM OrderItems);

-- 12. Find top 2 revenue generating cities.

    --USING VIEW --
	SELECT TOP 2 *FROM vw_city_wise_rev
	ORDER BY totalrevenue DESC;

	--USING FULL STEP --
	SELECT TOP 2 O.StoreCity, SUM(P.PRICE* OI.QUANTITY) AS TOTALREVENUE
	FROM Customers AS C INNER JOIN ORDERS AS O
	ON C.CustomerID= O.CustomerID
	INNER JOIN OrderItems AS OI 
	ON O.OrderID= OI. OrderID
	INNER JOIN Products AS P 
	ON P.ProductID= OI.ProductID
	GROUP BY O.StoreCity
	ORDER BY TOTALREVENUE DESC;