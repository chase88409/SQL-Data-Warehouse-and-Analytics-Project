/*
+++++++++++++++++++++++++++++++++
Quality Checks for the Gold Layer
+++++++++++++++++++++++++++++++++
Purpose:
	This script does quality checks to validate the integrity, consistency,
	and accuracy of Gold Layer. The checks are:
	- Uniqueness of surrogate keys in dimension tables
	- Referential integrity between fact and dimension tables.
	- Validation of relationships in the data model for anaylytic purposes.

Usage Notes:
	- Investigates and resolves any discrepancies found during the checks.
===========================================================================
*/

--Data integration check and fix with multiple columns holding similar info
--that does not match up (ex.gender)

SELECT DISTINCT
	ci.cst_gndr,
	ca.gen,
	CASE WHEN ci.cst_gndr != 'n/a' THEN ci.cst_gndr -- CRM is the Master for gender Info
		ELSE COALESCE(ca.gen, 'n/a')
	END AS new_gen
FROM silver.crm_cust_info AS ci
LEFT JOIN silver.erp_cust_az12 AS ca
ON ci.cst_key = ca.cid
LEFT JOIN silver.erp_loc_a101 AS la
ON ci.cst_key = la.cid
ORDER BY 1,2

-- Foreign Key Integrity (Dimensions) should get No results
SELECT * FROM gold.fact_sales AS f
LEFT JOIN gold.dim_customers AS c
ON c.customer_key = f.customer_key
LEFT JOIN gold.dim_products AS p
ON p.product_key = f.product_key
WHERE p.product_key IS NULL OR c.customer_key IS NULL

-- Check for uniqueness of product key in gold.dim_products
-- Expects No Results
SELECT
	product_key,
	COUNT(*) AS duplicate_count
FROM gold.dim_products
GROUP BY product_key
HAVING COUNT(*) > 1;

-- Check for uniqueness of product key in gold.dim_customers
-- Expects No Results
SELECT
	customer_key,
	COUNT(*) AS duplicate_count
FROM gold.dim_customers
GROUP BY customer_key
HAVING COUNT(*) > 1;
