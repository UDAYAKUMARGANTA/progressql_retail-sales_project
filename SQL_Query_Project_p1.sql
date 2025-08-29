-- Create table
CREATE TABLE retails_sales
			(
				transactions_id	INT PRIMARY KEY,
				sale_date DATE,	
				sale_time	TIME,
				customer_id	INT,
				gender VARCHAR(15),
				age	INT,
				category VARCHAR(15),	
				quantiy	INT,
				price_per_unit FLOAT,	
				cogs FLOAT,
				total_sale FLOAT
			);	
--table couning limited			
SELECT * FROM retails_sales
LIMIT 10
--table counting
SELECT 
	COUNT(*)
FROM retails_sales
--finding null values and also data cleaing
SELECT * FROM retails_sales
WHERE transactions_id IS NULL
	  OR
	  sale_date IS NULL
	  OR
	  sale_time IS NULL
	  OR 
	  customer_id IS NULL
	  OR 
	  gender IS NULL
	  OR
	  age IS NULL
	  OR
	  category IS NULL
	  OR
	  quantiy IS NULL
	  OR
	  price_per_unit IS NULL
	  OR
	  cogs IS NULL
	  OR
	  total_sale IS NULL;

--Delete Null values
DELETE FROM retails_sales
WHERE
	  transactions_id IS NULL
	  OR
	  sale_date IS NULL
	  OR
	  sale_time IS NULL
	  OR 
	  customer_id IS NULL
	  OR 
	  gender IS NULL
	  OR
	  age IS NULL
	  OR
	  category IS NULL
	  OR
	  quantiy IS NULL
	  OR
	  price_per_unit IS NULL
	  OR
	  cogs IS NULL
	  OR
	  total_sale IS NULL;
	
--Data Exploration
--How many total sales
SELECT COUNT(*) as total_sale from retails_sales; 
--How many unique customers are there
SELECT COUNT(DISTINCT customer_id) as total_sale from retails_sales;

--To know how many categories are in the table
SELECT DISTINCT category from retails_sales;
--Data Analysis & Business key problem & Answers

--My Analysis & findings
--Q1.Write a SQL query to retrieve all columns for sales made on '2022-11-05'
--Q2.Write a SQL query to retrieve all transactions where the category is 
--'Clothing' and the quantity sold is more than 4 in the  month of Nov-2022 
--Q3.Write a SQL query to calculate the total sales (total_sale) for each category
--Q4.Write a SQL query to find the average age of customers who purchased items from the 
--'Beauty' category
--Q5.Write a SQL query to find all transactions where the total_sale is greater than 1000.
--Q6.Write a SQL query to find the total number of transactions (transactions_id) made by 
--each gender in each category
--Q7.Write a SQL query to calculate the average sale for each month. Find out best selling
--month in the year
--Q8.Write a SQL query to find the top 5 customers based on the highest total sales.
--Q9.Write a SQL query to find the number of unique customers who purchased items from each category.
--Q10.Write a SQL query to create each shift and number of orders (Ex: Morning<=12, afternoon between 12 & 17, Evening >17)

--Q1.Write a SQL query to retrieve all columns for sales made on '2022-11-05'
SELECT * FROM retails_sales
WHERE sale_date = '2022-11-05';

--Q2.Write a SQL query to retrieve all transactions where the category is 
SELECT category, SUM(quantiy) from retails_sales 
WHERE category = 'Clothing' GROUP BY 1

SELECT * FROM retails_sales WHERE category = 'Clothing'
	AND
	TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
	AND
	quantiy >= 4;

--Q3.Write a SQL query to calculate the total sales (total_sale) for each category
SELECT category, SUM(total_sale) as net_sales
From retails_sales
GROUP BY 1;

SELECT category, SUM(total_sale) as net_sales, COUNT(*) as total_orders
From retails_sales
GROUP BY 1;

--Q4.Write a SQL query to find the average age of customers who purchased items from the 
--'Beauty' category
SELECT ROUND(AVG(age), 2) as avg_age
FROM retails_sales where category = 'Beauty';

--Q5.Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT * FROM retails_sales where total_sale > 1000;

--Q6.Write a SQL query to find the total number of transactions (transactions_id) made by 
SELECT category, gender, COUNT(*) as total_trans FROM retails_sales 
GROUP BY category, gender ORDER BY 1;

--Q7.Write a SQL query to calculate the average sale for each month. Find out best selling
SELECT * FROM 
(	SELECT 
		EXTRACT(YEAR FROM sale_date) as year,
		EXTRACT(MONTH FROM sale_date) as month,
		AVG(total_sale) as avg_sale,
		RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) 
		ORDER BY AVG(total_sale) DESC) 
		as rank FROM retails_sales
	GROUP BY 1,2
) as t1
WHERE rank = 1;


SELECT 
	year, month, avg_sale
FROM 
(	SELECT 
		EXTRACT(YEAR FROM sale_date) as year,
		EXTRACT(MONTH FROM sale_date) as month,
		AVG(total_sale) as avg_sale,
		RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) 
		ORDER BY AVG(total_sale) DESC) 
		as rank FROM retails_sales
	GROUP BY 1,2
) as t1
WHERE rank = 1;

--Q8.Write a SQL query to find the top 5 customers based on the highest total sales.
SELECT 
	customer_id,
	SUM(total_sale) as total_sales
FROM retails_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

--Q9.Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT category,
	COUNT(DISTINCT customer_id) as cus_unique_id
FROM retails_sales
GROUP By category



--Q10.Write a SQL query to create each shift and number of orders (Ex: Morning<=12, afternoon between 12 & 17, Evening >17)

SELECT *,
	CASE
		WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
		WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	End as shift
FROM retails_sales



WITH hourly_sale
as
( 	SELECT *,
		CASE
			WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
			WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
			ELSE 'Evening'
		End as shift
	FROM retails_sales
)
SELECT shift, 
COUNT(*) as total_orders
FROM hourly_sale
GROUP BY shift