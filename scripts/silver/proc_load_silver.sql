/*
===============================================================================
Stored Procedure: Load Silver Layer (Bronze -> Silver)
===============================================================================
Script Purpose:
    This stored procedure performs the ETL (Extract, Transform, Load) process to 
    populate the 'silver' schema tables from the 'bronze' schema.
	Actions Performed:
		- Truncates Silver tables.
		- Inserts transformed and cleansed data from Bronze into Silver tables.
		
Parameters:
    None. 
	  This stored procedure does not accept any parameters or return any values.

Usage Example:
    EXEC Silver.load_silver;
===============================================================================
*/

-- This creates a procedure for all the tables. NOTE: This procedure clean, check, load the data to its designated tables.
EXEC silver.load_silver
GO
CREATE OR ALTER PROCEDURE silver.load_silver AS
BEGIN
    PRINT '>> Truncating the table: silver.crm_cust_info'
    TRUNCATE TABLE silver.crm_cust_info
    PRINT '>> Inserting Data into: silver.crm_cust_info'

    INSERT INTO silver.crm_cust_info(
	    cst_id,
	    cst_key,
	    cst_firstname,
	    cst_lastname,
	    cst_marital_status,
	    cst_gndr,
	    cst_create_date

    )

    -- Clean the bronze table
    SELECT 
        cst_id,
        cst_key,
        -- This Remove the Unwanted Spaces from the selected columns
        TRIM(cst_firstname) AS cst_firstname,
        TRIM(cst_lastname) AS cst_lastname,

        -- This part is data normalization & data standardization by converting the data to meaningful descritions
        CASE 
            WHEN UPPER(TRIM(cst_material_status)) = 'S' THEN 'Single'
            WHEN UPPER(TRIM(cst_material_status)) = 'M' THEN 'Married'
            -- here we handle the missing data by putting n/a
            ELSE 'n/a'
        END AS cst_marital_status,

        -- Same as here converting the data to meaningful data or by adding more descriptions
        CASE 
            WHEN UPPER(TRIM(cst_gndr)) = 'F' THEN 'Female'
            WHEN UPPER(TRIM(cst_gndr)) = 'M' THEN 'Male'
            -- here we handle the missing data by putting n/a
            ELSE 'n/a' 
        END AS cst_gndr,

        cst_create_date
    FROM (
        -- This parts cleans or remove the duplicates data 
        SELECT
            *,
            ROW_NUMBER() OVER (PARTITION BY cst_id ORDER BY cst_create_date DESC) as flag_last
        FROM bronze.crm_cust_info
    ) t
    WHERE flag_last = 1
      AND NOT (
            cst_id IS NULL 
            AND cst_firstname IS NULL 
            AND cst_lastname IS NULL 
            AND cst_material_status IS NULL 
            AND cst_gndr IS NULL 
            AND cst_create_date IS NULL
      );

    PRINT '>> Truncating the table: silver.crm_prd_info'
    TRUNCATE TABLE silver.crm_prd_info
    PRINT '>> Inserting Data into: silver.crm_prd_info'

    INSERT INTO silver.crm_prd_info (
        prd_id,
        cat_id,
        prd_key,
        prd_nm,
        prd_cost,
        prd_line,
        prd_start_dt,
        prd_end_dt
    )
    -- This check and clean the bronze prd table
    SELECT 
    prd_id,
    REPLACE(SUBSTRING(prd_key, 1, 5), '-', '_') AS cat_id,
    SUBSTRING(prd_key, 7, LEN(prd_key)) AS prd_key,
    prd_nm,
    ISNULL(prd_cost, 0) AS prd_cost,
    CASE UPPER(TRIM(prd_line))
     WHEN 'M' THEN 'Mountain'
     WHEN 'R' THEN 'Road'
     WHEN 'S' THEN 'other Sales'
     WHEN 'T' THEN 'Touring'
     ELSE 'n/a'
    END AS prd_line,
    prd_start_dt,
    DATEADD(DAY, -1, LEAD
    (prd_start_dt) OVER (PARTITION BY prd_key ORDER BY prd_start_dt)) AS prd_end_dt
    FROM bronze.crm_prd_info


    PRINT '>> Truncating the table: silver.crm_sales_details'
    TRUNCATE TABLE silver.crm_sales_details
    PRINT '>> Inserting Data into: silver.crm_sales_details'
    -- After cleaning now we can insert the data from the bronze to silver
    INSERT INTO silver.crm_sales_details (
    sls_ord_num,
    sls_prd_key,
    sls_cust_id,
    sls_order_dt,
    sls_ship_dt,
    sls_due_dt,
    sls_sales,
    sls_quantity,
    sls_price
    )
    -- Cleaned the table
    SELECT 
    sls_ord_num,
    sls_prd_key,
    sls_cust_id,

    CASE
    WHEN sls_order_dt = 0 OR LEN(sls_order_dt) != 8 THEN NULL
    ELSE CAST(CAST(sls_order_dt AS VARCHAR) AS DATE)
    END AS sls_order_dt,

    CASE
    WHEN sls_ship_dt = 0 OR LEN(sls_ship_dt) != 8 THEN NULL
    ELSE CAST(CAST(sls_ship_dt AS VARCHAR) AS DATE)
    END AS sls_ship_dt,

    CASE
    WHEN sls_due_dt = 0 OR LEN(sls_due_dt) != 8 THEN NULL
    ELSE CAST(CAST(sls_due_dt AS VARCHAR) AS DATE)
    END AS sls_due_dt,

    CASE
    WHEN sls_sales IS NULL OR sls_sales <= 0 OR sls_sales != sls_quantity * ABS(sls_price)
    THEN sls_quantity * ABS(sls_price)
    ELSE sls_sales
    END sls_sales,

    sls_quantity,

    CASE
    WHEN sls_price IS NULL OR sls_price <= 0
    THEN sls_sales / NULLIF(sls_quantity, 0)
    ELSE sls_price
    END AS sls_price
    FROM bronze.crm_sales_details


    PRINT '>> Truncating the table: silver.erp_cust_az12'
    TRUNCATE TABLE silver.erp_cust_az12
    PRINT '>> Inserting Data into: silver.erp_cust_az12'

    INSERT INTO silver.erp_cust_az12 (
    cid,
    bdate,
    gen
    )
    SELECT 
    CASE
    WHEN cid LIKE 'NAS%' THEN SUBSTRING(cid, 4, LEN(cid))
    ELSE cid
    END AS cid,

    CASE
    WHEN bdate > GETDATE() THEN NULL
    ELSE bdate
    END AS bdate,

    CASE
    WHEN UPPER(TRIM(gen)) IN ('F', 'FEMALE') THEN 'Female'
    WHEN UPPER(TRIM(gen)) IN ('M', 'MALE') THEN 'Male'
    ELSE 'n/a'
    END AS gen
    FROM bronze.erp_cust_az12

    INSERT INTO silver.erp_loc_a101 
    (cid,cntry)
    SELECT 
    REPLACE(cid, '-', '') AS cid,

    CASE
	    WHEN UPPER(TRIM(cntry)) = 'DE' THEN 'Germany'
	    WHEN UPPER(TRIM(cntry)) IN ('US', 'USA') THEN 'United States'
	    WHEN TRIM(cntry) = '' OR cntry IS NULL THEN 'n/a'
	    ELSE TRIM(cntry)
    END AS cntry
    FROM bronze.erp_loc_a101

    PRINT '>> Truncating the table: silver.erp_px_cat_g1v2 '
    TRUNCATE TABLE silver.erp_px_cat_g1v2 
    PRINT '>> Inserting Data into: silver.erp_px_cat_g1v2 '

    INSERT INTO silver.erp_px_cat_g1v2
    (id,cat,subcat, maintenance)
    SELECT 
    id,
    cat,
    subcat,
    maintenance
    FROM bronze.erp_px_cat_g1v2
END
