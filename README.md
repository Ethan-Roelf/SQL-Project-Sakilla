# SQL-Project-Sakilla
Project: Sakila Operational & Analytics Layer (SOIA)
Overview
This project transforms raw transactional data from the Sakila DVD Rental database into a high-performance analytical layer. The goal was to simulate a real-world business environment where data engineers must bridge the gap between raw backend tables and executive-level reporting.

Key Business Use Cases Addressed
Talent Management: Automating the identification of high-performing actors.

Inventory Audit: Creating "Revenue Leakage" reports to track unreturned assets.

Customer Segmentation: Applying logic-driven tiers (Elite/Premium/Standard) for marketing.

Operational Trends: Analyzing peak rental periods by month and weekday.

Store Competition: Generating "Top 5" leaderboards per store to drive performance.

Technical Skill Inventory
The following SQL concepts and functions were implemented to ensure the code is production-ready, performant, and scalable.

1. Data Definition & Manipulation (DDL/DML)
CREATE TABLE: Defining schema structures with specific data types and Primary Keys.

INSERT INTO ... SELECT: Efficiently migrating and transforming data from source tables into analytical tables.

UPDATE & DELETE: Managing data lifecycles and performing administrative cleanups.

2. Advanced Relationship Management
Joins: Utilization of INNER JOIN for data intersections and LEFT JOIN for identifying missing records.

Anti-Joins: Using Set Operators like EXCEPT to identify exclusions (e.g., customers who have not interacted with specific categories).

Set Operators: Implementing INTERSECT to find commonalities across disparate business entities without the overhead of complex joins.

3. Logical & Data Transformation
Case Statements: implementing CASE WHEN ... THEN logic to create dynamic business buckets and customer tiers.

Null Handling: Utilizing COALESCE to handle missing data points, ensuring reporting dashboards remain visually consistent and "NULL-free."

Data Casting: Converting data types (e.g., CAST(date AS VARCHAR)) for final-mile reporting requirements.

4. Built-in Functions
String Functions: CONCAT, UPPER, REPLACE, and LEFT for data cleaning and formatting.

Numeric Functions: ROUND and AVG for financial accuracy and reducing visual noise in reports.

Date & Time: Leveraging DATENAME, DATEPART, and YEAR to extract temporal insights for trend analysis.

5. Analytical Window Functions
PARTITION BY: segmenting data by business units (Store ID) without collapsing rows.

RANK(): Calculating performance positions within partitions, specifically handling ties in revenue according to business rules.

Subqueries: Nesting window logic within subqueries to filter for "Top N" results (e.g., Top 5 films per store).

Performance & Best Practices
Throughout the project, I prioritized:

Sargability: Writing queries that allow the database to use indexes efficiently.

Readability: Using clear aliases and intent-based syntax (like EXCEPT).

Efficiency: Avoiding SELECT * and using window functions over expensive correlated subqueries.
