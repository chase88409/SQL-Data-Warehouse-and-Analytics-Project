/*
===============================================================================
Measures Exploration (Key Metrics)
===============================================================================
Purpose:
    - To calculate aggregated metrics (e.g., totals, averages) for quick insights.
    - To identify overall trends or spot anomalies.

SQL Functions Used:
    - COUNT(), SUM(), AVG()
===============================================================================
*/
/*
-- Find the Total Sales
SELECT SUM(sales_amount) AS total_sales FROM gold.fact_sales
-- Find how many items are sold
SELECT SUM(quantity) AS items_sold FROM gold.fact_sales
-- Find the average selling price
SELECT AVG(price) AS average_price FROM gold.fact_sales
-- Find the total number of orders
SELECT COUNT(order_number) AS number_of_orders FROM gold.fact_sales
SELECT COUNT(DISTINCT order_number) AS distinct_orders FROM gold.fact_sales
-- Find the total number of products
SELECT COUNT(product_name) AS total_products FROM gold.dim_products
SELECT COUNT(DISTINCT(product_name)) AS distinct_products FROM gold.dim_products
-- Find the total number of customers
SELECT COUNT(customer_key) AS number_of_customers FROM gold.dim_customers
-- Find the total number of customers that have placed an order
SELECT COUNT(DISTINCT customer_key) AS total_customers FROM gold.fact_sales;
*/

-- Generate a report that shows all key metrics of the business
SELECT 'Total Sales' AS Measure_Name, SUM(sales_amount) AS measure_value FROM gold.fact_sales
UNION ALL
SELECT 'Total Quantity', SUM(quantity) AS items_sold FROM gold.fact_sales
UNION ALL 
SELECT 'Average Price', AVG(price) AS average_price FROM gold.fact_sales
UNION ALL 
SELECT 'Total Number of Orders', COUNT(order_number) AS number_of_orders FROM gold.fact_sales
UNION ALL
SELECT 'Total Number of Prodcts', COUNT(DISTINCT(product_name)) AS distinct_products FROM gold.dim_products
UNION ALL
SELECT 'Total Number of Customers', COUNT(DISTINCT customer_key) AS total_customers FROM gold.fact_sales
