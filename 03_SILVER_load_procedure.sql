
USE Project_180_DC__supply_chain_management
GO

CREATE OR ALTER PROCEDURE silver.load_silver
AS
BEGIN

    SET NOCOUNT ON;




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
        IF OBJECT_ID('silver.inventory_daily_snapshot','U')  IS NOT NULL
            DROP TABLE silver.inventory_daily_snapshot ;

        CREATE TABLE silver.inventory_daily_snapshot(
            snapshot_id VARCHAR(50) NULL,
            warehouse_id VARCHAR(50) NULL,
            sku_id   VARCHAR(50) NULL,
            order_date  DATE NULL,
            stock_level INT NULL
        ) ON [PRIMARY]
        

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
        

        --==============routes_carrier==================================================
        
        IF OBJECT_ID('silver.routes_carrier','U') is not null
            DROP TABLE silver.routes_carrier ;
        CREATE TABLE silver.routes_carrier (
            root_id VARCHAR(50) NULL,
            carrier VARCHAR(50) NULL,
            source_warehouse VARCHAR(50) NULL,
            destination_city VARCHAR(50) NULL,
            avg_transit_time INT NULL
        ) ON [PRIMARY]
        
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
        
        --============= shipment_ =====================================
        

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

        --================= suppliers ====================================================
        IF OBJECT_ID('silver.suppliers','U') is not null
            DROP TABLE silver.suppliers ;
        CREATE TABLE silver.suppliers (
            supplier VARCHAR(50) NULL,
            supplier_name VARCHAR(50) NULL,
            lead_time_days INT NULL,
            reliability_score FLOAT NULL

        ) ON [PRIMARY]
        
        --===================== warehouse ===============================================
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

        --=================================================================================================

            -- LOADING CLEAN TABLE INTO SILVER

        --==============================================================================================

        -- CUSTOMER_ORDERS


        INSERT INTO silver.customer_orders (
            order_id,
            store_id,
            sku_id,
            quantity_ordered,
            order_date
        )
        SELECT
            order_id,
            store_id,
            sku_id,
            TRY_CONVERT(INT, quantity_ordered) quantity_ordered,
            TRY_CONVERT(
                DATE,
                REPLACE(
                    REPLACE(
                        REPLACE(
                            LTRIM(RTRIM(order_date)),
                            CHAR(13), ''
                        ),
                        CHAR(10), ''
                    ),
                    CHAR(9), ''
                ),
                105
            ) as order_date
        FROM bronze.customer_orders;
        

        --===========inventory_daily_snapshot=================================
        TRUNCATE TABLE silver.inventory_daily_snapshot
        INSERT INTO silver.inventory_daily_snapshot(
        snapshot_id,
        warehouse_id,
        sku_id,
        order_date,
        stock_level
        )
        select 
            ids.snapshot_id,
            ids.warehouse_id,
            ids.sku_id,
            TRY_CONVERT(DATE, TRIM(ids.order_date), 23) AS order_date,
            TRY_convert(INT,ids.stock_level) as stock_level
        FROM bronze.inventory_daily_snapshot ids

        --===========purchase order--=========================================
        TRUNCATE TABLE silver.purchase_order;
        INSERT INTO silver.purchase_order (
            po_id,
            po_date,
            supplier_id,
            sku_id,
            
            quantity_ordered,
            expected_delivery_date,
            lead_time_days
        )
        SELECT
            po.po_id,
        -- Convert dates (assuming DD-MM-YYYY)
            TRY_CONVERT(
                DATE,
                TRIM(REPLACE(REPLACE(REPLACE(po.po_date, CHAR(13), ''),
                            CHAR(10), ''), CHAR(9), '')),
                105
            ) AS po_date,
            po.sku_id,
            po.supplier_id,

            -- Clean and convert quantity
            TRY_CONVERT(
                INT,
                TRIM(REPLACE(REPLACE(REPLACE(po.quantity_ordered, CHAR(13), ''),
                            CHAR(10), ''), CHAR(9), ''))
            ) AS quantity_ordered,

            -- Convert expected delivery date
            TRY_CONVERT(
                DATE,
                TRIM(REPLACE(REPLACE(REPLACE(po.expected_delivery_date, CHAR(13), ''),
                            CHAR(10), ''), CHAR(9), '')),
                105
            ) AS expected_delivery_date,

            -- Clean and convert lead time
            TRY_CONVERT(
                INT,
                TRIM(REPLACE(REPLACE(REPLACE(po.lead_time_days, CHAR(13), ''),
                            CHAR(10), ''), CHAR(9), ''))
            ) AS lead_time_days
        FROM bronze.purchase_order AS po;

        --==================== retail_sales==========================================

        TRUNCATE table silver.retail_sales;
        INSERT INTO silver.retail_sales(
            sale_id,
            store_id,
            sku_id,
            sale_date,
            sold_units,selling_price,revenue
        )
        SELECT
            rs.sale_id,
            rs.store_id,
            rs.sku_id,
            TRY_CONVERT(DATE, TRIM(rs.sale_date), 23) AS sale_date,
            TRY_CONVERT(INT, TRIM(rs.sold_units)) AS sold_units,
            TRY_CONVERT(DECIMAL(10,2), TRIM(rs.selling_price)) AS selling_price,
            TRY_CONVERT(DECIMAL(12,2), TRIM(rs.revenue)) AS revenue
        FROM bronze.retail_sales AS rs;


        --==================
        TRUNCATE TABLE silver.routes_carrier
        INSERT INTO silver.routes_carrier(
            root_id,
            carrier,
            source_warehouse,
            destination_city,
            avg_transit_time
        )
        SELECT
            root_id,
            carrier,
            source_warehouse,
            destination_city,
            TRY_CONVERT(
                INT,
                REPLACE(
                    REPLACE(
                        REPLACE(TRIM(avg_transit_time), CHAR(13), ''),
                        CHAR(10), ''
                    ),
                    CHAR(9), ''
                )
            ) AS avg_transit_time
        FROM bronze.routes_carrier;

        --===================shipment===================================================

        TRUNCATE TABLE silver.shipment ;
        INSERT INTO silver.shipment(
            shipment_id,
            warehouse_id,
            sku_id,
            quantity_shipped,
            ship_date,
            arrival_date,
            lane
        )
        SELECT
            s.shipment_id,
            s.warehouse_id,
            s.sku_id,
            TRY_CONVERT(INT, TRIM(s.quantity_shipped))AS quantity_shipped,
            TRY_CONVERT(DATE, TRIM(s.ship_date), 23)AS ship_date,
            TRY_CONVERT(DATE, TRIM(s.arrival_date), 23) AS arrival_date,
            s.lane
        FROM bronze.shipment AS s;

        --=========== shipment_ ===============

        TRUNCATE TABLE silver.shipment_;
        INSERT INTO silver.shipment_(
            shipment_id,
            po_id,
            supplier_id,
            warehouse_id,
            sku_id,
            quantity_shipped,
            ship_date,
            arrival_date,
            expected_delivery,
            lane
        )
        SELECT 
            s.shipment_id,
            s.po_id,
            s.supplier_id,
            s.warehouse_id,
            s.sku_id,
            CAST(s.quantity_shipped as INT) as quantity_shipped,
            TRY_CONVERT(DATE,s.ship_date,103) as ship_date,
            TRY_CONVERT(DATE,s.arrival_date,103) as arrival_date,
            TRY_CONVERT(DATE,s.expected_delivery,103) as expected_delivery,
            s.lane
        FROM bronze.shipment_  s

        ---======================= shipment_to_store ================================================


        TRUNCATE TABLE silver.shipment_to_store;
        INSERT INTO silver.shipment_to_store(
        s.shipment_id,
        s.warehouse_id,
        s.sku_id,
        s.store_id,
        ship_date,
        arrival_date,
        quantity_to_store,
        lane
        )
        SELECT 
        s.shipment_id,
        s.warehouse_id,
        s.sku_id,
        s.store_id,
        TRY_CONVERT(DATE, TRIM(ship_date), 23) AS ship_date,
        TRY_CONVERT(DATE, TRIM(arrival_date), 23) AS arrival_date,
        TRY_CONVERT(int,quantity_to_store ) as quantity_to_store,
        lane
        FROM bronze.shipment_to_store s

        --===========================  sku_master ====================================
        TRUNCATE TABLE silver.sku_master
        INSERT INTO silver.sku_master(
            sku_id,
            sku_name,
            category,
            brand,
            unit_size,
            mrp
        )
        SELECT
            sku_id,
            sku_name,
            category,
            brand,
            unit_size,
            TRY_CONVERT(
                INT,
                TRIM(
                    REPLACE(
                        REPLACE(mrp, CHAR(13), ''),
                        CHAR(10), ''
                    )
                )
            ) AS mrp
        FROM bronze.sku_master

        --========================   store_master ==============================================
        TRUNCATE TABLE silver.store_master 
        INSERT INTO silver.store_master (
            store_id,
            store_name,
            city,
            region,
            store_format,
            capacity
        )
        SELECT store_id,
            store_name,
            city,
            region,
            store_format,
            CAST(capacity as INT) as capacity
        FROM bronze.store_master
        ---============================== supplier =====================

        TRUNCATE TABLE silver.suppliers
        INSERT INTO silver.suppliers(
            supplier,
            supplier_name,
            lead_time_days,
            reliability_score
        )
        SELECT 
            s.supplier,
            s.supplier_name,
            s.lead_time_days
        ,TRY_CONVERT( DECIMAL(10,2),TRIM(REPLACE(REPLACE(reliability_score, CHAR(13), ''),CHAR(10), ''))) AS reliability_score
        from bronze.suppliers s

        --================================  warehouse ============================================
        TRUNCATE TABLE silver.warehouse
        INSERT INTO silver.warehouse(
            warehouse_id,
            city,
            corrected_state,
            capacity
        )
        SELECT 
            w.warehouse_id,
            w.city,
            w.corrected_state
        ,TRY_CONVERT( INT,TRIM(REPLACE(REPLACE(capacity, CHAR(13), ''),CHAR(10), ''))) AS capacity
        from bronze.warehouse w

        --========================== warehouse inbound ===================


        TRUNCATE TABLE silver.warehouse_inbound
        INSERT INTO silver.warehouse_inbound(
        inbound_id,
        warehouse_id,
        sku_id,
        quantity,
        inbound_date
        )
        SELECT 
        wi.inbound_id,
        wi.warehouse_id,
        wi.sku_id,
        TRY_CONVERT(int,wi.quantity ) as quantity,
        TRY_CONVERT(DATE, TRIM(inbound_date), 23) AS inbound_date
        FROM bronze.warehouse_inbound wi

        --======================== warehouse outbound ===============================


        TRUNCATE TABLE silver.warehouse_outbound
        INSERT INTO silver.warehouse_outbound(
        outbound_id,
        warehouse_id,
        sku_id,
        quantity,
        outbound_date
        )
        SELECT 
        wo.outbound_id,
        wo.warehouse_id,
        wo.sku_id,
        TRY_CONVERT(int,wo.quantity ) as quantity,
        TRY_CONVERT(DATE, TRIM(outbound_date), 23) AS outbound_date
        FROM bronze.warehouse_outbound wo;

END;
GO

EXEC silver.load_silver;
GO