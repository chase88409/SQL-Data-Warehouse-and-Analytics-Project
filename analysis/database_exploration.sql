/*
===============================================================================
Database Exploration
===============================================================================
Purpose:
    - To explore the structure of the database, including the list of tables and their schemas.
    - To inspect the columns and metadata for specific tables.

Table Used:
    - INFORMATION_SCHEMA.TABLES
    - INFORMATION_SCHEMA.COLUMNS
===============================================================================
*/

-- Explore all objects in the Database
SELECT * FROM INFORMATION_SCHEMA.TABLES
-- Explore all Columns in the Database
SELECT * FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'dim_customers'
