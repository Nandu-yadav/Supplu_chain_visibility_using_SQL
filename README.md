# End-to-End Supply Chain Analytics & Data Warehouse
### SQL | Data Engineering | Supply Chain Optimization | Business Intelligence

[![SQL Server](https://img.shields.io/badge/SQL%20Server-Database-CC2927?logo=microsoftsqlserver&logoColor=white)](#tech-stack)
[![Data Engineering](https://img.shields.io/badge/Data%20Engineering-ETL%2FELT-blue)](#data-pipeline)
[![Analytics](https://img.shields.io/badge/Analytics-Supply%20Chain-2E8B57)](#business-questions)

An end-to-end data engineering and analytics project designed to help **FreshCart Pvt. Ltd., a fictional consumer goods company, improve supply chain visibility, identify operational inefficiencies, and make data-driven decisions using SQL.**

The project transforms raw supply chain data into structured analytical datasets, calculates operational KPIs, investigates performance bottlenecks, and translates findings into actionable recommendations for inventory, procurement, warehousing, and logistics.

> **Project focus:** Building a reliable analytical foundation and using it to answer real-world supply chain questions—not merely writing SQL queries.

---

## Table of Contents

1. [Business Problem](#1-business-problem)
2. [Project Objectives](#2-project-objectives)
3. [Technology Stack](#3-technology-stack)
4. [Data Architecture](#4-data-architecture)
5. [Data Pipeline](#5-data-pipeline)
6. [Data Model](#6-data-model)
7. [Supply Chain KPIs](#7-supply-chain-kpis)
8. [Business Questions](#8-business-questions)
9. [Key Findings](#9-key-findings)
10. [Business Recommendations](#10-business-recommendations)
11. [Data Quality and Validation](#11-data-quality-and-validation)
12. [Repository Structure](#12-repository-structure)
13. [How to Run the Project](#13-how-to-run-the-project)
14. [Challenges and Engineering Decisions](#14-challenges-and-engineering-decisions)
15. [Limitations and Future Improvements](#15-limitations-and-future-improvements)

---

## 1. Business Problem

FreshCart Pvt. Ltd. operates across multiple factories, regional warehouses, distributors, and retail outlets in India, managing more than 800 SKUs across packaged foods, beverages, home care, and personal care.

As the business expands, its supply chain generates data across purchasing, supplier deliveries, inventory, warehouse operations, transportation, and sales.

However, fragmented data and limited visibility make it difficult to identify the causes of operational inefficiencies.

### Business challenges

- **Delivery performance:** Frequent shipment delays and inconsistent On-Time In-Full (OTIF) performance.
- **Inventory imbalance:** Stockouts in some regions despite sufficient inventory elsewhere.
- **Excess stock:** Slow-moving inventory increases holding costs and the risk of obsolescence.
- **Supplier reliability:** Limited visibility into supplier delivery performance and consistency.
- **Warehouse efficiency:** Unclear inbound/outbound movement patterns and potential bottlenecks.
- **Transportation performance:** Insufficient visibility into delays across routes and carriers.
- **Decision-making:** No unified analytical view of supply chain KPIs.

### The core question

**How can FreshCart use its operational data to identify supply chain bottlenecks, improve inventory availability, and make better procurement and logistics decisions?**

This project addresses that question through SQL-based data transformation, dimensional modeling, KPI development, and evidence-based operational analysis.

## 2. Project Objectives

The project is designed to:

1. Build a structured, reusable SQL data pipeline from raw source data to analytical tables.
2. Clean and standardize inconsistent source data.
3. Design a relational and dimensional data model suitable for reporting.
4. Calculate supply chain KPIs using SQL.
5. Identify supplier, inventory, warehouse, and transportation performance issues.
6. Investigate operational patterns at SKU, warehouse, region, supplier, and carrier levels.
7. Develop recommendations supported by measurable evidence.
8. Document the technical implementation and business reasoning.

## 3. Technology Stack

| Technology | Purpose |
|---|---|
| Microsoft SQL Server | Data storage, transformation, and analytical queries |
| SQL / T-SQL | Joins, CTEs, window functions, aggregations, and stored procedures |
| SQL Server Management Studio / VS Code | SQL development and execution |
| Excel | Initial data inspection and validation, where applicable |
| Power BI | Interactive KPI reporting, where implemented |
| Git and GitHub | Version control and project documentation |
| ERD / schema diagrams | Data model documentation |

*Only tools actually used in the implementation should remain in this list.*

## 4. Data Architecture

The pipeline follows a layered data architecture to separate raw ingestion, data cleaning, and business-ready analytical datasets.

```text
                 SOURCE DATA
                       |
                       v
              +----------------+
              |  BRONZE LAYER  |
              | Raw source data|
              +----------------+
                       |
                       v
              +----------------+
              |  SILVER LAYER  |
              | Cleaned and    |
              | standardized   |
              | operational data|
              +----------------+
                       |
                       v
              +----------------+
              |   GOLD LAYER   |
              | Fact tables    |
              | Dimensions     |
              | Business KPIs  |
              +----------------+
                       |
                       v
              +----------------+
              | Reporting and  |
              | Supply Chain   |
              | Analysis       |
              +----------------+
```

### Bronze layer — Raw data ingestion

**Purpose:** Preserve source data in its original form for traceability and reprocessing.

Typical operations:

- Load source files into raw tables.
- Retain source-level values during ingestion.
- Identify source schemas and data types.
- Record ingestion metadata where implemented.

### Silver layer — Data cleaning and standardization

**Purpose:** Convert raw data into reliable, consistent datasets.

Typical operations:

- Standardize date formats and numeric data types.
- Handle missing, invalid, or malformed values.
- Identify duplicate records.
- Validate product, supplier, warehouse, and order identifiers.
- Apply business rules and document rejected or corrected records.

### Gold layer — Business-ready analytical model

**Purpose:** Organize validated data around the questions the business needs to answer.

Typical operations:

- Create fact and dimension tables.
- Define the grain of each fact table.
- Establish primary keys, foreign keys, and appropriate relationships.
- Calculate reusable business measures.
- Prepare datasets for KPI reporting and deeper analysis.

The Gold layer is the primary interface between the data engineering pipeline and business intelligence.

## 5. Data Pipeline

The project implements a SQL-based ETL/ELT workflow that moves source data through successive transformation stages.

### Pipeline workflow

1. **Ingestion:** Load raw operational datasets into the Bronze layer.
2. **Profiling:** Examine row counts, nulls, duplicates, data types, and identifier consistency.
3. **Cleaning:** Standardize values and resolve data quality issues according to documented rules.
4. **Transformation:** Convert source records into consistent operational datasets in Silver.
5. **Modeling:** Build Gold-layer fact and dimension tables.
6. **Metric development:** Implement reusable SQL calculations for supply chain KPIs.
7. **Validation:** Reconcile record counts, verify joins, and test business rules.
8. **Analysis:** Investigate performance patterns and develop evidence-based recommendations.

### SQL techniques used

- Multi-table joins and relational modeling
- Common Table Expressions (CTEs)
- Window functions and ranking
- Conditional aggregation
- `CASE` expressions
- `TRY_CONVERT` and `TRY_CAST` for controlled type conversion
- Date calculations and time-based analysis
- Stored procedures for reusable transformations, where implemented
- Indexing and query-plan analysis, where tested

## 6. Data Model

The Gold layer is organized using dimensional modeling principles.

The model separates measurable operational events from descriptive business entities, making analysis easier to maintain and extend.

### Dimension tables

| Dimension | Purpose | Example attributes |
|---|---|---|
| `dim_date` | Analyze performance over time | Date, month, quarter, year |
| `dim_product` | Analyze product and SKU performance | Product key, SKU, category |
| `dim_supplier` | Evaluate supplier performance | Supplier key, name, region |
| `dim_warehouse` | Compare warehouse operations | Warehouse key, location, region |
| `dim_region` | Compare regional performance | Region key, region name |
| `dim_carrier` | Analyze transportation performance | Carrier key, carrier name |

### Fact tables

| Fact table | Grain — one row represents | Example measures |
|---|---|---|
| `fact_purchase_orders` | A purchase order line, if the source supports line-level detail | Ordered quantity, received quantity |
| `fact_inventory_snapshot` | A product–warehouse–snapshot-date combination | On-hand quantity, reserved quantity |
| `fact_shipments` | A shipment or shipment line, according to the source grain | Shipped quantity, delivery duration |
| `fact_sales` | A sales order line, if available | Sales quantity, revenue |
| `fact_warehouse_movements` | A recorded inbound or outbound movement | Movement quantity, movement count |

*The actual schema must match the available source data. A table should only be created when the source supports its required grain and measures.*

### Example dimensional relationship

```text
                 dim_product
                      |
                      |
dim_date ---- fact_inventory_snapshot ---- dim_warehouse
                      |
                      |
                  dim_region
```

The final repository includes the actual ERD, join keys, table definitions, grain decisions, and relationship constraints.

## 7. Supply Chain KPIs

KPIs are defined using explicit business rules rather than treated as arbitrary SQL calculations.

| KPI | Definition | Business purpose |
|---|---|---|
| Fill Rate | Quantity fulfilled ÷ quantity requested × 100 | Measures demand fulfillment |
| OTIF | Eligible orders delivered on time and in full ÷ eligible orders × 100 | Measures delivery reliability |
| Order Cycle Time | Delivery timestamp − order creation timestamp | Measures end-to-end order lead time |
| Backorder Quantity | Unfulfilled demand quantity, based on the defined order status and fulfillment rules | Identifies unmet demand |
| Inventory Turnover | Cost of goods sold ÷ average inventory value | Measures inventory efficiency |
| Inventory Ageing | Time inventory has remained in stock, based on available dates | Identifies potentially slow-moving stock |
| Supplier On-Time Rate | Eligible supplier deliveries arriving on time ÷ eligible deliveries × 100 | Evaluates supplier punctuality |
| Warehouse Throughput | Quantity processed or moved over a defined period | Measures warehouse activity |
| Carrier Delay Rate | Eligible shipments delivered late ÷ eligible shipments × 100 | Compares transportation reliability |

### Important metric definitions

**OTIF:** The project defines the order-level eligibility rules, promised delivery date, actual delivery date, and full-quantity condition before calculating the metric.

**Inventory turnover:** The calculation uses compatible valuation units and a clearly defined reporting period. If inventory value or cost of goods sold is unavailable, a quantity-based movement metric should not be mislabeled as financial inventory turnover.

**Fill rate:** The numerator and denominator use compatible units and a consistent level of aggregation. The chosen definition is documented to distinguish line fill rate from order fill rate.

Every KPI has a documented formula, source columns, aggregation grain, treatment of missing data, and SQL implementation.

## 8. Business Questions

The analysis is structured around decisions that a supply chain manager could make.

### A. Inventory optimization

- Which SKUs have high demand but insufficient inventory?
- Which products have the highest proportion of slow-moving stock?
- Which warehouses hold excess stock while other regions experience shortages?
- Which products may be candidates for inter-warehouse stock transfers?
- How do inventory levels and movement change over time?

### B. Supplier performance

- Which suppliers have the lowest on-time delivery rates?
- Which suppliers repeatedly deliver less than the ordered quantity?
- How do supplier lead times vary across products and periods?
- Are delays concentrated among particular suppliers or product categories?

### C. Warehouse operations

- Which warehouses process the highest inbound and outbound volumes?
- Are movement patterns uneven across warehouses?
- Which facilities exhibit unusual processing or movement patterns?
- How do throughput and inventory levels relate to stock availability?

### D. Transportation and delivery

- Which carriers have the highest delay rates?
- Which routes exhibit consistently longer delivery times?
- Does transportation performance vary by region or period?
- How does delivery reliability affect OTIF?

### E. End-to-end supply chain visibility

- At which stage are the largest delays observed?
- Which operational factors are associated with poor order fulfillment?
- Which KPIs require the most urgent attention?
- What operational changes are supported by the data?

## 9. Key Findings

This section presents the most important results obtained from the actual dataset.

Findings are ranked by business relevance, quantified where the data permits, and linked to supporting SQL queries or dashboard views.

### Finding 1 — Inventory imbalance

**Observation:** [Insert the verified finding, including the affected SKUs, warehouses, or regions.]

**Evidence:**
- [Measured inventory or demand value]
- [Comparison period or benchmark]
- [SQL query or dashboard reference]

**Business interpretation:** [Explain the operational issue supported by the evidence.]

**Recommended action:** [Specify a feasible intervention and the KPI that should improve.]

### Finding 2 — Supplier reliability

**Observation:** [Insert the verified supplier performance pattern.]

**Evidence:** [Insert on-time rate, sample size, period, and comparison.]

**Business interpretation:** [Explain the likely operational implications without confusing correlation with causation.]

**Recommended action:** [Specify a supplier review, monitoring process, or procurement action.]

### Finding 3 — Transportation bottleneck

**Observation:** [Insert the verified carrier, route, or regional delay pattern.]

**Evidence:** [Insert delay rate, delivery time, and relevant comparison.]

**Business interpretation:** [Explain how the pattern affects delivery reliability.]

**Recommended action:** [Specify a route or carrier performance improvement.]

### Finding 4 — SKU movement and inventory ageing

**Observation:** [Insert the verified fast-moving and slow-moving SKU patterns.]

**Evidence:** [Insert movement, stock-ageing, or turnover metrics.]

**Business interpretation:** [Explain the consequences for availability and inventory holding.]

**Recommended action:** [Recommend replenishment changes or a review of excess stock.]

*No findings or improvement percentages should be published until the relevant SQL results have been verified.*

## 10. Business Recommendations

Recommendations are prioritized according to impact, feasibility, evidence, and operational risk.

| Priority | Proposed intervention | Success measure |
|---|---|---|
| High | Investigate recurring supplier delivery failures | Supplier on-time rate |
| High | Review regional stock imbalances and transfer feasibility | Stockout rate and inventory availability |
| High | Monitor overdue and partially fulfilled orders | OTIF and fill rate |
| Medium | Review slow-moving stock and replenishment parameters | Inventory ageing and turnover |
| Medium | Compare carrier and route reliability | Carrier delay rate |
| Medium | Standardize recurring supply chain KPI reporting | Reporting consistency and coverage |

These are proposed interventions, not claims of measured improvements.

### How recommendations are evaluated

Each recommendation should identify:

1. The operational problem.
2. The evidence supporting the problem.
3. The proposed intervention.
4. The expected mechanism of improvement.
5. The KPI used to measure success.
6. The implementation constraints and risks.

For example, an inventory transfer recommendation must account for regional demand, transfer costs, lead times, shelf life where relevant, and minimum safety-stock requirements. Excess stock in one location does not automatically mean that transferring it elsewhere is economical.

## 11. Data Quality and Validation

Reliable analysis depends on reliable data.

The project documents data quality checks performed throughout the pipeline.

| Check | Validation objective |
|---|---|
| Schema validation | Confirm expected columns and data types |
| Null checks | Identify missing values in important fields |
| Duplicate checks | Detect duplicate business records using appropriate keys |
| Date validation | Identify invalid dates and inconsistent date sequences |
| Quantity validation | Flag impossible or suspicious quantities |
| Key integrity | Check for missing product, supplier, warehouse, or order references |
| Join validation | Detect unexpected row multiplication or dropped records |
| KPI reconciliation | Compare aggregated metrics with underlying records |
| Transformation reconciliation | Compare source, rejected, and transformed row counts where applicable |

Invalid data is not silently converted into plausible-looking values. Cleaning decisions, rejected records, and assumptions are documented.

## 12. Repository Structure

```text
supply-chain-analytics/
│
├── README.md
│
├── docs/
│   ├── business_problem.md
│   ├── data_dictionary.md
│   ├── data_quality_rules.md
│   ├── kpi_definitions.md
│   ├── methodology.md
│   └── erd.png
│
├── datasets/
│   └── README.md
│
├── sql/
│   ├── bronze/
│   │   └── create_raw_tables.sql
│   │
│   ├── silver/
│   │   ├── clean_purchase_orders.sql
│   │   ├── clean_inventory.sql
│   │   └── clean_shipments.sql
│   │
│   ├── gold/
│   │   ├── create_dimensions.sql
│   │   ├── create_facts.sql
│   │   └── create_kpi_views.sql
│   │
│   ├── analysis/
│   │   ├── inventory_analysis.sql
│   │   ├── supplier_analysis.sql
│   │   ├── warehouse_analysis.sql
│   │   └── transportation_analysis.sql
│   │
│   └── validation/
│       └── data_quality_checks.sql
│
├── dashboard/
│   └── README.md
│
├── reports/
│   ├── executive_summary.pdf
│   └── findings.md
│
└── screenshots/
    ├── dashboard_overview.png
    └── data_model.png
```

*This is a proposed structure. Keep only files and components that actually exist in the repository.*

## 13. How to Run the Project

### Prerequisites

- Microsoft SQL Server or a compatible SQL Server environment.
- SQL Server Management Studio or another SQL client.
- Access to the original source dataset.
- Power BI Desktop, if the dashboard is included.

### Setup

**Step 1 — Clone the repository**

```bash
git clone https://github.com/YOUR_USERNAME/supply-chain-analytics.git
cd supply-chain-analytics
```

**Step 2 — Obtain the dataset**

Follow the dataset instructions in `datasets/README.md`.

If the dataset is not redistributed with the repository, download it from its original source and follow the documented file and table requirements.

**Step 3 — Create the database**

Execute the database and Bronze-layer table creation scripts in the documented order.

**Step 4 — Load the raw data**

Import the source datasets into their corresponding raw tables.

**Step 5 — Execute the transformation pipeline**

Run the Silver-layer cleaning scripts, followed by the Gold-layer modeling scripts.

**Step 6 — Validate the output**

Execute the data quality checks and confirm that the expected tables, keys, and KPI calculations are correct.

**Step 7 — Run the analytical queries**

Execute the scripts in `sql/analysis/` to reproduce the reported findings.

**Step 8 — Open the dashboard**

Open the Power BI report, if included, and connect it to the documented analytical tables or views.

The repository documents execution order, required database settings, and any source-specific configuration.

## 14. Challenges and Engineering Decisions

A strong engineering project documents not only the final output, but also why particular implementation choices were made.

Examples of areas documented during development include:

- **Inconsistent source data types:** How invalid dates, numeric strings, and missing values were handled.
- **Data grain:** How the grain of each fact table was selected to avoid double-counting.
- **Join cardinality:** How one-to-many relationships were handled during aggregations.
- **Metric definitions:** How competing definitions of OTIF, fill rate, and inventory turnover were evaluated.
- **Transformation design:** Why cleaning and business logic were separated into different layers.
- **Query performance:** Which indexes or query changes were tested and what the execution plans showed.
- **Data limitations:** Which business questions could not be answered reliably because the required data was unavailable.

Each documented challenge should include the original problem, the chosen solution, the reasoning, and evidence that the solution worked.

## 15. Limitations and Future Improvements

Potential extensions include:

- Automating scheduled ingestion and transformation.
- Adding incremental data loading and change tracking.
- Implementing historical inventory snapshots for better stock analysis.
- Introducing exception alerts for late deliveries and stockout risks.
- Evaluating replenishment and safety-stock policies using demand variability.
- Adding demand forecasting where sufficient historical data exists.
- Improving query performance through measured indexing and execution-plan analysis.
- Integrating additional operational data sources to improve end-to-end visibility.

These are future improvements, not implemented features unless explicitly demonstrated in the repository.

---

## Conclusion

This project demonstrates how SQL can be used to build a structured supply chain analytics system—from raw operational data to business-ready datasets and measurable performance indicators.

The emphasis is on combining **data engineering fundamentals, sound analytical methods, and operational understanding** to investigate supply chain problems and support better decisions.

The final deliverable is not just a collection of SQL queries. It is a documented analytical system that explains how the data is transformed, how the metrics are calculated, what the evidence reveals, and what the business can do next.

## Author

**YOUR NAME**

Mechanical Engineering Undergraduate | SQL | Data Engineering | Supply Chain Analytics

- GitHub: [GITHUB PROFILE] ([(https://github.com/Nandu-yadav)](https://github.com/Nandu-yadav))
- LinkedIn: [LINKEDIN PROFILE]((https://www.linkedin.com/in/nandu-yadavv))

---

*Disclaimer: FreshCart Pvt. Ltd. is a fictional business scenario from the project brief. Findings and recommendations should be interpreted within the limitations of the supplied dataset. No real company results or business improvements are claimed.*
