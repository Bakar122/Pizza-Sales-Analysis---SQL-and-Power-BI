-- PIZZA SALES ANALYSIS

-- 1. What was the total sales revenue?
SELECT 
ROUND(SUM(Price * Quantity),2) AS Total_Revenue
FROM Pizzas P
INNER JOIN Order_details O
ON P.pizza_id = o.pizza_id;

-- 2. What was the average order value?
SELECT 
ROUND(SUM(Quantity * Price)/ NULLIF(COUNT(DISTINCT(order_id)),0),2) AS Average_Order_Value
FROM Pizzas P
INNER JOIN Order_details O
ON P.pizza_id = o.pizza_id;

-- 3. How many pizzas were sold in total?
SELECT
SUM(Quantity) AS Total_Pizzas_Sold
FROM Order_details;

-- 4. How many orders were placed in total?
SELECT
COUNT(DISTINCT (order_id)) AS Total_orders
FROM Order_details;

-- 5. How many pizzas were sold per order on average?
SELECT 
ROUND(SUM(Quantity)::Numeric / NULLIF (COUNT(DISTINCT(Order_id)),0),2) AS Average_Pizza_Per_Order
FROM Order_details;

-- 6. How many orders were placed on each day of the week?
SELECT
TO_CHAR(date, 'FMDay') AS day_of_week,
COUNT(DISTINCT(Order_id)) AS Total_Orders
FROM Orders
GROUP BY TO_CHAR(date, 'FMDay')
ORDER BY Total_orders DESC;

-- 7. How many orders were placed in each hour of the day?
SELECT 
EXTRACT(HOUR FROM Time) AS Hour,
COUNT(DISTINCT(Order_id)) AS Total_Orders
FROM Orders
GROUP BY EXTRACT(HOUR FROM Time)
ORDER BY EXTRACT(HOUR FROM Time); 

-- 8. What percentage of total revenue came from each pizza category?
SELECT 
pt.Category,
SUM(P.Price * O.Quantity) AS Total_Revenue,
ROUND(SUM(P.Price * O.Quantity) * 100 / 
NULLIF((SELECT SUM(p2.Price * o2.Quantity) FROM Pizzas P2 
INNER JOIN Order_Details AS O2
ON P2.pizza_id = o2.pizza_id),0),2) AS Percentage_Sales
FROM Pizzas P
INNER JOIN Pizza_types AS Pt
ON p.pizza_type_id = pt.pizza_type_id
JOIN order_details AS o
ON p.pizza_id = o.pizza_id
GROUP BY pt.category
ORDER BY Percentage_Sales DESC;

-- 9. What percentage of total revenue came from each pizza size?
SELECT 
p.size,
SUM(P.Price * O.Quantity) AS Total_Revenue,
ROUND(SUM(P.Price * O.Quantity) * 100 / 
NULLIF((SELECT SUM(p2.Price * o2.Quantity) FROM Pizzas P2 
INNER JOIN Order_Details AS O2
ON P2.pizza_id = o2.pizza_id),0),2) AS Percentage_Sales
FROM Pizzas P
INNER JOIN Pizza_types AS Pt
ON p.pizza_type_id = pt.pizza_type_id
JOIN order_details AS o
ON p.pizza_id = o.pizza_id
GROUP BY p.size
ORDER BY Percentage_Sales DESC;

-- 10. How many pizzas were sold in each category?
SELECT pt.category,
SUM(O.Quantity) AS Quantity_Sold
FROM Pizzas P
INNER JOIN Pizza_types AS Pt
ON p.pizza_type_id = pt.pizza_type_id
JOIN order_details AS o
ON p.pizza_id = o.pizza_id
GROUP BY pt.category
ORDER BY Quantity_Sold DESC;

-- 11. Which five pizza types sold the most units across all sizes?
SELECT Pt.name,
SUM(O.Quantity) AS Quantity_Sold
FROM Pizzas P
INNER JOIN Pizza_types AS Pt
ON p.pizza_type_id = pt.pizza_type_id
JOIN order_details AS o
ON p.pizza_id = o.pizza_id
GROUP BY 1
ORDER BY Quantity_Sold DESC
LIMIT 5;

--12. Which five pizza types sold the fewest units across all sizes?
SELECT Pt.name,
SUM(O.Quantity) AS Quantity_Sold
FROM Pizzas P
INNER JOIN Pizza_types AS Pt
ON p.pizza_type_id = pt.pizza_type_id
JOIN order_details AS o
ON p.pizza_id = o.pizza_id
GROUP BY 1
ORDER BY Quantity_Sold ASC
LIMIT 5;
