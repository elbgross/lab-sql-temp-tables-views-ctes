USE sakila;

-- Step 1: Create a View

-- First, create a view that summarizes rental information for each customer. 
-- The view should include the customer's ID, name, email address, and total number of rentals (rental_count).
DROP VIEW IF EXISTS rental_sum;
CREATE VIEW rental_sum AS
SELECT 
c.customer_id, 
c.first_name, email, 
COUNT(r.rental_id) AS rental_count 
FROM customer c
JOIN rental r
ON r.customer_id=c.customer_id
GROUP BY c.customer_id,c.first_name,c.email;

-- Step 2: Create a Temporary Table

-- Next, create a Temporary Table that calculates the total amount paid by each customer (total_paid). 
-- The Temporary Table should use the rental summary view created in Step 1 to join with the payment table 
-- and calculate the total amount paid by each customer.

DROP TEMPORARY TABLE IF EXISTS total_paid;
CREATE TEMPORARY TABLE total_paid AS
SELECT 
rs.customer_id,
rs.first_name,
rs.email,
rs.rental_count,
SUM(p.amount) AS total_paid
FROM rental_sum AS rs
LEFT JOIN payment AS p
ON p.customer_id = rs.customer_id
GROUP BY
rs.customer_id, rs.first_name, rs.email, rs.rental_count;

SELECT * FROM total_paid;

-- Step 3: Create a CTE and the Customer Summary Report

-- Create a CTE that joins the rental summary View with the customer payment summary Temporary Table created in Step 2. 
-- The CTE should include the customer's name, email address, rental count, and total amount paid.
-- Next, using the CTE, create the query to generate the final customer summary report, which should include: 
-- customer name, email, rental_count, total_paid and average_payment_per_rental, this last column is a derived column 
-- from total_paid and rental_count.

DROP TABLE IF EXISTS final_customer_summary;
CREATE TEMPORARY TABLE final_customer_summary AS
SELECT 
customer_id,
first_name,
email,
rental_count,
total_paid,
 ROUND((total_paid) /(rental_count), 2 ) AS average_payment_per_rental
FROM total_paid 
ORDER BY total_paid DESC, first_name;

SELECT * FROM final_customer_summary;


