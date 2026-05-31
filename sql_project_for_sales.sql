SELECT * FROM retail_sales 
LIMIT 10;

SELECT COUNT(*)
FROM retail_sales;

SELECT *
FROM retail_sales
WHERE transactions_id IS NULL
   OR sale_date IS NULL
   OR sale_time IS NULL
   OR customer_id IS NULL
   OR gender IS NULL
   OR age IS NULL
   OR category IS NULL
   OR quantity IS NULL
   OR price_per_unit IS NULL
   OR cogs IS NULL
   OR total_sale IS NULL;
SELECT 
   COUNT(*) AS total_rows,
   COUNT(customer_id) AS non_null_customer_id,
   COUNT(*) - COUNT(customer_id) AS null_customer_id
from retail_sales;
   
-- Data Exploration

-- How many sales we have?
SELECT COUNT(*) AS Total_sales FROM retail_sales;

-- How many customer we have?
SELECT COUNT(DISTINCT customer_id) AS Total_customer FROM retail_sales;

-- How many categories we have?
SELECT COUNT(DISTINCT category) as number_of_categories FROM retail_sales;
SELECT DISTINCT category From retail_sales;

-- Data Analysis & Business key problems & answers

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
SELECT * FROM retail_sales WHERE sale_date = '2022-11-05';

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022
SELECT * FROM retail_sales 
WHERE category ='Clothing' AND quantity >= 4 AND DATE_FORMAT(sale_date, '%Y-%m') = '2022-11';

SELECT * FROM retail_sales
WHERE category = 'Clothing' AND quantity >= 4 AND sale_date >= '2022-11-01' AND sale_date <='2022-11-30';
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
SELECT  
     category,
     SUM(total_sale) AS net_sale,
     COUNT(*) AS total_orders
FROM retail_sales 
GROUP BY category;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
SELECT 
ROUND(AVG(age),2) AS Avg_age
FROM retail_sales 
WHERE category = 'Beauty';

-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
SELECT * FROM retail_sales
WHERE total_sale > 1000;

-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
SELECT category, gender, COUNT(*) AS total_no_transactions 
FROM retail_sales 
GROUP BY category,
         gender;
         
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
SELECT * FROM
(SELECT DATE_FORMAT(sale_date,'%Y'),
DATE_FORMAT(sale_date, '%m'), 
AVG(total_sale) AS avg_sale,
RANK() OVER(PARTITION BY DATE_FORMAT(sale_date, '%Y') ORDER BY AVG(total_sale) DESC) AS rnk
FROM retail_sales 
GROUP BY 1,2
) AS t1
Where rnk = 1;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
SELECT customer_id , SUM(total_sale) 
FROM retail_sales
GROUP BY customer_id
ORDER BY 2 DESC
LIMIT 5;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
SELECT category,COUNT(DISTINCT customer_id)
FROM retail_sales 
GROUP BY category;

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
WITH hourly_sale
AS
(
SELECT*, 
   CASE 
     WHEN HOUR(sale_time) < 12 THEN 'morning'
     WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
     ELSE 'Evening'
    END AS shift
FROM retail_sales
)

SELECT 
shift,
COUNT(*) AS total_orders 
FROM hourly_sale 
GROUP BY shift
