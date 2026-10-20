USE Project_180_DC__supply_chain_management
GO

CREATE OR ALTER PROCEDURE bronze.load_bronze
AS
BEGIN
    SET NOCOUNT ON;

    --========================================================================================
    -- CREATING BRONZE LAYER TABLES
    --========================================================================================
    -- customer_orders
    IF OBJECT_ID('bronze.customer_orders','U')  IS NOT NULL
        DROP TABLE bronze.customer_orders ;

    CREATE TABLE bronze.customer_orders(
        order_id VARCHAR(50) NULL,
        store_id VARCHAR(50) NULL,
        sku_id   VARCHAR(50) NULL,
        quantity_ordered VARCHAR(50) NULL,
        order_date  VARCHAR(50) NULL
    ) ON [PRIMARY]



    --===== Daily_inventory sanpshot================================
    IF OBJECT_ID('bronze.inventory_daily_snapshot','U')  IS NOT NULL
        DROP TABLE bronze.inventory_daily_snapshot ;

    CREATE TABLE bronze.inventory_daily_snapshot(
        snapshot_id VARCHAR(50) NULL,
        warehouse_id VARCHAR(50) NULL,
        sku_id   VARCHAR(50) NULL,
        order_date  VARCHAR(50) NULL,
        stock_level VARCHAR(50) NULL
    ) ON [PRIMARY]
    
    --======purchase order=====================================================================
    IF OBJECT_ID('bronze.retail_sales','U') is not null
        DROP TABLE bronze.retail_sales ;
    CREATE TABLE bronze.retail_sales (
        sale_id VARCHAR(50) NULL,
        store_id VARCHAR(50) NULL,
        sku_id VARCHAR(50) NULL,
        sale_date VARCHAR(50) NULL ,
        sold_units VARCHAR(50) NULL,
        selling_price VARCHAR(50) NULL,
        revenue VARCHAR(50) NULL
    ) ON [PRIMARY]
    
    --==============retail_sales=====================================
    IF OBJECT_ID('bronze.retail_sales','U') is not null
        DROP TABLE bronze.retail_sales ;
    CREATE TABLE bronze.retail_sales (
        sale_id VARCHAR(50) NULL,
        store_id VARCHAR(50) NULL,
        sku_id VARCHAR(50) NULL,
        sale_date VARCHAR(50) NULL ,
        sold_units VARCHAR(50) NULL,
        selling_price VARCHAR(50) NULL,
        revenue VARCHAR(50) NULL
    ) ON [PRIMARY]
    
    --============routes_carrier============================================================

    IF OBJECT_ID('bronze.routes_carrier','U') is not null
        DROP TABLE bronze.routes_carrier ;
    CREATE TABLE bronze.routes_carrier (
        root_id VARCHAR(50) NULL,
        carrier VARCHAR(50) NULL,
        source_warehouse VARCHAR(50) NULL,
        destination_city VARCHAR(50) NULL,
        avg_transit_time VARCHAR(50) NULL
    ) ON [PRIMARY]
   
    --======================Shipment=========================================

    IF OBJECT_ID('bronze.Shipment','U') is not null
        DROP TABLE bronze.Shipment ;
    CREATE TABLE bronze.Shipment (
        shipment_id VARCHAR(50) NULL,
        warehouse_id VARCHAR(50) NULL,
        sku_id VARCHAR(50) NULL,
        quantity_shipped VARCHAR(50) NULL,
        ship_date VARCHAR(50) NULL ,
        arrival_date VARCHAR(50) NULL,
        lane  VARCHAR(50) NULL
    ) ON [PRIMARY]
    
    --================_shipment_=====================================
    IF OBJECT_ID('bronze.Shipment_','U') is not null
        DROP TABLE bronze.Shipment_ ;
    CREATE TABLE bronze.shipment_ (
        shipment_id VARCHAR(50) NULL,
        po_id VARCHAR(50) NULL,
        supplier_id VARCHAR(50) NULL,
        warehouse_id VARCHAR(50) NULL,
        sku_id VARCHAR(50) NULL,
        quantity_shipped VARCHAR(50) NULL,
        ship_date VARCHAR(50) NULL ,
        arrival_date VARCHAR(50) NULL,
        expected_delivery VARCHAR(50) NULL,
        lane VARCHAR(50) NULL
    ) ON [PRIMARY]
    ---============  shipment_to_store  ===========================================================
    IF OBJECT_ID('bronze.shipment_to_store','U') is not null
        DROP TABLE bronze.shipment_to_store ;
    CREATE TABLE bronze.shipment_to_store (
        shipment_id VARCHAR(50) NULL,
        warehouse_id VARCHAR(50) NULL,
        sku_id VARCHAR(50) NULL,
        store_id VARCHAR(50) NULL,
        ship_date VARCHAR(50) NULL ,
        arrival_date VARCHAR(50) NULL,
        quantity_to_store VARCHAR(50) NULL,
        lane  VARCHAR(50) NULL
    ) ON [PRIMARY]
    
    --=================== sku_master =====================================
    IF OBJECT_ID('bronze.sku_master','U') is not null
        DROP TABLE bronze.sku_master ;
    CREATE TABLE bronze.sku_master (
        sku_id VARCHAR(50) NULL,
        sku_name VARCHAR(50) NULL,
        category VARCHAR(50) NULL,
        brand   VARCHAR(50) NULL,
        unit_size VARCHAR(50) NULL,
        mrp VARCHAR(50) NULL
    ) ON [PRIMARY]
  

    --======================= store_master ==========================
    

    IF OBJECT_ID('bronze.store_master','U') is not null
        DROP TABLE bronze.store_master ;
    CREATE TABLE bronze.store_master (
        store_id VARCHAR(50) NULL,
        store_name VARCHAR(50) NULL,
        city VARCHAR(50) NULL,
        region VARCHAR(50) NULL,
        store_format VARCHAR(50) NULL,
        capacity VARCHAR(50) NULL
    ) ON [PRIMARY]


    --===================== suppliers ====================================

    IF OBJECT_ID('bronze.suppliers','U') is not null
        DROP TABLE bronze.suppliers ;
    CREATE TABLE bronze.suppliers (
        supplier VARCHAR(50) NULL,
        supplier_name VARCHAR(50) NULL,
        lead_time_days VARCHAR(50) NULL,
        reliability_score VARCHAR(50) NULL
    ) ON [PRIMARY]
       --======================== warehouse =============================
    
    IF OBJECT_ID('bronze.warehouse','U') is not null
        DROP TABLE bronze.warehouse ;
    CREATE TABLE bronze.warehouse (
        warehouse_id VARCHAR(50) NULL,
        city VARCHAR(50) NULL,
        corrected_state VARCHAR(50) NULL,
        capacity VARCHAR(50) NULL

    ) ON [PRIMARY]
    
    --========================= warehouse inbound =====================

    IF OBJECT_ID('bronze.warehouse_inbound','U') is not null
        DROP TABLE bronze.warehouse_inbound ;
    CREATE TABLE bronze.warehouse_inbound (
        inbound_id VARCHAR(50) NULL,
        warehouse_id VARCHAR(50) NULL,
        sku_id VARCHAR(50) NULL,
        quantity VARCHAR(50) NULL,
        inbound_date VARCHAR(50) NULL

    ) ON [PRIMARY]


    --============  warehouse_outbound  ===================================
    
    IF OBJECT_ID('bronze.warehouse_outbound','U') is not null
        DROP TABLE bronze.warehouse_outbound ;
    CREATE TABLE bronze.warehouse_outbound (
        outbound_id VARCHAR(50) NULL,
        warehouse_id VARCHAR(50) NULL,
        sku_id VARCHAR(50) NULL,
        quantity VARCHAR(50) NULL,
        outbound_date VARCHAR(50) NULL

    ) ON [PRIMARY]

    ---========================================================================================

    --                LOADING CSV FILE INFORMATION FROM CSV TO BRONZE LAYER

    --=============================================================================================

    --customer_orders
    
    BULK INSERT bronze.customer_orders
    FROM 'C:\Users\admin\Desktop\SQL_Everything\180DC SQL project 1\Datasets\customer_orders.csv'
    WITH (
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '0x0a',
        TABLOCK
    );
    

    --==================Daily inventory sanpshot===============================================

    TRUNCATE TABLE bronze.inventory_daily_snapshot;
    BULK INSERT bronze.inventory_daily_snapshot
    FROM 'C:\Users\admin\Desktop\SQL_Everything\180DC SQL project 1\Datasets\Inventory_daily_snapshot.csv'
    WITH (
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '0x0a',
        TABLOCK
    );


    -- purchase order
    TRUNCATE TABLE bronze.purchase_order
    BULK INSERT bronze.purchase_order
    FROM 'C:\Users\admin\Desktop\SQL_Everything\180DC SQL project 1\Datasets\Purchase_order.csv'
    WITH (
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '0x0a',
        TABLOCK
    );
    --=================retail_sales--===========================================

    TRUNCATE TABLE bronze.retail_sales
    BULK INSERT bronze.retail_sales
    FROM 'C:\Users\admin\Desktop\SQL_Everything\180DC SQL project 1\Datasets\RetailSales.csv'
    WITH (
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '0x0a',
        TABLOCK
    );
    --========================routes_carrier=====================================================
    TRUNCATE TABLE bronze.routes_carrier
    BULK INSERT bronze.routes_carrier
    FROM 'C:\Users\admin\Desktop\SQL_Everything\180DC SQL project 1\Datasets\routes_carrier.csv'
    WITH (
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '0x0a',
        TABLOCK
    );

    --====================Shipment==============================
    TRUNCATE TABLE bronze.Shipment
    BULK INSERT bronze.Shipment
    FROM 'C:\Users\admin\Desktop\SQL_Everything\180DC SQL project 1\Datasets\Shipment.csv'
    WITH (
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '0x0a',
        TABLOCK
    );
    --===================== shipment_ ======================================================
    BULK INSERT bronze.shipment_
    FROM 'C:\Users\admin\Desktop\SQL_Everything\180DC SQL project 1\Datasets\Shipment_.csv'
    WITH (
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '0x0a',
        TABLOCK
    );
    --================================== shipment_to_store ====================================

    BULK INSERT bronze.shipment_to_store
    FROM 'C:\Users\admin\Desktop\SQL_Everything\180DC SQL project 1\Datasets\Shipment_to_store.csv'
    WITH (
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '0x0a',
        TABLOCK
    );
    --=================================== sku_master ======================================
    BULK INSERT bronze.sku_master
    FROM 'C:\Users\admin\Desktop\SQL_Everything\180DC SQL project 1\Datasets\sku_master.csv'
    WITH (
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '0x0a',
        TABLOCK
    );
    --=============================store_master================================================

    BULK INSERT bronze.store_master
    FROM 'C:\Users\admin\Desktop\SQL_Everything\180DC SQL project 1\Datasets\store_master.csv'
    WITH (
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '0x0a',
        TABLOCK
    );

    --===================================  suppliers =========================================
    BULK INSERT bronze.suppliers
    FROM 'C:\Users\admin\Desktop\SQL_Everything\180DC SQL project 1\Datasets\suppliers.csv'
    WITH (
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '0x0a',
        TABLOCK
    );
    --================================== warehouse ==================
    BULK INSERT bronze.warehouse
    FROM 'C:\Users\admin\Desktop\SQL_Everything\180DC SQL project 1\Datasets\warehouse.csv'
    WITH (
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '0x0a',
        TABLOCK
    );

    --=======================WArehouse inbound ============================


    BULK INSERT bronze.warehouse_inbound
    FROM 'C:\Users\admin\Desktop\SQL_Everything\180DC SQL project 1\Datasets\warehouse_inbound.csv'
    WITH (
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '0x0a',
        TABLOCK
    );
    --========================= warehouse outbound ==============================
    BULK INSERT bronze.warehouse_outbound
    FROM 'C:\Users\admin\Desktop\SQL_Everything\180DC SQL project 1\Datasets\warehouse_outbound.csv'
    WITH (
        FIRSTROW = 2,
        FIELDTERMINATOR = ',',
        ROWTERMINATOR = '0x0a',
        TABLOCK
    );

END;
GO

EXEC bronze.load_bronze;
GO
