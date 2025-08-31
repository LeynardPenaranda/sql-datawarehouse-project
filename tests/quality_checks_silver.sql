/* ============================================================
   CHECKS FOR TABLE: silver.crm_cust_info
   ============================================================ */

-- Check for duplicates (must be unique cst_id)
SELECT cst_id, COUNT(*) 
FROM silver.crm_cust_info 
GROUP BY cst_id 
HAVING COUNT(*) > 1 OR cst_id IS NULL;

-- View all rows
SELECT * 
FROM silver.crm_cust_info;

-- Check for unwanted spaces in names
-- Expectation: Must return no rows
SELECT cst_lastname 
FROM silver.crm_cust_info 
WHERE cst_lastname != TRIM(cst_lastname);

-- Check for standardization & consistency of marital status
SELECT DISTINCT cst_marital_status
FROM silver.crm_cust_info;

-- Fix typo in column name
EXEC sp_rename 'silver.crm_cust_info.cst_material_status', 'cst_marital_status', 'COLUMN';



/* ============================================================
   CHECKS FOR TABLE: bronze.crm_prd_info
   ============================================================ */

-- Check for duplicates in prd_id
SELECT prd_id, COUNT(*) 
FROM bronze.crm_prd_info
GROUP BY prd_id
HAVING COUNT(*) > 1 OR prd_id IS NULL;

-- Check for unwanted spaces in product name
SELECT prd_nm
FROM bronze.crm_prd_info
WHERE prd_nm != TRIM(prd_nm);

-- Check for negative or NULL product cost
SELECT prd_cost
FROM bronze.crm_prd_info
WHERE prd_cost < 0 OR prd_cost IS NULL;

-- Check for cardinality of prd_line
SELECT DISTINCT prd_line 
FROM bronze.crm_prd_info;

-- Check invalid date orders
SELECT * 
FROM bronze.crm_prd_info
WHERE prd_end_dt < prd_start_dt;

-- Clean date flow with LEAD window function
SELECT
    prd_id,
    prd_key,
    prd_nm,
    prd_start_dt,
    prd_end_dt,
    DATEADD(DAY, -1, LEAD(prd_start_dt) 
        OVER (PARTITION BY prd_key ORDER BY prd_start_dt)) AS prd_end_dt_test
FROM bronze.crm_prd_info
WHERE prd_key IN ('AC-HE-HL-U509-R', 'AC-HE-HL-U509');



/* ============================================================
   CHECKS FOR TABLE: bronze.crm_sales_details
   ============================================================ */

-- Check & clean invalid sales due dates
SELECT NULLIF(sls_due_dt, 0) AS sls_due_dt
FROM bronze.crm_sales_details
WHERE sls_due_dt <= 0 OR LEN(sls_due_dt) != 8 OR sls_due_dt > 20500101;

-- Check for invalid order vs. ship vs. due dates
SELECT * 
FROM bronze.crm_sales_details
WHERE sls_order_dt > sls_ship_dt OR sls_order_dt > sls_due_dt;

-- Check & clean consistency between SALES, QUANTITY, and PRICE
-- Rule: sales = quantity * price, no NULL, 0, or negative values
SELECT DISTINCT
    sls_sales AS old_sls_sales,
    sls_quantity,
    sls_price AS old_sls_price,
    CASE
        WHEN sls_sales IS NULL OR sls_sales <= 0 
             OR sls_sales != sls_quantity * ABS(sls_price)
        THEN sls_quantity * ABS(sls_price)
        ELSE sls_sales
    END AS sls_sales,
    CASE
        WHEN sls_price IS NULL OR sls_price <= 0
        THEN sls_sales / NULLIF(sls_quantity, 0)
        ELSE sls_price
    END AS sls_price
FROM bronze.crm_sales_details
WHERE sls_sales != sls_quantity * sls_price
   OR sls_sales IS NULL 
   OR sls_quantity IS NULL 
   OR sls_price IS NULL
   OR sls_sales <= 0 
   OR sls_quantity <= 0 
   OR sls_price <= 0
ORDER BY sls_sales, sls_quantity, sls_price;



/* ============================================================
   CHECKS FOR TABLE: bronze.erp_cust_az12
   ============================================================ */

-- Check for invalid birthdates (before 1924 or in the future)
SELECT DISTINCT bdate
FROM bronze.erp_cust_az12
WHERE bdate < '1924-01-01' OR bdate > GETDATE();

-- Check cardinality of gender values
SELECT DISTINCT gen
FROM bronze.erp_cust_az12;



/* ============================================================
   CHECKS FOR TABLE: bronze.erp_loc_a101
   ============================================================ */

-- Check low cardinality / normalization issues in country codes
SELECT DISTINCT cntry
FROM bronze.erp_loc_a101;



/* ============================================================
   CHECKS FOR TABLE: bronze.erp_px_cat_g1v2
   ============================================================ */

-- Check for unwanted spaces in category, subcategory, maintenance columns
SELECT * 
FROM bronze.erp_px_cat_g1v2
WHERE cat != TRIM(cat) 
   OR subcat != TRIM(subcat)  
   OR maintenance != TRIM(maintenance);

