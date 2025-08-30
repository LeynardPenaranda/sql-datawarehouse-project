/*
====================================================================================================================================
CREATE Database and Schemas
====================================================================================================================================
Script Purpose:
   This script creates a new Database named 'DataWareHouse' after checking if it already exists.
   if the database exists, it is dropped and recreated. Additionally, the script sets up three schemas 
   within the database: 'bronze', 'silver', 'gold'.

WARNING !!!
  Running this script will drop the entire 'DataWareHouse' database if it exists.
  All the data in the database will be permanently deleted. Proceed with caution
  and ensure you have proper backups before running this script.
*/


USE master;
GO

-- Drop and recreate the 'DataWareHouse' Database
IF EXISTS (SELECT 1 FROM  sys.databases WHERE name = 'DataWareHouse')
BEGIN
  ALTER DATABASE DataWareHouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
  DROP DATABASE DataWareHouse;
END
GO

-- CREATE the 'DataWareHouse' database
CREATE DATABASE DataWareHouse;
GO
  
USE DataWarehouse;
GO

-- CREATE Schemas
CREATE SCHEMA bronze;
GO 
  
CREATE SCHEMA silver;
GO
  
CREATE SCHEMA gold;
GO
