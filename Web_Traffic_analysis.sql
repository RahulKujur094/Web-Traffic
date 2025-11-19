CREATE DATABASE IF NOT EXISTS walmartsales;

CREATE TABLE IF NOT EXISTS sales(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    quantity INT NOT NULL,
    tax_pct FLOAT(6,4) NOT NULL,
    total DECIMAL(12, 4) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment VARCHAR(15) NOT NULL,
    cogs DECIMAL(10,2) NOT NULL,
    gross_margin_pct FLOAT(11,9),
    gross_income DECIMAL(12, 4),
    rating FLOAT(2, 1)
);

-- timme of day

SELECT
    time,
    CASE
        WHEN time BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
        WHEN time BETWEEN '12:00:01' AND '16:00:00' THEN 'Afternoon'
        ELSE 'Evening'
    END AS time_of_date
FROM Sales;

ALTER TABLE sales ADD COLUMN time_of_day VARCHAR(20);

UPDATE sales
SET time_of_day = (
    CASE
        WHEN time BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
        WHEN time BETWEEN '12:00:01' AND '16:00:00' THEN 'Afternoon'
        ELSE 'Evening'
    END
);

-- DAY NAME
SELECT
    date,
    DAYNAME(date)
FROM sales;

ALTER TABLE sales ADD COLUMN day_name VARCHAR(10);

UPDATE sales
SET day_name = DAYNAME(date);

-- month name
SELECT
    date,
    MONTHNAME(date)
from sales;

ALTER TABLE sales ADD COLUMN month_name VARCHAR(10);

UPDATE sales
SET month_name = MONTHNAME(date);

SELECT cogs, 0.05 * cogs
FROM sales;

ALTER TABLE sales ADD COLUMN VAT FLOAT;

SET SQL_SAFE_UPDATES = 0;

UPDATE sales
SET VAT = 0.05 * cogs;

SET SQL_SAFE_UPDATES = 1;


-----------------------------------------------------------------------------------------------

----------------------- Generic ----------------------------------

-- How many unique cities does the data have?
SELECT 
    DISTINCT city
FROM
    sales;
    
-- In Which City is each branch?
SELECT DISTINCT
    city, branch
FROM sales;

---------------------------------------------------------------------------------------------
------------------------------------- Product ----------------------------------------

-- How many unique product lines does the data have?  
SELECT 
    COUNT(DISTINCT product_line)
FROM sales;

-- What is the most common payment method?
SELECT 
    payment, COUNT(payment) AS cnt
FROM sales
GROUP BY payment
ORDER BY cnt DESC;

-- What is the most selling product line?
SELECT 
    product_line,
    COUNT(product_line) AS cnt
FROM sales
GROUP BY product_line
ORDER BY cnt DESC LIMIT 1;

-- What is the total revenue by month?
SELECT 
    month_name, 
    SUM(total) AS total_revenue
FROM sales
GROUP BY month_name
ORDER BY total_revenue DESC;

-- What month had the largest COGS?
SELECT 
    month_name, 
    SUM(cogs) AS cogs
FROM sales
GROUP BY month_name
ORDER BY cogs DESC
LIMIT 1;

-- What product line had the largest revenue?
SELECT 
    product_line,
    SUM(total) AS total_revenue
FROM sales
GROUP BY product_line
ORDER BY total_revenue DESC;

-- What is the city with the largest revenue?
SELECT 
    city,
    SUM(total) AS total_revenue
FROM sales
GROUP BY city
ORDER BY total_revenue DESC;

-- What product line had the largest VAT?
SELECT 
    product_line,
    AVG(tax_pct) AS avg_tax
FROM sales
GROUP BY product_line
ORDER BY avg_tax DESC;

-- Which Branch Sold more Products than average products sold?
SELECT 
    branch,
    SUM(quantity) AS qty
FROM sales
GROUP BY branch
HAVING SUM(quantity) > (SELECT 
        AVG(quantity)
    FROM
        sales);
        
-- What is the most common product line by gender?
SELECT 
    gender,
    product_line, COUNT(gender) AS total_count
FROM sales
GROUP BY gender , product_line
ORDER BY total_count DESC;

-- What is the average rating of each product line?
SELECT 
    ROUND(AVG(rating), 2) AS avg_rating,
    product_line
FROM sales
GROUP BY product_line
ORDER BY avg_rating DESC;

-- Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales 
SELECT product_line,
       CASE 
           WHEN total > (SELECT AVG(total) FROM sales) THEN 'Good'
           ELSE 'Bad'
       END AS condition_of_product
FROM sales;

------------------------------------------------------------------------------------------------
----------------------------------- Sales --------------------------------------------------

-- Number of sales made in each time of the day per weekday
SELECT 
    time_of_day,
    COUNT(*) AS total_sales
FROM sales
WHERE day_name = 'Monday'
GROUP BY time_of_day
ORDER BY total_sales DESC;

-- Which of the customer types brings the most revenue?
SELECT 
    customer_type, 
    SUM(total) AS total_revenue
FROM sales
GROUP BY customer_type
ORDER BY total_revenue DESC;

-- Which city has the largest tax percent/ VAT (Value Added Tax)?
SELECT 
    city,
    AVG(tax_pct) AS VAT
FROM sales
GROUP BY city
ORDER BY VAT DESC;

-- Which customer type pays the most in VAT?
SELECT 
    customer_type,
    AVG(tax_pct) AS VAT
FROM sales
GROUP BY customer_type
ORDER BY VAT DESC;


---------------------------------------------------------------------------------------------
------------------------------------------ Customer ----------------------------------

-- Which customer type pays the most in VAT?
SELECT DISTINCT
    customer_type
FROM sales;

-- How many unique payment methods does the data have?
SELECT DISTINCT
    payment
FROM sales;

-- What is the most common customer type?
SELECT 
    customer_type,
    COUNT(*) AS cstm_count
FROM sales
GROUP BY customer_type;

-- What is the gender of most of the customers?
SELECT 
    gender,
    COUNT(*) AS gender_count
FROM sales
GROUP BY gender
ORDER BY gender_count DESC;

-- What is the gender distribution per branch?
SELECT 
    branch,
    gender,
    COUNT(*) AS gender_count
FROM sales
GROUP BY branch, gender
ORDER BY branch, gender_count DESC;

-- What is the gender distribution per branch?
SELECT 
    branch,
    gender,
    COUNT(*) AS gender_count
FROM sales
GROUP BY branch, gender
ORDER BY branch, gender_count DESC;


-- Which time of the day do customers give most ratings?
SELECT 
    time_of_day, AVG(rating) AS RATING
FROM sales
GROUP BY time_of_day
ORDER BY RATING DESC;

-- Which time of the day do customers give most ratings per branch?
SELECT 
    branch,
    time_of_day,
    COUNT(*) AS rating_count
FROM sales
WHERE rating IS NOT NULL
GROUP BY branch, time_of_day
ORDER BY branch, rating_count DESC;

-- Which time of the day do customers give most ratings per branch?
 SELECT 
    branch,
    time_of_day,
    AVG(rating) AS rating_count
FROM sales
WHERE rating IS NOT NULL
GROUP BY branch, time_of_day
ORDER BY branch, rating_count DESC;

-- Which day of the week has the best avg ratings?
SELECT 
    day_name,
    AVG(rating) AS RATING
FROM sales
GROUP BY day_name
ORDER BY RATING DESC
LIMIT 1;

-- Which day of the week has the best average ratings per branch?
WITH Ranked AS (SELECT 
    branch,
    day_name,
    AVG(rating) AS Rating,
    RANK() OVER (PARTITION BY branch ORDER BY AVG(rating) DESC) AS rnk
FROM sales
WHERE rating IS NOT NULL
GROUP BY branch, day_name
ORDER BY branch, Rating DESC
)
SELECT branch, day_name, Rating
FROM Ranked
WHERE rnk = 1;








