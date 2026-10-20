
USE Project_180_DC__supply_chain_management
GO
-- CREATING silver LAYER TABLES

IF OBJECT_ID('silver.customer_orders','U')  IS NOT NULL
     DROP TABLE silver.customer_orders ;

CREATE TABLE silver.customer_orders(
	order_id VARCHAR(50) NULL,
	store_id VARCHAR(50) NULL,
	sku_id   VARCHAR(50) NULL,
	quantity_ordered INT NULL,
	order_date  DATE NULL
) ON [PRIMARY]

--=======================================inventory_daily_snapshot===============================================

GO

IF OBJECT_ID('silver.inventory_daily_snapshot','U')  IS NOT NULL
     DROP TABLE silver.inventory_daily_snapshot ;

CREATE TABLE silver.inventory_daily_snapshot(
	snapshot_id VARCHAR(50) NULL,
	warehouse_id VARCHAR(50) NULL,
	sku_id   VARCHAR(50) NULL,
	order_date  DATE NULL,
	stock_level INT NULL
) ON [PRIMARY]
GO

--==========================purchase orders=======================================================================
IF OBJECT_ID('silver.purchase_order','U') is not null
	DROP TABLE silver.purchase_order ;
CREATE TABLE silver.purchase_order (
	po_id VARCHAR(50) NULL,
	po_date DATE NULL,
	sku_id VARCHAR(50) NULL,
	supplier_id VARCHAR(50) NULL,
	quantity_ordered INT NULL,
	expected_delivery_date DATE NULL ,
	lead_time_days INT NULL
) ON [PRIMARY]
GO
--==================retail_sales====================================================================================

IF OBJECT_ID('silver.retail_sales','U') is not null
	DROP TABLE silver.retail_sales ;
CREATE TABLE silver.retail_sales (
	sale_id VARCHAR(50) NULL,
	store_id VARCHAR(50) NULL,
     sku_id VARCHAR(50) NULL,
	 sale_date DATE NULL,
    sold_units INT NULL,
	selling_price INT NULL,
	revenue INT NULL ,
	
) ON [PRIMARY]
GO

--==============routes_carrier==================================================
GO
IF OBJECT_ID('silver.routes_carrier','U') is not null
	DROP TABLE silver.routes_carrier ;
CREATE TABLE silver.routes_carrier (
	root_id VARCHAR(50) NULL,
	carrier VARCHAR(50) NULL,
	source_warehouse VARCHAR(50) NULL,
	destination_city VARCHAR(50) NULL,
	avg_transit_time INT NULL
) ON [PRIMARY]
GO
--====================shipment========================

IF OBJECT_ID('silver.shipment','U') is not null
	DROP TABLE silver.shipment ;
CREATE TABLE silver.shipment (
	shipment_id VARCHAR(50) NULL,
	warehouse_id VARCHAR(50) NULL,
	sku_id VARCHAR(50) NULL,
	quantity_shipped INT NULL,
	ship_date DATE NULL ,
	arrival_date DATE NULL,
	lane  VARCHAR(50) NULL
) ON [PRIMARY]
GO
--============= shipment_ =====================================
GO

IF OBJECT_ID('silver.shipment_','U') is not null
	DROP TABLE silver.shipment_ ;
CREATE TABLE silver.shipment_ (
	shipment_id VARCHAR(50) NULL,
	po_id VARCHAR(50) NULL,
	supplier_id VARCHAR(50) NULL,
	warehouse_id VARCHAR(50) NULL,
	sku_id VARCHAR(50) NULL,
	quantity_shipped INT NULL,
	ship_date DATE NULL ,
	arrival_date DATE NULL,
	expected_delivery DATE NULL,
	lane VARCHAR(50) NULL
) ON [PRIMARY]

--======================== shipment_to_store ==================================================

IF OBJECT_ID('silver.shipment_to_store','U') is not null
	DROP TABLE silver.shipment_to_store ;
CREATE TABLE silver.shipment_to_store (
	shipment_id VARCHAR(50) NULL,
	warehouse_id VARCHAR(50) NULL,
	sku_id VARCHAR(50) NULL,
	store_id VARCHAR(50) NULL,
	ship_date DATE NULL ,
	arrival_date DATE NULL,
	quantity_to_store INT NULL,
	lane  VARCHAR(50) NULL
) ON [PRIMARY]
--=======================  sku_master ==========================================
GO
IF OBJECT_ID('silver.sku_master','U') is not null
	DROP TABLE silver.sku_master ;
CREATE TABLE silver.sku_master (
	sku_id VARCHAR(50) NULL,
	sku_name VARCHAR(50) NULL,
	category VARCHAR(50) NULL,
	brand  VARCHAR(50) NULL,
	unit_size VARCHAR(10) NULL,
	mrp FLOAT NULL
) ON [PRIMARY]
--====================== store_master ===============================================
GO

IF OBJECT_ID('silver.store_master','U') is not null
	DROP TABLE silver.store_master ;
CREATE TABLE silver.store_master (
	store_id VARCHAR(50) NULL,
	store_name VARCHAR(50) NULL,
	city VARCHAR(50) NULL,
	region VARCHAR(50) NULL,
	store_format VARCHAR(50) NULL,
	capacity INT NULL
) ON [PRIMARY]

GO
--================= suppliers ====================================================
IF OBJECT_ID('silver.suppliers','U') is not null
	DROP TABLE silver.suppliers ;
CREATE TABLE silver.suppliers (
	supplier VARCHAR(50) NULL,
	supplier_name VARCHAR(50) NULL,
	lead_time_days INT NULL,
	reliability_score FLOAT NULL

) ON [PRIMARY]
GO
--====================== warehouse ===============================================
IF OBJECT_ID('silver.warehouse','U') is not null
	DROP TABLE silver.warehouse ;
CREATE TABLE silver.warehouse (
	warehouse_id VARCHAR(50) NULL,
	city VARCHAR(50) NULL,
	corrected_state VARCHAR(50) NULL,
	capacity INT NULL
) ON [PRIMARY]

--================ warehouse_inbound ==============================================

IF OBJECT_ID('silver.warehouse_inbound','U') is not null
	DROP TABLE silver.warehouse_inbound ;
CREATE TABLE silver.warehouse_inbound (
	inbound_id VARCHAR(50) NULL,
	warehouse_id VARCHAR(50) NULL,
	sku_id VARCHAR(50) NULL,
	quantity INT NULL,
	inbound_date DATE NULL

) ON [PRIMARY]
GO
--==================== warehouse outbound ============================================

IF OBJECT_ID('silver.warehouse_outbound','U') is not null
	DROP TABLE silver.warehouse_outbound ;
CREATE TABLE silver.warehouse_outbound (
	outbound_id VARCHAR(50) NULL,
	warehouse_id VARCHAR(50) NULL,
	sku_id VARCHAR(50) NULL,
	quantity INT NULL,
	outbound_date DATE NULL
) ON [PRIMARY]
GO