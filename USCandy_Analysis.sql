-- Create Database
CREATE DATABASE candydistDB;
GO

USE candydistDB;
GO

-- Table: Candy_Factories
CREATE TABLE Candy_Factories (
    Factory VARCHAR(100) PRIMARY KEY,
    Latitude DECIMAL(9, 6),
    Longitude DECIMAL(9, 6)
);

-- Table: Candy_Products
CREATE TABLE Candy_Products (
    Division VARCHAR(50),
    Product_Name VARCHAR(50),
    Factory VARCHAR(100),
    Product_ID VARCHAR(50) PRIMARY KEY,
    Unit_Price DECIMAL(10, 2),
    Unit_Cost DECIMAL(10, 2),
    CONSTRAINT FK_Products_Division FOREIGN KEY (Division) REFERENCES Candy_Targets (Division),
    CONSTRAINT FK_Products_Factory FOREIGN KEY (Factory) REFERENCES Candy_Factories (Factory)
);

-- Table: Candy_Sales
CREATE TABLE Candy_Sales (
    Row_ID INT PRIMARY KEY,
    Order_ID VARCHAR(50),
    Order_Date DATE,
    Ship_Date DATE,
    Ship_Mode VARCHAR(50),
    Customer_ID BIGINT,
    Country_Region VARCHAR(100),
    City VARCHAR(100),
    State_Province VARCHAR(100),
    Postal_Code VARCHAR(20),
    Division VARCHAR(50),
    Region VARCHAR(50),
    Product_ID VARCHAR(50),
    Product_Name VARCHAR(255),
    Sales DECIMAL(15, 2),
    Units INT,
    Gross_Profit DECIMAL(15, 2),
    Cost DECIMAL(15, 2),
    CONSTRAINT FK_Sales_Product_ID FOREIGN KEY (Product_ID) REFERENCES Candy_Products (Product_ID)
);

-- Table: Candy_Targets
CREATE TABLE Candy_Targets (
    Division VARCHAR(50) PRIMARY KEY,
    Target SMALLINT
);

-- Table: US_zips
CREATE TABLE US_zips (
    zip VARCHAR(20) PRIMARY KEY,
    lat DECIMAL(18, 10),
    lng DECIMAL(18, 10),
    city VARCHAR(50),
    state_id VARCHAR(50),
    state_name VARCHAR(50),
    zcta VARCHAR(50),
    parent_zcta VARCHAR(1),
    population INT,
    density DECIMAL(10, 2),
    county_fips INT,
    county_name VARCHAR(50),
    county_weights VARCHAR(100),
    county_names_all VARCHAR(100),
    county_fips_all VARCHAR(50),
    imprecise VARCHAR(50),
    military VARCHAR(50),
    timezone VARCHAR(50)
);

--Query Analysis

--1. Retrieve All Products from a Specific Factory  
SELECT Product_Name, Unit_Price, Unit_Cost
FROM Candy_Products
WHERE Factory = 'Secret Factory';
--Retrieves product name, price, and cost for products made in the "Secret Factory."
    
--2. Calculate Product Margins    
SELECT  Product_Name,
(Unit_Price - Unit_Cost) AS Margin
FROM  Candy_Products;
--Calculates the profit margin by subtracting unit cost from unit price for each product.
    
--3. Get Total Sales and Units Sold by Division  
SELECT Division, 
SUM(Sales) AS Total_Sales, 
SUM(Units) AS Total_Units
FROM Candy_Sales
GROUP BY Division;
--Calculates total sales and units sold for each division (e.g., Chocolate, Sugar).

--4. Find Top 5 Cities by Total Sales    
SELECT top 5 City, 
SUM(Sales) AS Total_Sales
FROM Candy_Sales
GROUP BY City
ORDER BY Total_Sales DESC;
--The query lists the top 5 cities with the highest total sales. Based on the results, New York City has the highest sales, followed by Los Angeles, Philadelphia, San Francisco, and Seattle.

--5. Get Factory-Wise Product Count
SELECT Factory, 
COUNT(Product_ID) AS Product_Count
FROM Candy_Products
GROUP BY Factory
ORDER BY Product_Count DESC;
--The query counts the number of products produced by each factory. The factory "Sugar Shack" has the highest product count (5), followed by "Lot's O' Nuts" with 3 products.

--6. Find Products with Maximum Price Difference Between Units    
SELECT Product_Name,MAX(Unit_Price - Unit_Cost) AS Max_Price_Difference
FROM Candy_Products
GROUP BY Product_Name
ORDER BY Max_Price_Difference DESC;
--The query identifies products with the largest difference between unit price and unit cost. "Lickable Wallpaper" has the maximum price difference of 10, followed by "Everlasting Gobstopper" with 8.

--7. Identify Orders with Late Shipments
SELECT Order_ID, DATEDIFF(DAY, Order_Date, Ship_Date) AS Days_to_Ship,
CASE WHEN DATEDIFF(DAY, Order_Date, Ship_Date) > 7 THEN 'Late'
ELSE 'On Time' END AS Shipment_Status
FROM Candy_Sales
WHERE Ship_Date IS NOT NULL;
--The query calculates the days taken to ship each order and flags orders taking more than 7 days as "Late." For instance, the order US-2021-103800-CHO-MIL-31000 took 8 days to ship and is categorized as "Late."    

--8. Search for Factory Names Containing Special Characters   
SELECT Factory
FROM Candy_Factories
WHERE Factory LIKE '%[^a-zA-Z0-9 ]%';  
--The query identifies factory names containing special characters. Results include Lot's O' Nuts and Wicked Choccy's.


--9. Calculate Running Totals of Sales and Gross Profit by Region
SELECT Region, Order_Date, Sales, Gross_Profit,
SUM(Sales) OVER (PARTITION BY Region ORDER BY Order_Date) AS Running_Total_Sales,
SUM(Gross_Profit) OVER (PARTITION BY Region ORDER BY Order_Date) AS Running_Total_Profit
FROM Candy_Sales;
--The query calculates cumulative sales and gross profit by region and date. For example, Atlantic's sales reach 55.15 and profit 36.67 by 2021-01-14.

--10. Find Top Products by Units Sold Using Percentile
WITH PercentileCTE AS (
SELECT Product_ID,Product_Name,Units,
PERCENT_RANK() OVER (ORDER BY Units DESC) AS Percentile
FROM Candy_Sales )
SELECT Product_ID, Product_Name, Units
FROM PercentileCTE
WHERE Percentile <= 0.1; 
--Products in the top 10th percentile by units sold include CHO-MIL-31000 (Milk Chocolate) and CHO-NUT-13000 (Nutty Crunch Surprise), each with 14 units.

--11. Calculate Average Sales per Day for Each Division
SELECT Division,
AVG(Sales) OVER (PARTITION BY Division, CAST(Order_Date AS DATE)) AS Avg_Sales_Per_Day
FROM Candy_Sales;
--The query computes daily average sales for divisions like Chocolate, with values ranging from 6.5 to 11.25.

--12. Find the Most Recent Orders for Each Division
WITH RankedOrders AS (
SELECT Division,Order_ID,Order_Date,
ROW_NUMBER() OVER (PARTITION BY Division ORDER BY Order_Date DESC) AS Rank
FROM Candy_Sales)
SELECT Division, Order_ID, Order_Date
FROM RankedOrders
WHERE Rank = 1;
--This query retrieves the latest order for each division based on the most recent order date. Results are missing from the image provided.

--13. Calculate Year-over-Year Sales Growth by Division
SELECT Division,YEAR(Order_Date) AS Sales_Year,SUM(Sales) AS Total_Sales,
LAG(SUM(Sales)) OVER (PARTITION BY Division ORDER BY YEAR(Order_Date)) AS Previous_Year_Sales,
CASE WHEN LAG(SUM(Sales)) OVER (PARTITION BY Division ORDER BY YEAR(Order_Date)) IS NOT NULL THEN 
(SUM(Sales) - LAG(SUM(Sales)) OVER (PARTITION BY Division ORDER BY YEAR(Order_Date))) * 100.0 / LAG(SUM(Sales)) OVER (PARTITION BY Division ORDER BY YEAR(Order_Date))
ELSE NULL END AS YoY_Growth_Percentage
FROM Candy_Sales
GROUP BY Division, YEAR(Order_Date)
ORDER BY Division, Sales_Year;
--The query calculates total sales and year-over-year growth percentages for each division by year. For example, Chocolate division shows a 23.16% growth from 2022 to 2023.


--14: Find the most populated cities for each state
WITH RankedCities AS (
	SELECT  state_name,city, population, density,
	RANK() OVER (PARTITION BY state_name ORDER BY population DESC) AS PopulationRank
	FROM US_zips)
SELECT state_name, city,population,density AS Population_Density,
CASE WHEN density > 5000 THEN 'Highly Dense'
WHEN density BETWEEN 1000 AND 5000 THEN 'Moderately Dense'
ELSE 'Low Density' END AS Density_Category
FROM RankedCities
WHERE PopulationRank = 1
ORDER BY state_name, population DESC;
--For each state, the query identifies the city with the highest population and classifies its population density. For example, Birmingham, Alabama, is classified as low density.

--15: Product Margin Calculation
SELECT p.Product_Name,SUM(s.Sales) AS Total_Sales,
SUM(s.Cost) AS Total_Cost,
(SUM(s.Sales) - SUM(s.Cost)) / SUM(s.Sales) * 100 AS Product_Margin_Percent
FROM Candy_Sales s
JOIN Candy_Products p ON s.Product_ID = p.Product_ID
GROUP BY p.Product_Name;
--This query calculates the profit margin percentage for each product. For instance, Everlasting Gobstopper has an 80% profit margin.

--16: Factory Optimization Recommendation
    
SELECT p.Product_Name,p.Factory, 
(SUM(s.Sales) - SUM(s.Cost)) / SUM(s.Sales) * 100 AS Product_Margin_Percent
FROM Candy_Sales s
JOIN Candy_Products p ON s.Product_ID = p.Product_ID
GROUP BY p.Product_Name, p.Factory
HAVING (SUM(s.Sales) - SUM(s.Cost)) / SUM(s.Sales) * 100 < 10  -- Threshold for low margin
ORDER BY Product_Margin_Percent;
--The query highlights factories with products having low profit margins (below 10%). Kazookles, made by The Other Factory, has a margin of 7.69%.


--17. Identify the Most Efficient Shipping Routes (Based on Distance)
SELECT  f.Factory, c.City,(power((f.Latitude - c.lat),2) + power((f.Longitude - c.lng),2)) AS Distance
FROM Candy_Factories f
JOIN US_zips c ON c.city = 'San Juan'
ORDER BY  Distance ASC;
--The query calculates distances from factories to San Juan for optimization. The Other Factory is closest, at a distance of 147.41.
  

--18. Compare Sales vs Target by Division   
SELECT  s.Division, 
SUM(s.Sales) AS Total_Sales, 
t.Target,(SUM(s.Sales) - t.Target) AS Difference
FROM  Candy_Sales s
JOIN  Candy_Targets t ON s.Division = t.Division
GROUP BY s.Division,t.Target;
-- Compares the total sales of each division against their targets. For example, "Chocolate" exceeded its target significantly with a difference of 104,692.90, while "Sugar" fell short by 14,572.52.


--19. Get Sales Target Achievement by Division
SELECT cs.Division,SUM(cs.Sales) AS Total_Sales, ct.Target, 
CASE WHEN SUM(cs.Sales) >= ct.Target THEN 'Target Achieved'
ELSE 'Target Not Achieved' END AS Target_Status
FROM Candy_Sales cs
JOIN Candy_Targets ct
ON cs.Division = ct.Division
GROUP BY cs.Division, ct.Target;
--Evaluates whether each division met its sales target. "Chocolate" achieved its target, while "Sugar" did not, as indicated in the "Target_Status" column.


--20. Determine Which Regions Exceeded Their Targets
SELECT cs.Division,Region, 
SUM(Sales) AS Total_Sales, 
Target,CASE WHEN SUM(Sales) > Target THEN 'Exceeded Target'
ELSE 'Did Not Exceed Target'
END AS Target_Status
FROM Candy_Sales cs
JOIN Candy_Targets ct
ON cs.Division = ct.Division
GROUP BY cs.Division, Region, Target;
--Checks target achievement by region within each division. For instance, "Chocolate" in the Pacific region exceeded its target, whereas "Sugar" in the Pacific did not meet its target.

    
--21. Generate a List of Consecutive Orders for Each Customer
WITH OrderedData AS (
SELECT Customer_ID,Order_ID,Order_Date,
ROW_NUMBER() OVER (PARTITION BY Customer_ID ORDER BY Order_Date) AS Row_Num
FROM Candy_Sales)
SELECT o1.Customer_ID,o1.Order_ID AS Current_Order,
o1.Order_Date AS Current_Order_Date,o2.Order_ID AS Next_Order,
o2.Order_Date AS Next_Order_Date
FROM OrderedData o1
JOIN OrderedData o2 ON o1.Customer_ID = o2.Customer_ID AND o1.Row_Num = o2.Row_Num - 1;
--Generates a list of consecutive orders for each customer. It pairs the current and next orders along with their dates, allowing tracking of order sequences for each customer. For example, Customer_ID 100013 has consecutive orders on the same date.


--22. Calculate Monthly Sales Trends for the Top Regions
WITH MonthlySales AS (
	SELECT Region, FORMAT(Order_Date, 'yyyy-MM') AS Sales_Month,
	SUM(Sales) AS Monthly_Sales
	FROM Candy_Sales
	GROUP BY Region, FORMAT(Order_Date, 'yyyy-MM'))
SELECT Region,Sales_Month,Monthly_Sales,
LAG(Monthly_Sales) OVER (PARTITION BY Region ORDER BY Sales_Month) AS Previous_Month_Sales,
(Monthly_Sales - LAG(Monthly_Sales) OVER (PARTITION BY Region ORDER BY Sales_Month)) AS Sales_Difference
FROM MonthlySales
ORDER BY Region, Sales_Month;
--Calculates monthly sales trends for each region. It shows the current month's sales, the previous month's sales, and the difference. For example, in the Atlantic region, sales in March 2021 increased by 492.18 compared to February 2021.

--23. Identify Orders That Miss Sales Targets by Division and Region
SELECT cs.Division,cs.Region,
SUM(cs.Sales) AS Total_Sales,
ct.Target AS Sales_Target,
CASE WHEN SUM(cs.Sales) >= ct.Target THEN 'Met Target'
ELSE 'Missed Target' END AS Target_Status
FROM Candy_Sales cs
JOIN Candy_Targets ct ON cs.Division = ct.Division
JOIN Candy_Products cp ON cs.Product_ID = cp.Product_ID
GROUP BY cs.Division, cs.Region, ct.Target;
--Identifies whether sales targets were met or missed by division and region. For instance, "Sugar" in the Pacific region missed its target, while "Other" in the Atlantic region met its target.

--24. Find the Most Profitable Product by Factory and Division  
SELECT cf.Factory,cp.Division,cp.Product_Name,
SUM(cs.Gross_Profit) AS Total_Profit,
CASE WHEN SUM(cs.Gross_Profit) > 100000 THEN 'Highly Profitable'
	ELSE 'Moderately Profitable' END AS Profit_Status
FROM Candy_Sales cs
JOIN Candy_Products cp ON cs.Product_ID = cp.Product_ID
JOIN Candy_Factories cf ON cp.Factory = cf.Factory
GROUP BY cf.Factory, cp.Division, cp.Product_Name
ORDER BY cf.Factory, Total_Profit DESC;
--Finds the most profitable products by factory and division. Products like "Wonka Bar - Scrumdiddlyumptious" from the "Lot's O' Nuts" factory are categorized as "Moderately Profitable" with a profit of 19,357.5.
