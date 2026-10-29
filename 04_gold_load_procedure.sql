/*
Supply Chain Management - GOLD LAYER (VIEWS ONLY)
Database: Project_180_DC__supply_chain_management

This script preserves the original joined Gold marts and gives them standard
names (gold.fact_*), while also creating reusable descriptive views (gold.dim_*).
No physical tables are created. Bronze and Silver tables are not modified.

FACT VIEWS (8):
  gold.fact_retail_sales
  gold.fact_customer_orders
  gold.fact_inventory_snapshot
  gold.fact_purchase_orders
  gold.fact_shipment_logistics
  gold.fact_procurement_shipment_performance
  gold.fact_shipments_to_store
  gold.fact_warehouse_movements

DIMENSION VIEWS (5):
  gold.dim_product
  gold.dim_store
  gold.dim_warehouse
  gold.dim_supplier
  gold.dim_route_carrier

The fact views retain the joins from the earlier design. Dimension views provide
reusable standalone reference data. Use the joined fact views directly for
straightforward analysis, or use the fact keys with dimensions in a BI model;
avoid joining a joined fact view to the same dimension again unless needed.

DATA MAPPING NOTE:
The supplied screenshot showed values such as SKU0204 in purchase_order.supplier_id
and SUP075 in purchase_order.sku_id. The purchase-order fact therefore uses the
swapped join mapping observed in that screenshot. If the Silver data was corrected,
change to direct joins:
  po.supplier_id = sup.supplier
  po.sku_id = sku.sku_id
*/

USE Project_180_DC__supply_chain_management;
GO

IF SCHEMA_ID('gold') IS NULL
    EXEC('CREATE SCHEMA gold');
GO

/* ======================================================================
   REUSABLE DIMENSION VIEWS
   These expose descriptive attributes and business keys from Silver masters.
   ====================================================================== */

CREATE OR ALTER VIEW gold.dim_product
AS
SELECT
    sku_id,
    sku_name,
    category,
    brand,
    unit_size,
    mrp
FROM silver.sku_master;
GO

CREATE OR ALTER VIEW gold.dim_store
AS
SELECT
    store_id,
    store_name,
    city,
    region,
    store_format,
    capacity AS store_capacity
FROM silver.store_master;
GO

CREATE OR ALTER VIEW gold.dim_warehouse
AS
SELECT
    warehouse_id,
    city,
    corrected_state AS warehouse_state,
    capacity AS warehouse_capacity
FROM silver.warehouse;
GO

CREATE OR ALTER VIEW gold.dim_supplier
AS
SELECT
    supplier AS supplier_id,
    supplier_name,
    lead_time_days AS supplier_default_lead_time,
    reliability_score
FROM silver.suppliers;
GO

/* No route join is added here: the schema does not establish that
   routes_carrier.root_id matches shipment.lane or another shipment key. */
CREATE OR ALTER VIEW gold.dim_route_carrier
AS
SELECT
    root_id AS route_id,
    carrier,
    source_warehouse,
    destination_city,
    avg_transit_time
FROM silver.routes_carrier;
GO

/* ======================================================================
   JOINED FACT VIEWS (THE EARLIER JOIN LOGIC IS PRESERVED)
   Each view stays at the grain of its main business-event source.
   ====================================================================== */

/* 1. Retail sales: one row per retail_sales source record.
   Store and product joins add context to the sales measures. */
CREATE OR ALTER VIEW gold.fact_retail_sales
AS
SELECT
    rs.sale_id,
    rs.sale_date,
    rs.store_id,
    sm.store_name,
    sm.store_format,
    sm.city AS store_city,
    sm.region,
    sm.capacity AS store_capacity,
    rs.sku_id,
    sku.sku_name,
    sku.category,
    sku.brand,
    sku.unit_size,
    sku.mrp,
    rs.selling_price,
    rs.sold_units,
    rs.revenue,
    sku.mrp - rs.selling_price AS discount_offered,
    CASE
        WHEN sku.mrp > 0
        THEN (sku.mrp - rs.selling_price) * 100.0 / sku.mrp
        ELSE NULL
    END AS discount_percentage
FROM silver.retail_sales AS rs
LEFT JOIN silver.store_master AS sm
    ON rs.store_id = sm.store_id
LEFT JOIN silver.sku_master AS sku
    ON rs.sku_id = sku.sku_id;
GO

/* 2. Customer orders: one row per customer_orders source record.
   Store and product joins add the location and product labels to demand. */
CREATE OR ALTER VIEW gold.fact_customer_orders
AS
SELECT
    co.order_id,
    co.order_date,
    co.store_id,
    sm.store_name,
    sm.store_format,
    sm.city AS store_city,
    sm.region,
    sm.capacity AS store_capacity,
    co.sku_id,
    sku.sku_name,
    sku.category,
    sku.brand,
    sku.unit_size,
    co.quantity_ordered
FROM silver.customer_orders AS co
LEFT JOIN silver.store_master AS sm
    ON co.store_id = sm.store_id
LEFT JOIN silver.sku_master AS sku
    ON co.sku_id = sku.sku_id;
GO

/* 3. Inventory snapshot: one row per snapshot source record.
   Warehouse and product joins add location and SKU context. The source column
   is order_date, exposed as snapshot_date; verify its meaning in Silver. */
CREATE OR ALTER VIEW gold.fact_inventory_snapshot
AS
SELECT
    inv.snapshot_id,
    inv.order_date AS snapshot_date,
    inv.warehouse_id,
    w.city AS warehouse_city,
    w.corrected_state AS warehouse_state,
    w.capacity AS warehouse_capacity,
    inv.sku_id,
    sku.sku_name,
    sku.category,
    sku.brand,
    inv.stock_level
FROM silver.inventory_daily_snapshot AS inv
LEFT JOIN silver.warehouse AS w
    ON inv.warehouse_id = w.warehouse_id
LEFT JOIN silver.sku_master AS sku
    ON inv.sku_id = sku.sku_id;
GO

/* 4. Purchase orders: one row per purchase_order source record.
   The joins are intentionally swapped to match the ID pattern seen in the
   earlier results. Canonical IDs are selected from the matching dimensions. */
CREATE OR ALTER VIEW gold.fact_purchase_orders
AS
SELECT
    po.po_id,
    po.po_date,
    po.expected_delivery_date,
    sup.supplier AS supplier_id,
    sup.supplier_name,
    sup.reliability_score,
    sup.lead_time_days AS supplier_default_lead_time,
    sku.sku_id,
    sku.sku_name,
    sku.category,
    sku.brand,
    po.quantity_ordered,
    po.lead_time_days AS ordered_lead_time
FROM silver.purchase_order AS po
LEFT JOIN silver.suppliers AS sup
    ON po.sku_id = sup.supplier
LEFT JOIN silver.sku_master AS sku
    ON po.supplier_id = sku.sku_id;
GO

/* 5. General shipment logistics: silver.shipment has no expected-date field.
   Warehouse/product joins add context; DATEDIFF computes elapsed calendar days. */
CREATE OR ALTER VIEW gold.fact_shipment_logistics
AS
SELECT
    s.shipment_id,
    s.warehouse_id,
    w.city AS warehouse_city,
    w.corrected_state AS warehouse_state,
    w.capacity AS warehouse_capacity,
    s.sku_id,
    sku.sku_name,
    sku.category,
    s.ship_date,
    s.arrival_date,
    s.lane,
    s.quantity_shipped,
    DATEDIFF(DAY, s.ship_date, s.arrival_date) AS actual_transit_days
FROM silver.shipment AS s
LEFT JOIN silver.warehouse AS w
    ON s.warehouse_id = w.warehouse_id
LEFT JOIN silver.sku_master AS sku
    ON s.sku_id = sku.sku_id;
GO

/* 6. Procurement-linked shipment performance: silver.shipment_ contains PO
   and expected_delivery fields. Supplier, warehouse and product joins add
   descriptive information. DATEDIFF yields transit and delivery variance. */
CREATE OR ALTER VIEW gold.fact_procurement_shipment_performance
AS
SELECT
    s.shipment_id,
    s.po_id,
    s.supplier_id,
    sup.supplier_name,
    sup.reliability_score,
    s.warehouse_id,
    w.city AS warehouse_city,
    w.corrected_state AS warehouse_state,
    s.sku_id,
    sku.sku_name,
    sku.category,
    s.quantity_shipped,
    s.lane,
    s.ship_date,
    s.expected_delivery AS expected_delivery_date,
    s.arrival_date,
    DATEDIFF(DAY, s.ship_date, s.arrival_date) AS actual_transit_days,
    DATEDIFF(DAY, s.expected_delivery, s.arrival_date) AS delivery_variance_days,
    CASE
        WHEN s.arrival_date IS NULL THEN 'Pending Arrival'
        WHEN s.expected_delivery IS NULL THEN 'Expected Date Missing'
        WHEN s.arrival_date < s.expected_delivery THEN 'Early'
        WHEN s.arrival_date = s.expected_delivery THEN 'On Time'
        ELSE 'Delayed'
    END AS delivery_status
FROM silver.shipment_ AS s
LEFT JOIN silver.suppliers AS sup
    ON s.supplier_id = sup.supplier
LEFT JOIN silver.warehouse AS w
    ON s.warehouse_id = w.warehouse_id
LEFT JOIN silver.sku_master AS sku
    ON s.sku_id = sku.sku_id;
GO

/* 7. Warehouse-to-store distribution: one row per shipment_to_store record.
   Joins attach origin warehouse, destination store and product context. */
CREATE OR ALTER VIEW gold.fact_shipments_to_store
AS
SELECT
    sts.shipment_id,
    sts.warehouse_id,
    w.city AS warehouse_city,
    w.corrected_state AS warehouse_state,
    sts.store_id,
    sm.store_name,
    sm.city AS store_city,
    sm.region,
    sm.store_format,
    sts.sku_id,
    sku.sku_name,
    sku.category,
    sku.brand,
    sts.ship_date,
    sts.arrival_date,
    sts.lane,
    sts.quantity_to_store,
    DATEDIFF(DAY, sts.ship_date, sts.arrival_date) AS actual_transit_days
FROM silver.shipment_to_store AS sts
LEFT JOIN silver.warehouse AS w
    ON sts.warehouse_id = w.warehouse_id
LEFT JOIN silver.store_master AS sm
    ON sts.store_id = sm.store_id
LEFT JOIN silver.sku_master AS sku
    ON sts.sku_id = sku.sku_id;
GO

/* 8. Warehouse movements: align inbound and outbound columns with UNION ALL.
   UNION ALL preserves every movement; movement_type tells them apart. */
CREATE OR ALTER VIEW gold.fact_warehouse_movements
AS
SELECT
    'Inbound' AS movement_type,
    wi.inbound_id AS movement_id,
    wi.warehouse_id,
    w.city AS warehouse_city,
    w.corrected_state AS warehouse_state,
    wi.sku_id,
    sku.sku_name,
    sku.category,
    wi.inbound_date AS movement_date,
    wi.quantity
FROM silver.warehouse_inbound AS wi
LEFT JOIN silver.warehouse AS w
    ON wi.warehouse_id = w.warehouse_id
LEFT JOIN silver.sku_master AS sku
    ON wi.sku_id = sku.sku_id
UNION ALL
SELECT
    'Outbound' AS movement_type,
    wo.outbound_id AS movement_id,
    wo.warehouse_id,
    w.city AS warehouse_city,
    w.corrected_state AS warehouse_state,
    wo.sku_id,
    sku.sku_name,
    sku.category,
    wo.outbound_date AS movement_date,
    wo.quantity
FROM silver.warehouse_outbound AS wo
LEFT JOIN silver.warehouse AS w
    ON wo.warehouse_id = w.warehouse_id
LEFT JOIN silver.sku_master AS sku
    ON wo.sku_id = sku.sku_id;
GO

/* Final inventory of Gold views created by this script. */
SELECT TABLE_SCHEMA, TABLE_NAME
FROM INFORMATION_SCHEMA.VIEWS
WHERE TABLE_SCHEMA = 'gold'
  AND (TABLE_NAME LIKE 'fact[_]%' OR TABLE_NAME LIKE 'dim[_]%')
ORDER BY TABLE_NAME;
GO
