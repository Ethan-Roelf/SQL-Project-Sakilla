## Project Overview
This project transforms raw transactional data from the **Sakila DVD Rental database** into a high-performance analytical layer. I have designed this to simulate a real-world Data Engineering workflow, bridging the gap between raw backend tables and executive-level Business Intelligence (BI) requirements.

---

## How this project added value to the business
* **Talent Management:** Automated identification of high-performing actors (>25 films) for marketing campaigns.
* **Revenue Leakage Audit:** Identified "Ghost Rentals" (unreturned items) and standardized missing data for stakeholder reporting.
* **Customer Segmentation:** Implemented logic-driven loyalty tiers (Elite, Premium, Standard) based on rental frequency.
* **Temporal Analytics:** Analyzed peak rental trends by Month and Weekday to optimize store staffing.
* **Store Leaderboards:** Generated "Top 5" revenue-generating films per store using advanced ranking logic.

---

## Technical Skill Inventory

### 1. Data Definition & Manipulation (DDL/DML)
* **`CREATE TABLE`**: Defined schema structures with Primary Keys for optimized indexing.
* **`INSERT INTO ... SELECT`**: Performed Bulk Data Transformation (ETL) from source to reporting tables.
* **`UPDATE` & `DELETE`**: Managed data lifecycles and enforced data cleanup rules.

### 2. Advanced Joins & Set Theory
* **Multi-Table Joins**: Connected `Payment`, `Rental`, `Inventory`, and `Film` tables while maintaining high performance.
* **Anti-Joins (`EXCEPT`)**: Isolated specific customer segments (e.g., customers who have *never* rented Horror films).
* **`INTERSECT`**: Identified geographic overlaps between retail locations and customer bases without redundant joins.

### 3. Conditional Logic & Transformation
* **`CASE` Statements**: Created dynamic categorical buckets for customer segmentation.
* **`COALESCE` / `NULL` Handling**: Replaced missing return dates with sentinel values to prevent "broken" reporting visualizations.
* **Data Casting**: Used `CAST` to ensure data-type compatibility across reporting layers.

### 4. Mathematical & String Functions
* **String Ops**: Mastered `CONCAT`, `UPPER`, `REPLACE`, and `LEFT` for data cleansing.
* **Numeric Ops**: Used `ROUND` and `AVG` to ensure financial reports meet professional precision standards.
* **Date Ops**: Leveraged `DATENAME`, `DATEPART`, and `YEAR` for time-series extraction.

### 5. Analytical Window Functions
* **`PARTITION BY`**: Segmented data by Store ID to perform local calculations within global datasets.
* **`RANK()`**: Implemented competitive ranking logic that correctly handles ties in revenue.
* **Common Table Expressions (CTEs) / Subqueries**: Nested window logic to filter for "Top N" business results.

---

## Performance & Design Philosophy
* **I/O Efficiency**: Explicitly avoided `SELECT *` to reduce memory overhead.
* **Sargability**: Wrote `WHERE` clauses that utilize database indexes rather than forcing full table scans.
* **Portability**: Utilized ANSI-standard SQL to ensure logic is compatible with modern warehouses like Snowflake or BigQuery.

Readability: Using clear aliases and intent-based syntax (like EXCEPT).

Efficiency: Avoiding SELECT * and using window functions over expensive correlated subqueries.
