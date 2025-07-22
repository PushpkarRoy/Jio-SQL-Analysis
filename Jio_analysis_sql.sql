CREATE TABLE customers (
customer_id INT, 
name VARCHAR(50),
gender VARCHAR(20),
age INT,
city VARCHAR(50),
sim_type VARCHAR(20),
join_date DATE,
is_active VARCHAR(20),
device_type VARCHAR(50),
referred_by INT
)

CREATE TABLE data_usager(
usage_id INT,
customer_id INT,
date DATE,
gb_used FLOAT,
app_most_used VARCHAR(50),
is_roaming VARCHAR(20),
download_speed FLOAT,
upload_speed FLOAT,
data_pack_type VARCHAR(50)
)

CREATE TABLE recharges (
recharge_id INT,
customer_id	 INT,
recharge_date DATE,
recharge_amount INT,
plan_type VARCHAR(50),
plan_name VARCHAR(50),
validity_days INT,
has_discount VARCHAR(20),
payment_method VARCHAR(500)
)


SELECT * FROM customers 
SELECT * FROM data_usager
SELECT * FROM recharges


-- 1. How many total customers are active?

SELECT COUNT(customer_id) AS Active_user
FROM customers 
WHERE is_active = 'True'

-- 2. List the top 5 cities with the most Jio users.

SELECT city, COUNT(customer_id) AS total_user
FROM customers 
GROUP BY city
ORDER BY total_user DESC

-- 3. What is the average age of customers using iOS devices?

SELECT ROUND(AVG(age):: NUMERIC ,2) AS Avg_age_user_of_iOS_devices 
FROM customers 
WHERE device_type = 'iOS'

-- 4. How many customers were referred by someone?

SELECT COUNT(referred_by) AS total_referred_count
FROM customers 
WHERE referred_by IS NOT NULL

-- 5. What is the most common data_pack_type among users?

SELECT data_pack_type, COUNT(customer_id) AS total_user
FROM data_usager
GROUP BY data_pack_type

-- 6. Show the total GB used per customer in March 2024.

SELECT  du.customer_id, c.name, 
		ROUND(SUM(gb_used):: NUMERIC ,2 ) AS total_GB_used
FROM data_usager AS du
JOIN customers AS c
ON c.customer_id = du.customer_id 
GROUP BY du.customer_id, c.name
ORDER BY total_GB_used DESC

-- 7. Find the number of prepaid vs postpaid customers by gender.

SELECT *,
RANK() OVER(PARTITION BY gender ORDER BY total_sim_type DESC) AS ranking
FROM (
	SELECT gender, sim_type, COUNT(customer_id) AS total_sim_type
	FROM customers
	GROUP BY gender, sim_type ) AS x	

-- 8. What is the most used app in February 2024?

SELECT app_most_used, total_count
FROM (
	SELECT  EXTRACT(MONTH FROM date) AS month_no,
			TO_CHAR(date, 'Month') AS month,
			app_most_used, COUNT(app_most_used) AS Total_count
	FROM data_usager
	GROUP BY month, app_most_used, month_no ) AS x
WHERE month_no = 2
ORDER BY total_count DESC

-- 9. List all customers who joined in the last 30 days.

SELECT DISTINCT customer_id, name ,join_date 
FROM customers 
WHERE join_date >= ( SELECT MAX(join_date)
						FROM customers ) - INTERVAL '1 Month'
ORDER BY join_date DESC

-- 10. Find the top 3 customers who spent the most on recharges in Q1 2024.

SELECT r.customer_id , c.name, SUM(recharge_amount) AS total_spend
FROM customers AS c
JOIN recharges AS r
ON r.customer_id = c.customer_id
GROUP BY r.customer_id , c.name
ORDER BY total_spend DESC
LIMIT 3

-- 🔹 Advanced (Q11–16)
-- 11. Which customers had the highest average download speed in roaming mode?

SELECT du.customer_id, c.name, MAX(du.download_speed) AS top_speed
FROM data_usager AS du
JOIN customers AS c
ON du.customer_id = c.customer_id
GROUP BY du.customer_id, c.name, du.download_speed
ORDER BY du.download_speed DESC
LIMIT 5

-- 12. Find all customers who recharged more than 3 times but never used a discount.

SELECT customer_id , COUNT(customer_id) AS total_recharge, has_discount
FROM recharges
GROUP BY customer_id, has_discount
HAVING COUNT(customer_id) >= 3 AND has_discount = 'False'
ORDER BY total_recharge DESC

-- 13. List customers who used Instagram the most but had below-average data usage.

SELECT du.customer_id, c.name, ROUND(AVG(gb_used):: NUMERIC ,2) AS avg_data_use
FROM customers AS c
JOIN data_usager AS du
ON du.customer_id = c.customer_id 
WHERE app_most_used = 'Instagram'
GROUP BY du.customer_id, c.name
HAVING AVG(gb_used)<= ( SELECT AVG(gb_used)
						FROM data_usager ) 
ORDER BY avg_data_use DESC

-- 14. Which plan_type (Monthly, Quarterly, Annual) generated the highest total revenue?

SELECT plan_type, SUM(recharge_amount) AS total_amount
FROM recharges
GROUP BY plan_type
ORDER BY total_amount DESC

-- 15. Show customers who never recharged but have data usage records.  

SELECT DISTINCT du.customer_id
FROM data_usager AS du
LEFT JOIN recharges AS r
ON du.customer_id = r.customer_id 
WHERE r.customer_id IS NULL

-- 16. Which cities have the highest average recharge amount per customer?

SELECT c.city, ROUND(AVG(recharge_amount):: NUMERIC ,2) AS avg_amount
FROM customers AS c
JOIN recharges AS r
ON r.customer_id = c.customer_id 
GROUP BY c.city
ORDER BY avg_amount DESC

-- 🔹 Tricky / Analytical (Q17–20)
-- 17. Detect customers whose total GB usage exceeded their average plan validity (based on recharge).

WITH total_data AS (
    SELECT customer_id, SUM(gb_used) AS total_gb_used
    FROM data_usager
    GROUP BY customer_id
),
avg_validity AS (
    SELECT customer_id, AVG(validity_days) AS avg_validity
    FROM recharges
    GROUP BY customer_id
)

SELECT td.customer_id, td.total_gb_used, av.avg_validity
FROM total_data td
JOIN avg_validity av ON td.customer_id = av.customer_id
WHERE td.total_gb_used > av.avg_validity;

-- 18. Which app had the highest average GB usage per session in roaming mode?

SELECT app_most_used, ROUND(AVG(gb_used):: NUMERIC ,2) AS total_data_used
FROM data_usager
WHERE is_roaming = 'True'
GROUP BY app_most_used
ORDER BY total_data_used DESC

-- 19. List customers who were referred and later referred others (multi-level referrers). 	

SELECT referred_by, COUNT(referred_by) AS total_referred
FROM customers 
WHERE referred_by IS NOT NULL
GROUP BY referred_by
ORDER BY total_referred DESC

-- 20. Among customers who joined before July 2023 and are still active, who has the highest total recharge spend and average daily GB usage?

SELECT du.customer_id, c.name, c.join_date, SUM(r.recharge_amount) AS total_spend, ROUND(AVG(gb_used):: NUMERIC, 2) AS avg_data_used
FROM customers AS c
JOIN data_usager AS du
ON c.customer_id = du.customer_id 
JOIN recharges AS r
ON r.customer_id = du.customer_id
WHERE is_active = 'True' AND join_date < '2023-07-01'
GROUP BY du.customer_id, c.name, c.join_date
ORDER BY total_spend DESC


