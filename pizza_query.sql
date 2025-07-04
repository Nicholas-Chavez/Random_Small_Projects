/* 
KPI's Requirements
1. Total Revenue
2. Average Order Value
3. Total Pizzas Sold
4. Total Orders
5. Average Pizzas Per Order
*/
# Total Revenue
SELECT SUM(quantity * unit_price) as Total_Revenue
FROM dataanalytics.pizza_sales;

#Average Order Value
SELECT (SELECT SUM(quantity * unit_price) as Total_Revenue FROM dataanalytics.pizza_sales)/COUNT(DISTINCT order_id) As Average_Order_Value
FROM dataanalytics.pizza_sales;

#Total Pizzas Sold
SELECT SUM(quantity) as Total_Pizzas_Sold
FROM dataanalytics.pizza_sales;

# Total Orders
SELECT COUNT(DISTINCT order_id) as Total_Orders
FROM dataanalytics.pizza_sales
LIMIT 100;

# Average Pizza Per Order
SELECT CAST( CAST(SUM(quantity) as decimal(10,2)) / CAST(COUNT(DISTINCT order_id) as decimal(10,2)) AS decimal(10,2) ) AS Average_Pizza_Per_Order
FROM dataanalytics.pizza_sales
LIMIT 100;

# Daily Trends for Total Orders
SELECT  DAYNAME(STR_TO_DATE(order_date, '%c/%e/%Y') ) AS order_day, 
COUNT( DISTINCT order_id) AS Total_Orders
FROM dataanalytics.pizza_sales
GROUP BY DAYNAME(STR_TO_DATE(order_date, '%c/%e/%Y') );

#Hourly Trends for total orders 
SELECT 
    HOUR(order_time) AS order_hours, 
    COUNT(DISTINCT order_id) AS total_orders
FROM dataanalytics.pizza_sales
GROUP BY HOUR(order_time)
ORDER BY HOUR(order_time);

# % of Sales by Pizza Category
SELECT pizza_category, ROUND(SUM(total_price), 2) as Total_Revenue, 
ROUND( SUM(total_price) * 100 / (SELECT SUM(total_price) FROM dataanalytics.pizza_sales), 2)
AS PCT
FROM dataanalytics.pizza_sales
GROUP BY pizza_category
ORDER BY pizza_category
LIMIT 100;

# % of Sales by Pizza Size
SELECT pizza_size, ROUND(SUM(total_price), 2) as Total_Revenue, 
ROUND( SUM(total_price) * 100 / (SELECT SUM(total_price) FROM dataanalytics.pizza_sales), 2) AS PCT
FROM dataanalytics.pizza_sales
GROUP BY pizza_size
ORDER BY pizza_size;

# Total Pizzas Sold by Pizza Category
SELECT pizza_category, COUNT(quantity) AS Total_Quantity_Sold
FROM dataanalytics.pizza_sales
WHERE MONTH(str_to_date(order_date, '%m/%d/%y')) = 2
GROUP BY pizza_category
ORDER BY Total_Quantity_Sold;

# Top 5 Best Sellers by Total Pizzas Sold
SELECT pizza_name, SUM(quantity) AS Total_Pizza
FROM dataanalytics.pizza_sales
GROUP BY pizza_name
ORDER BY Total_Pizza DESC
LIMIT 5;

# Bottom 5 Sellers by Total Pizzas Sold
SELECT pizza_name, SUM(quantity) AS Total_Pizza
FROM dataanalytics.pizza_sales
GROUP BY pizza_name
ORDER BY Total_Pizza ASC
LIMIT 5;

# Personal Note: to make any of the previous queries for specific months use `WHERE MONTH(str_to_date(order_date, '%m/%d/%y')) = X` Where X is the number of the month