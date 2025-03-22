# Sales of a Store Analysis SQL Project

## Project Overview

**Project Title**:  Store Sales Analysis  
**Level**: Beginner  
**Database**: `my_sql_project`

This project is designed to demonstrate SQL skills and techniques typically used by data analysts to explore, clean, and analyze store's sales data. The project involves setting up a store's sales database, performing exploratory data analysis (EDA), and answering specific business questions through SQL queries. This project is ideal for those who are starting their journey in data analysis and want to build a solid foundation in SQL.

## Objectives

1. **Set up a store's sales database**: Create and populate a store sales database with the provided sales data.
2. **Data Cleaning**: Identify and remove any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Use SQL to answer specific business questions and derive insights from the sales data.

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `my_sql_project`.
- **Table Creation**: A table named `retail_sales` is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

```sql
CREATE DATABASE my_sql_project;

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
```

### 2. Data Exploration & Cleaning

- **Record Count**: Determine the total number of records in the dataset.
- **Customer Count**: Find out how many unique customers are in the dataset.
- **Category Count**: Identify all unique product categories in the dataset.
- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.

```sql
SELECT COUNT(*) FROM retail_sales;
SELECT COUNT(DISTINCT customer_id) FROM retail_sales;
SELECT COUNT(DISTINCT category) FROM retail_sales;

SELECT * FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;

DELETE FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;
```

### 3. Data Analysis & Findings

The following SQL queries were developed to answer specific business questions:

1. **Write a SQL query to retrieve all columns for sales made on '2022-11-05**:
```sql
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';
```

2. **Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022**:
```sql
SELECT * FROM retail_sales
WHERE category = 'Clothing'
AND quantity >= 4
AND sale_date >= '2022-11-01'
AND sale_date < '2022-12-1';
```

3. **Write a SQL query to calculate the total sales (total_sale) for each category.**:
```sql
SELECT category, 
		SUM(total_sale) AS net_sale,
		COUNT(*) as total_order
FROM retail_sales
GROUP BY category;
```

4. **Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.**:
```sql
SELECT category, ROUND(AVG(age), 2) AS Average_age
FROM retail_sales
WHERE category='Beauty'
GROUP BY category;
```

5. **Write a SQL query to find all transactions where the total_sale is greater than 1000.**:
```sql
SELECT * FROM retail_sales
WHERE total_sale > 1000;
```

6. **Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.**:
```sql
SELECT gender, category, COUNT(transactions_id)
FROM retail_sales
GROUP BY gender, category
ORDER BY gender;
```

7. **Write a SQL query to calculate the average sale for each month. Find out best selling month in each year**:
```sql
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
```

8. **Write a SQL query to find the top 5 customers based on the highest total sales **:
```sql
SELECT customer_id, SUM(total_sale) AS sale,
	RANK() OVER(ORDER BY SUM(total_sale) DESC)
FROM retail_sales
GROUP BY 1
LIMIT 5;
```
Another method:
```sql
SELECT customer_id,		
	SUM(total_sale) AS sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;
```

9. **Write a SQL query to find the number of unique customers who purchased items from each category.**:
```sql
SELECT category,
	COUNT(DISTINCT customer_id) as unique_customer
FROM retail_sales
GROUP BY category;
```

10. **Write a SQL query to find repeat customer who visited more than once.**:
```sql
SELECT customer_id,
	COUNT(transactions_id) AS total_visits,
	SUM(total_sale) AS total_spent
FROM retail_sales
GROUP BY customer_id
HAVING COUNT(transactions_id) > 1
ORDER BY total_spent DESC;
```

11. **Write a SQL query to Gender based sales analysis.**:
```sql
SELECT gender, 
	COUNT(*) AS total_transaction,
	SUM(total_sale) AS total_spent
FROM retail_sales
GROUP BY gender;
```

12. **Write a SQL query to find sale of a particular month of a year.**:
```sql
SELECT 
	EXTRACT(YEAR FROM sale_date) AS Sale_year,
	EXTRACT(MONTH FROM sale_date) AS Sale_month,
	SUM(total_sale) AS sales 
FROM retail_sales
WHERE sale_date BETWEEN '2022-01-01' AND '2022-01-31'
GROUP BY Sale_year, Sale_month;
```

13. **Write a SQL query to find the Best-Selling Categories.**:
```sql
SELECT 
    category, 
    SUM(quantity) AS total_quantity_sold
FROM retail_sales
GROUP BY category
ORDER BY total_quantity_sold DESC;
```

14. **Write a SQL query to find the Most Profitable Customers (Based on Total Sales).**:
```sql
SELECT 
    customer_id, 
    SUM(total_sale) AS total_spent
FROM retail_sales
GROUP BY customer_id
ORDER BY total_spent DESC
LIMIT 10;
```

15. **Write a SQL query to find the Monthly Sales Trend Analysis.**:
```sql
SELECT 
    EXTRACT(YEAR FROM sale_date) AS year, 
    EXTRACT(MONTH FROM sale_date) AS month, 
    SUM(total_sale) AS monthly_sales
FROM retail_sales
GROUP BY year, month
ORDER BY year, month;
```

16. **Write a SQL query to Find the Peak Sales Hours of the Day.**:
```sql
SELECT 
    EXTRACT(HOUR FROM sale_time) AS hour_of_day, 
    COUNT(*) AS total_transactions,
    SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY hour_of_day
ORDER BY total_sales DESC;
```

17. **Write a SQL query to find the Customer Retention: Find Repeat Customers.**:
```sql
SELECT 
    customer_id, 
    COUNT(transactions_id) AS purchase_count,
    SUM(total_sale) AS total_spent
FROM retail_sales
GROUP BY customer_id
HAVING COUNT(transactions_id) > 1
ORDER BY total_spent DESC;
```

18. **Write a SQL query to find the Most Profitable Product Category.**:
```sql
SELECT 
    category, 
    SUM(total_sale - cogs) AS total_profit
FROM retail_sales
GROUP BY category
ORDER BY total_profit DESC;
```

19. **Write a SQL query to Identify the Best Sales Month Each Year.**:
```sql
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
```


## Findings

- **Customer Demographics**: The dataset includes customers from various age groups, with sales distributed across different categories such as Clothing and Beauty.
- **High-Value Transactions**: Several transactions had a total sale amount greater than 1000, indicating premium purchases.
- **Sales Trends**: Monthly analysis shows variations in sales, helping identify peak seasons.
- **Customer Insights**: The analysis identifies the top-spending customers and the most popular product categories.

## Reports

- **Sales Summary**: A detailed report summarizing total sales, customer demographics, and category performance.
- **Trend Analysis**: Insights into sales trends across different months and shifts.
- **Customer Insights**: Reports on top customers and unique customer counts per category.

## Conclusion

This project serves as a comprehensive introduction to SQL for data analysts, covering database setup, data cleaning, exploratory data analysis, and business-driven SQL queries. The findings from this project can help drive business decisions by understanding sales patterns, customer behavior, and product performance.


