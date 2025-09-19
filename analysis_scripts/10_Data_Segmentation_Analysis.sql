/*
===============================================================================
Data Segmentation Analysis
===============================================================================
Purpose:
    - To group data into meaningful categories for targeted insights.
    - For customer segmentation, product categorization, or regional analysis.

SQL Functions Used:
    - CASE: Defines custom segmentation logic.
    - GROUP BY: Groups data into segments.
===============================================================================
*/

-- DATA SEGMENTATION
-- Segment products into cost ranges and count how many products fall into each segment
WITH product_segments AS ( 
SELECT 
product_key,
product_name,
product_cost,
CASE WHEN product_cost < 100 THEN 'Below 100'
	 WHEN product_cost BETWEEN 100 and 500 THEN '100-500'
	 WHEN product_cost BETWEEN 500 and 1000 THEN '500-1000'
	 ELSE 'Above 1000'
END AS cost_range 
FROM gold.dim_products)

SELECT
cost_range,
COUNT(product_key) AS total_products
FROM product_segments
GROUP BY cost_range
ORDER BY total_products DESC;

/* Group customers into 3 segments based on their spending behavior:
	- VIP: at least 12 months of history and spending more than $5000
	- Regular: at least 12 months of history and spending less than $5000
	- New: lifespan less than 12 months
   And find the total numbers of customers by each group.
 */
-- Label each customer as VIP, Regular or New
WITH customer_spending AS (
SELECT
c.customer_key,
SUM(f.sales_amount) AS total_spending,
MIN(order_date) AS first_order,
MAX(order_date) AS last_order,
DATEDIFF (month, MIN(order_date), MAX(order_date)) AS lifespan
FROM gold.fact_sales AS f
LEFT JOIN gold.dim_customers as c
ON f.customer_key = c.customer_key
GROUP BY c.customer_key
)
SELECT 
customer_segment,
COUNT(customer_key) AS total_customers
FROM(
	SELECT
	customer_key,
	CASE WHEN lifespan >= 12 AND total_spending > 5000 THEN 'VIP'
		 WHEN lifespan >= 12 AND total_spending <= 5000 THEN 'Regular'
		 ELSE 'New'
	END AS customer_segment
	FROM customer_spending ) AS segmented_customers
GROUP BY customer_segment
ORDER BY total_customers DESC;

/*
SELECT
customer_key,
total_spending,
lifespan,
CASE WHEN lifespan >= 12 AND total_spending > 5000 THEN 'VIP'
	 WHEN lifespan >= 12 AND total_spending <= 5000 THEN 'Regular'
	 ELSE 'New'
END AS customer_segment
FROM customer_spending
-- Find the total number of customers from each group
WITH customer_spending AS (
SELECT
c.customer_key,
SUM(f.sales_amount) AS total_spending,
MIN(order_date) AS first_order,
MAX(order_date) AS last_order,
DATEDIFF (month, MIN(order_date), MAX(order_date)) AS lifespan
FROM gold.fact_sales AS f
LEFT JOIN gold.dim_customers as c
ON f.customer_key = c.customer_key
GROUP BY c.customer_key
)
SELECT 
customer_segment,
COUNT(customer_key) AS total_customers
FROM(
	SELECT
	customer_key,
	CASE WHEN lifespan >= 12 AND total_spending > 5000 THEN 'VIP'
		 WHEN lifespan >= 12 AND total_spending <= 5000 THEN 'Regular'
		 ELSE 'New'
	END customer_segment
	FROM customer_spending )t
GROUP BY customer_segment
ORDER BY total_customers DESC
*/
