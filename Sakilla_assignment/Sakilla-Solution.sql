/* 
PART 1: THE TALENT PERFORMANCE LAYER
Focus: DDL, DML, and String Manipulation
*/

-- 1. Infrastructure Setup
CREATE TABLE reporting_actor_performance (
    actor_id INT,
    full_name VARCHAR(255),
    load_date DATETIME,
    PRIMARY KEY (actor_id)
);

-- 2. Data Population
INSERT INTO reporting_actor_performance (actor_id, full_name, load_date)
SELECT 
    a.actor_id, 
    UPPER(CONCAT(a.first_name, ' ', a.last_name)), 
    GETDATE()
FROM actor a
INNER JOIN film_actor fa ON a.actor_id = fa.actor_id
GROUP BY a.actor_id, a.first_name, a.last_name
HAVING COUNT(fa.film_id) > 25;

/* Decision: Why INNER JOIN vs. SUBQUERY?
Alternative: We could use a subquery in the WHERE clause (WHERE actor_id IN (...)).
Production Benefit: The INNER JOIN with GROUP BY is generally more efficient for the 
optimizer when aggregating counts across large sets. It allows the engine to 
perform a hash join rather than executing a subquery for every row in the 'actor' table.
*/

-- 3. Data Cleanup
UPDATE reporting_actor_performance 
SET load_date = GETDATE();

DELETE FROM reporting_actor_performance 
WHERE full_name LIKE 'Z%';

/* 
PART 2: THE REVENUE LEAKAGE AUDIT
Focus: Joins, Null Handling, and Anti-Joins
*/

-- 4. The Unreturned Inventory Report
SELECT 
    c.email, 
    f.title, 
    i.store_id,
    COALESCE(CAST(r.return_date AS VARCHAR), '2026-01-01') AS adjusted_return_date
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
JOIN customer c ON r.customer_id = c.customer_id
WHERE r.return_date IS NULL;

/* Decision: Why COALESCE vs. CASE?
Alternative: CASE WHEN return_date IS NULL THEN '2026-01-01' ELSE return_date END.
Production Benefit: COALESCE is syntactically shorter and more readable. It is 
also an ANSI-standard function optimized by most SQL engines specifically for 
null-replacement logic.
*/

-- 5. Market Exclusion Analysis (Anti-Join)
SELECT customer_id FROM customer
EXCEPT
SELECT r.customer_id
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film_category fc ON i.film_id = fc.film_id
JOIN category cat ON fc.category_id = cat.category_id
WHERE cat.name = 'Horror';

/* Decision: Why EXCEPT vs. NOT IN?
Alternative: WHERE customer_id NOT IN (SELECT customer_id FROM ... WHERE cat.name = 'Horror').
Production Benefit: 'NOT IN' has a dangerous pitfall: if the subquery returns a single 
NULL, the entire query returns zero results. EXCEPT automatically handles distinct 
values and is generally more performant as it treats both sides as sets.
*/

/* 
PART 3: CUSTOMER LOYALTY SEGMENTATION
Focus: Case Logic and Set Operators

*/

-- 6. Tier Assignment
SELECT 
    customer_id,
    COUNT(rental_id) AS total_rentals,
    CASE 
        WHEN COUNT(rental_id) > 35 THEN 'Elite'
        WHEN COUNT(rental_id) BETWEEN 20 AND 35 THEN 'Premium'
        ELSE 'Standard'
    END AS loyalty_status
FROM rental
GROUP BY customer_id;

-- 7. Geographic Synergy
SELECT city FROM city
INNER JOIN address a ON city.city_id = a.city_id
INNER JOIN store s ON a.address_id = s.address_id
INTERSECT
SELECT city FROM city
INNER JOIN address a ON city.city_id = a.city_id
INNER JOIN customer c ON a.address_id = c.address_id;

/* Decision: Why INTERSECT vs. INNER JOIN on the same table?
Alternative: Joining 'city' to 'address' and 'store', then joining that result back 
to 'address' and 'customer'.
Production Benefit: INTERSECT is cleaner for "shared membership" questions. 
It avoids complex, multi-layered joins that can lead to duplicate rows and 
inflated result sets, which would then require a 'DISTINCT' (an expensive operation).
*/

/* 
PART 4: TEMPORAL & CATALOG ANALYTICS
Focus: Date functions, Numeric functions, and String Manipulation
*/

-- 8. Rental Timing Trends
SELECT 
    DATENAME(month, rental_date) AS month_name,
    DATENAME(weekday, rental_date) AS day_name,
    COUNT(*) AS total_rentals,
    ROUND(AVG(f.rental_rate), 2) AS avg_rental_cost
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
GROUP BY DATENAME(month, rental_date), DATENAME(weekday, rental_date);

-- 9. The "Compact" Catalog
SELECT 
    LEFT(description, 10) AS short_desc,
    REPLACE(title, ' ', '_') AS formatted_title,
    YEAR(last_update) + 1 AS next_review_year
FROM film;

/* Decision: Why YEAR() + 1 vs. DATEADD?
Alternative: DATEADD(year, 1, last_update).
Production Benefit: Since the requirement only asked for the "Year," extracting 
the YEAR() as an integer and adding 1 is computationally cheaper than performing 
full date arithmetic, which involves calculating leap years and month lengths.
*/

/*
Focus: Advanced Window Functions
*/

-- 10. Store Leaderboard
SELECT * FROM (
    SELECT 
        i.store_id,
        f.title,
        SUM(p.amount) AS total_revenue,
        RANK() OVER (PARTITION BY i.store_id ORDER BY SUM(p.amount) DESC) AS performance_rank
    FROM payment p
    JOIN rental r ON p.rental_id = r.rental_id
    JOIN inventory i ON r.inventory_id = i.inventory_id
    JOIN film f ON i.film_id = f.film_id
    GROUP BY i.store_id, f.title
) AS ranked_data
WHERE performance_rank <= 5;

/* Decision: Why RANK() vs. ROW_NUMBER()?
Alternative: ROW_NUMBER() OVER (...).
Production Benefit: In a business "Leaderboard," if two movies earned exactly 
the same amount, they should both be ranked #1. RANK() allows for ties, 
whereas ROW_NUMBER() would arbitrarily pick one to be #1 and the other #2, 
leading to inaccurate business reporting.
*/
