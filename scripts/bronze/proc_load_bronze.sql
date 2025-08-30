/*
================================================================================
Stored Procedures: Load Bronze Layer (Source -> Bronze)
================================================================================
Script Purpose:
   This stored procedures loads data into the 'bronze' schema from external CSV files.
   It performs the following actions:
  - Truncates the bronze tables before loading data.
  - Uses the "BULK INSERT" command to load the data from the csv files to bronze tables.

Parameters:
  None.
 This stored procedures does not accept any parameters or return any values.

Usage Example:
  EXEC bronze.load_bronze; ( This is the name of the procedure, created below 'bronze.load_bronze' ) 
*/


CREATE OR ALTER PROCEDURE bronze.load_bronze AS 
BEGIN
	DECLARE @start_time DATETIME, @end_time DATETIME, @start_batch DATETIME, @end_batch DATETIME;
	BEGIN TRY
		SET @start_batch = GETDATE();
		PRINT '================================================================================';
		PRINT 'Loading Bronze Layer :)'
		PRINT '================================================================================';
	
		PRINT '================================================================================';
		PRINT 'Loading CRM Tables';
		PRINT '--------------------------------------------------------------------------------';

		PRINT '>> Truncating Table: bronze.crm_cust_info';
		TRUNCATE TABLE bronze.crm_cust_info;

		PRINT '>> Inserting Data Into: bronze.crm_cust_info';

		SET @start_time = GETDATE();
		BULK INSERT bronze.crm_cust_info
		FROM 'C:\Users\ADMIN\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\cust_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> LOAD DURATION: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '---------------------------------------------------------------------------------------------';

		
		PRINT '>> Truncating Table: bronze.crm_prd_info';
		TRUNCATE TABLE bronze.crm_prd_info;

		PRINT '>> Inserting Data Into: bronze.crm_prd_info';

		SET @start_time = GETDATE();
		BULK INSERT bronze.crm_prd_info
		FROM 'C:\Users\ADMIN\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\prd_info.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> LOAD DURATION: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '---------------------------------------------------------------------------------------------';


		PRINT '>> Truncating Table: bronze.crm_sales_details';
		TRUNCATE TABLE bronze.crm_sales_details;

		PRINT '>> Inserting Data Into: bronze.crm_sales_details';

		SET @start_time = GETDATE();
		BULK INSERT bronze.crm_sales_details
		FROM 'C:\Users\ADMIN\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_crm\sales_details.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> LOAD DURATION: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '---------------------------------------------------------------------------------------------';

		PRINT '================================================================================';
		PRINT 'Loading ERP Tables';
		PRINT '--------------------------------------------------------------------------------';

		PRINT '>> Truncating Table: bronze.erp_cust_az12';
		TRUNCATE TABLE bronze.erp_cust_az12;

		PRINT '>> Inserting Data Into: bronze.erp_cust_az12';

		SET @start_time = GETDATE();
		BULK INSERT bronze.erp_cust_az12
		FROM 'C:\Users\ADMIN\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\CUST_AZ12.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> LOAD DURATION: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '---------------------------------------------------------------------------------------------';


		PRINT '>> Truncating Table: bronze.erp_loc_a101';
		TRUNCATE TABLE bronze.erp_loc_a101;

		PRINT '>> Inserting Data Into: bronze.erp_loc_a101';

		SET @start_time = GETDATE();
		BULK INSERT bronze.erp_loc_a101
		FROM 'C:\Users\ADMIN\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\LOC_A101.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> LOAD DURATION: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '---------------------------------------------------------------------------------------------';


		PRINT '>> Truncating Table: bronze.erp_px_cat_g1v2';
		TRUNCATE TABLE bronze.erp_px_cat_g1v2;

		PRINT '>> Inserting Data Into: bronze.erp_px_cat_g1v2';
		SET @start_time = GETDATE();
		BULK INSERT bronze.erp_px_cat_g1v2
		FROM 'C:\Users\ADMIN\Downloads\sql-data-warehouse-project\sql-data-warehouse-project\datasets\source_erp\PX_CAT_G1V2.csv'
		WITH (
			FIRSTROW = 2,
			FIELDTERMINATOR = ',',
			TABLOCK
		);
		SET @end_time = GETDATE();
		PRINT '>> LOAD DURATION: ' + CAST(DATEDIFF(second, @start_time, @end_time) AS NVARCHAR) + ' seconds';
		PRINT '---------------------------------------------------------------------------------------------';
		SET @end_batch = GETDATE();
		PRINT '=================================';
		PRINT 'Loading Bronze Layer is Completed';
		PRINT '  - TOTAL Load Duration: ' + CAST(DATEDIFF(second, @start_batch, @end_batch) AS NVARCHAR) + ' seconds';
		PRINT '=================================';
	END TRY
	BEGIN CATCH
		PRINT '============================================================================';
		PRINT 'ERROR OCCURED DURING LOADING BRONZE LAYER';
		PRINT 'Error Message: ' +  ERROR_MESSAGE();
		PRINT 'Error Message Number: '+  CAST(ERROR_NUMBER() AS NVARCHAR);
		PRINT 'Error Message: ' + CAST(ERROR_STATE() AS NVARCHAR);
		PRINT '============================================================================';
	END CATCH
END
