--Creating a database
CREATE DATABASE my_sql_project;

--Delete table if it exists else create a new table named retail_sales
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales(
	transactions_id INT PRIMARY KEY NOT NULL,
	sale_date DATE,
	sale_time TIME,
	customer_id INT NOT NULL,
	gender VARCHAR(20),
	age INT,
	category VARCHAR(50),
	quantity INT,
	price_per_unit DECIMAL(10,2),
	cogs DECIMAL(10,2),
	total_sale DECIMAL(10,2)
);

--Counts total rows i.e records
SELECT COUNT(*) FROM retail_sales;

-- Counts unique customers
SELECT COUNT(DISTINCT customer_id)
FROM retail_sales;

-- Counts unique category in the table
SELECT COUNT(DISTINCT category)
FROM retail_sales;

-- Check if value in any column is NULL and returns them
SELECT * FROM retail_sales 
WHERE transactions_id IS NULL OR sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR gender IS NULL OR
		age IS NULL OR category IS NULL OR quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;

-- Deletes the NULL value rows. Not advisable in real-life cases but here it is allowed for practise, other solutions
-- according to situation can be implemented
DELETE FROM retail_sales
WHERE transactions_id IS NULL OR sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR gender IS NULL OR
		age IS NULL OR category IS NULL OR quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;

-- Find records whose sale_Date is 2022-11-05
SELECT * FROM retail_sales
WHERE sale_date = '2022-11-05';

--SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold 
--is more than 4 in the month of Nov-2022
SELECT * FROM retail_sales
WHERE category = 'Clothing'
AND quantity >= 4
AND sale_date >= '2022-11-01'
AND sale_date < '2022-12-1';

-- SQL query to calculate the total sales (total_sale) for each category
SELECT category, 
		SUM(total_sale) AS net_sale,
		COUNT(*) as total_order
FROM retail_sales
GROUP BY category;

-- SQL query to find the average age of customers who purchased items from the 'Beauty' category
SELECT category, ROUND(AVG(age), 2) AS Average_age
FROM retail_sales
WHERE category='Beauty'
GROUP BY category;

-- SQL query to find all transactions where the total_sale is greater than 1000
SELECT * FROM retail_sales
WHERE total_sale > 1000;

--  SQL query to find the total number of transactions (transaction_id) made by each gender in each category
SELECT gender, category, COUNT(transactions_id)
FROM retail_sales
GROUP BY gender, category
ORDER BY gender;

--  SQL query to calculate the average sale for each month. Find out best selling month in each year
SELECT
	years, month_name, avg_sale
FROM(
		SELECT
			EXTRACT(YEAR FROM sale_date) AS years,
			TO_CHAR(sale_date,'month') AS month_name,
			AVG(total_sale) AS avg_sale,
			RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) AS rank
		FROM retail_sales
		GROUP BY 1, 2			
	) AS t1
WHERE rank = 1;

-- SQL query to find the top 5 customers based on the highest total sales
SELECT customer_id, SUM(total_sale) AS sale,
	RANK() OVER(ORDER BY SUM(total_sale) DESC)
FROM retail_sales
GROUP BY 1
LIMIT 5;
-- Without the use of RANK() more efficient for simple search
SELECT customer_id,		
	SUM(total_sale) AS sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

--SQL query to find the number of unique customers who purchased items from each category
SELECT category,
	COUNT(DISTINCT customer_id) as unique_customer
FROM retail_sales
GROUP BY category;

-- Finding repeat customer who visited more than once
SELECT customer_id,
	COUNT(transactions_id) AS total_visits,
	SUM(total_sale) AS total_spent
FROM retail_sales
GROUP BY customer_id
HAVING COUNT(transactions_id) > 1
ORDER BY total_spent DESC;

--Gender based sales analysis
SELECT gender, 
	COUNT(*) AS total_transaction,
	SUM(total_sale) AS total_spent
FROM retail_sales
GROUP BY gender;


-- Find sale of a particular month of a year
SELECT 
	EXTRACT(YEAR FROM sale_date) AS Sale_year,
	EXTRACT(MONTH FROM sale_date) AS Sale_month,
	SUM(total_sale) AS sales 
FROM retail_sales
WHERE sale_date BETWEEN '2022-01-01' AND '2022-01-31'
GROUP BY Sale_year, Sale_month;


-- Find the Top Best-Selling Categories
SELECT 
    category, 
    SUM(quantity) AS total_quantity_sold
FROM retail_sales
GROUP BY category
ORDER BY total_quantity_sold DESC;

--  Find the Most Profitable Customers (Based on Total Sales)
SELECT 
    customer_id, 
    SUM(total_sale) AS total_spent
FROM retail_sales
GROUP BY customer_id
ORDER BY total_spent DESC
LIMIT 10;

-- Monthly Sales Trend Analysis
SELECT 
    EXTRACT(YEAR FROM sale_date) AS year, 
    EXTRACT(MONTH FROM sale_date) AS month, 
    SUM(total_sale) AS monthly_sales
FROM retail_sales
GROUP BY year, month
ORDER BY year, month;

-- Find the Peak Sales Hours of the Day
SELECT 
    EXTRACT(HOUR FROM sale_time) AS hour_of_day, 
    COUNT(*) AS total_transactions,
    SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY hour_of_day
ORDER BY total_sales DESC;

--Customer Retention: Find Repeat Customers
SELECT 
    customer_id, 
    COUNT(transactions_id) AS purchase_count,
    SUM(total_sale) AS total_spent
FROM retail_sales
GROUP BY customer_id
HAVING COUNT(transactions_id) > 1
ORDER BY total_spent DESC;

--Find the Most Profitable Product Category
SELECT 
    category, 
    SUM(total_sale - cogs) AS total_profit
FROM retail_sales
GROUP BY category
ORDER BY total_profit DESC;

--Identify the Best Sales Month Each Year
SELECT 
    year, 
    month, 
    total_sales
FROM (
    SELECT 
        EXTRACT(YEAR FROM sale_date) AS year, 
        EXTRACT(MONTH FROM sale_date) AS month, 
        SUM(total_sale) AS total_sales,
        RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY SUM(total_sale) DESC) AS rank
    FROM retail_sales
    GROUP BY year, month
) AS ranked_sales
WHERE rank = 1;

