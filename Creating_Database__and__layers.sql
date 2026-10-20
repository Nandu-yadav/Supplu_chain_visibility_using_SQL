/*
=============================================================
Create Database and Schemas
=============================================================
Script Purpose:
    This script creates a new database named 'DataWarehouse' after checking if it already exists. 
    If the database exists, it is dropped and recreated. Additionally, the script sets up three schemas 
    within the database: 'bronze', 'silver', and 'gold'.
	
WARNING:
    Running this script will drop the entire 'DataWarehouse' database if it exists. 
    All data in the database will be permanently deleted. Proceed with caution 
    and ensure you have proper backups before running this script.
*/

USE master;
GO

-- Drop and recreate the 'DataWarehouse' database

IF EXISTS (
    SELECT 1
    FROM sys.databases
    WHERE name = 'Project_180_DC__supply_chain_management'
)
BEGIN
    ALTER DATABASE Project_180_DC__supply_chain_management
    SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE Project_180_DC__supply_chain_management;
END;
GO

-- Create the 'DataWarehouse' database
CREATE DATABASE Project_180_DC__supply_chain_management;
GO

USE Project_180_DC__supply_chain_management;
GO

-- Create Schemas

-- Create schemas if they do not exist

IF NOT EXISTS (
    SELECT 1
    FROM sys.schemas
    WHERE name = 'bronze'
)
BEGIN
    EXEC('CREATE SCHEMA bronze');
END;
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.schemas
    WHERE name = 'silver'
)
BEGIN
    EXEC('CREATE SCHEMA silver');
END;
GO

IF NOT EXISTS (
    SELECT 1
    FROM sys.schemas
    WHERE name = 'gold'
)
BEGIN
    EXEC('CREATE SCHEMA gold');
END;
GO

-- Procedures to load tables and keep updated
USE Project_180_DC__supply_chain_management;
GO
EXEC bronze.load_bronze
GO
EXEC silver.load_silver
GO