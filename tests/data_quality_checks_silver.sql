/* 
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
DATA QUALITY CHECKS
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Purpose: This Script has examples of SQL code used in Data Quality checks, used in the 
creation of the Silver Layer.
CHECKS:
		-Null or duplicate primary keys
		-Unwanted Spaces in string fields
		-Data standardization and consistency
		-Invalid date ranges and orders
		-Data consistency between related fields
USAGE NOTES:
		-Run the checks after data loading
		-Investigate and resolve any discrepancies that you find during checks

*/

-- Check for Nulls or Duplicates in Primary Key
-- Expectation: No Results
SELECT 
prd_id,
COUNT(*)
FROM bronze.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL

-- Check for unwanted Spaces
-- Expectation: No results
SELECT cst_firstname
FROM silver.crm_cust_info
WHERE cst_firstname != TRIM(cst_firstname)

-- Data Standardization and Consistency (checking for values in low cardinality columns)
SELECT DISTINCT gen,
FROM bronze.erp_cust_az12

--Check for NULLs or Negative Numbers
--Expectation: No Results
SELECT prd_cost
FROM bronze.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL

-- Check for Invalid Date orders. End date must not be earlier than start date.
SELECT *
FROM bronze.crm_prd_info
WHERE prd_end_dt < prd_start_dt

--Use script to test logic on creating new end dates based on the next start date for each product
SELECT
prd_id,
prd_key,
prd_nm,
prd_start_dt,
prd_end_dt,
LEAD(prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt)-1 AS prd_end_dt_test
FROM bronze.crm_prd_info
WHERE prd_key IN ('AC-HE-HL-U509-R', 'AC-HE-HL-U509')

-- Check for Invalid Dates (when written as an Integer)
SELECT
NULLIF(sls_ship_dt,0) AS sls_ship_dt
FROM bronze.crm_sales_details
WHERE sls_ship_dt <=0 
OR LEN(sls_ship_dt) != 8
OR sls_ship_dt > 20500101
OR sls_ship_dt < 19000101

-- Check data consistency: Between sales, quantity and price where the following must be true:
-- Sales = Quantity * Price  and
-- Values must not be NULL, zero, or negative.
SELECT DISTINCT
sls_sales AS old_sales,
sls_quantity,
sls_price AS old_price,
CASE WHEN sls_sales IS NULL OR sls_sales <=0 OR sls_sales != sls_quantity * ABS(sls_price)
		THEN sls_quantity * ABS(sls_price)
	ELSE sls_sales
END AS sls_sales,
CASE WHEN sls_price IS NULL OR sls_price <= 0
		THEN sls_sales / NULLIF(sls_quantity, 0)
	ELSE sls_price
END AS sls_price
FROM bronze.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
OR sls_sales IS NULL OR sls_quantity IS NULL OR sls_price IS NULL
OR sls_sales <= 0 OR sls_quantity <= 0 OR sls_price <= 0
ORDER BY sls_sales, sls_quantity, sls_price

-- Identify Out of Range Dates for Birth
SELECT DISTINCT
bdate
FROM bronze.erp_cust_az12
WHERE bdate < '1924-01-01' -- Checks for very old customers
	OR bdate > GETDATE()  -- Checks for birthdays in the future

