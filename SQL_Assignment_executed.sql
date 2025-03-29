-- Sakila Database Assignment Queries

-- ===========
-- SQL Basics
-- ===========
USE mavenmovies;
-- 1. Create a table called employees with the specified constraints
drop table if exists employees;
CREATE TABLE employees (
    emp_id INT NOT NULL PRIMARY KEY,
    emp_name VARCHAR(255) NOT NULL,
    age INT CHECK (age >= 18),
    email VARCHAR(255) UNIQUE,
    salary DECIMAL(10,2) DEFAULT 30000.00
);

-- 2. Explain the purpose of constraints
-- Constraints help maintain data integrity by enforcing rules such as NOT NULL, UNIQUE, PRIMARY KEY, etc.

-- 3. Why use NOT NULL constraint? Can a primary key contain NULL values?
-- NOT NULL prevents missing values. A primary key cannot have NULL values because it uniquely identifies records.

-- 4. Adding and removing constraints
ALTER TABLE employees ADD CONSTRAINT chk_age CHECK (age >= 18);
ALTER TABLE employees DROP CONSTRAINT chk_age;

-- 5. Consequences of violating constraints
-- Trying to insert a NULL emp_id will result in an error: "ERROR: Column 'emp_id' cannot be null"

-- 6. Modifying the products table to add constraints
drop table if exists products;
CREATE table products(
    product_id INT PRIMARY KEY,
    product_name VARCHAR(255),
    price DECIMAL(10,2) DEFAULT 50.00
);

ALTER TABLE products ALTER COLUMN price SET DEFAULT 50.00;


-- ===========
-- Joins
-- ===========

-- 7. Fetch student_name and class_name using INNER JOIN
drop table if exists students;
CREATE TABLE IF NOT EXISTS students (
    student_id INT PRIMARY KEY,
    student_name VARCHAR(255),
    class_id INT
);
drop table if exists classes;
CREATE TABLE classes (
    class_id INT PRIMARY KEY,
    class_name VARCHAR(255)
    );
SELECT students.student_name, classes.class_name
FROM students
INNER JOIN classes ON students.class_id = classes.class_id;

-- 8. Show all order_id, customer_name, product_name ensuring all products are listed
CREATE TABLE IF NOT EXISTS orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE
);
DESC customer;
DESC orders;
DESC order_details;
DESC products;

CREATE TABLE IF NOT EXISTS order_details (
    order_detail_id INT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    price DECIMAL(10,2)
);
SELECT 
    o.order_id, 
    c.first_name, 
    c.last_name, 
    p.product_name
FROM orders o
LEFT JOIN customer c ON o.customer_id = c.customer_id
LEFT JOIN order_details od ON o.order_id = od.order_id
LEFT JOIN products p ON od.product_id = p.product_id;

-- 9. Find total sales amount for each product
SELECT products.product_name, SUM(order_details.quantity * order_details.price) AS total_sales
FROM order_details
INNER JOIN products ON order_details.product_id = products.product_id
GROUP BY products.product_name;

-- 10. Display order_id, customer_name, and quantity of products ordered using INNER JOIN
 SELECT o.order_id, CONCAT(c.first_name, ' ', c.last_name) AS customer_name, SUM(od.quantity) AS total_quantity
FROM orders o
INNER JOIN customer c ON o.customer_id = c.customer_id
INNER JOIN order_details od ON o.order_id = od.order_id
GROUP BY o.order_id, customer_name;

-- ===========
-- SQL Commands
-- ===========

-- 1. Identify primary keys and foreign keys in mavenmovies database
SELECT 
    table_name, 
    constraint_name, 
    constraint_type
FROM information_schema.table_constraints
WHERE table_schema = 'mavenmovies'
AND constraint_type IN ('PRIMARY KEY', 'FOREIGN KEY');

-- 2. List all details of actors
SELECT * FROM actor;

-- 3. List all customer information
SELECT * FROM customer;

-- 4. List different countries
SELECT DISTINCT country FROM country;

-- 5. Display all active customers
SELECT * FROM customer WHERE active = 1;

-- 6. List of all rental IDs for customer with ID 1
SELECT rental_id FROM rental WHERE customer_id = 1;

-- 7. Display all the films whose rental duration is greater than 5
SELECT * FROM film WHERE rental_duration > 5;

-- 8. List the total number of films whose replacement cost is greater than $15 and less than $20
SELECT COUNT(*) FROM film WHERE replacement_cost BETWEEN 15 AND 20;

-- 9. Display the count of unique first names of actors
SELECT COUNT(DISTINCT first_name) FROM actor;

-- 10. Display the first 10 records from the customer table
SELECT * FROM customer LIMIT 10;

-- 11. Display the first 3 records from the customer table whose first name starts with 'b'
SELECT * FROM customer WHERE first_name LIKE 'b%' LIMIT 3;

-- 12. Display the names of the first 5 movies which are rated as 'G'
SELECT title FROM film WHERE rating = 'G' LIMIT 5;

-- 13. Find all customers whose first name starts with 'a'
SELECT * FROM customer WHERE first_name LIKE 'a%';

-- 14. Find all customers whose first name ends with 'a'
SELECT * FROM customer WHERE first_name LIKE '%a';

-- 15. Display the list of first 4 cities which start and end with 'a'
SELECT city FROM city WHERE city LIKE 'a%a' LIMIT 4;

-- 16. Find all customers whose first name have 'NI' in any position
SELECT * FROM customer WHERE first_name LIKE '%NI%';

-- 17. Find all customers whose first name have 'r' in the second position
SELECT * FROM customer WHERE first_name LIKE '_r%';

-- 18. Find all customers whose first name starts with 'a' and are at least 5 characters in length
SELECT * FROM customer WHERE first_name LIKE 'a%' AND LENGTH(first_name) >= 5;

-- 19. Find all customers whose first name starts with 'a' and ends with 'o'
SELECT * FROM customer WHERE first_name LIKE 'a%o';

-- 20. Get the films with PG and PG-13 rating using IN operator
SELECT * FROM film WHERE rating IN ('PG', 'PG-13');

-- 21. Get the films with length between 50 to 100 using BETWEEN operator
SELECT * FROM film WHERE length BETWEEN 50 AND 100;

-- 22. Get the top 50 actors using LIMIT operator
SELECT * FROM actor LIMIT 50;

-- 23. Get the distinct film IDs from inventory table
SELECT DISTINCT film_id FROM inventory;

-- ===========
--  Functions
-- ===========

-- 1. Retrieve total number of rentals
SELECT COUNT(*) FROM rental;

-- 2. Find average rental duration
SELECT AVG(rental_duration) FROM film;

-- ===========
-- String Functions
-- ===========

-- 3. Display customer names in uppercase
SELECT UPPER(first_name), UPPER(last_name) FROM customer;

-- 4. Extract month from rental date with rental ID
SELECT rental_id, MONTH(rental_date) FROM rental;

-- ===========
-- GROUP BY
-- ===========

-- 5. Retrieve rental count for each customer
SELECT customer_id, COUNT(*) FROM rental GROUP BY customer_id;

-- 6. Total revenue per store
SELECT s.store_id, SUM(p.amount) AS total_revenue
FROM payment p
JOIN staff st ON p.staff_id = st.staff_id
JOIN store s ON st.store_id = s.store_id
GROUP BY s.store_id;


-- 7. Total rentals per category
SELECT category.name, COUNT(*) FROM rental
JOIN inventory ON rental.inventory_id = inventory.inventory_id
JOIN film ON inventory.film_id = film.film_id
JOIN film_category ON film.film_id = film_category.film_id
JOIN category ON film_category.category_id = category.category_id
GROUP BY category.name;

-- 8. Find the average rental rate of movies in each language
SELECT l.name AS language, AVG(f.rental_rate) AS avg_rental_rate
FROM film f
JOIN language l ON f.language_id = l.language_id
GROUP BY l.name;

-- ===========
-- Joins
-- ===========

-- 9. Display the title of the movie, customer's first name, and last name who rented it
SELECT f.title, c.first_name, c.last_name
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
JOIN customer c ON r.customer_id = c.customer_id;

-- 10. Retrieve the names of all actors who have appeared in the film "Gone with the Wind"
SELECT a.first_name, a.last_name
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film f ON fa.film_id = f.film_id
WHERE f.title = 'Gone with the Wind';

-- 11. Retrieve the customer names along with the total amount they've spent on rentals
SELECT c.first_name, c.last_name, SUM(p.amount) AS total_spent
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name;

-- 12. List the titles of movies rented by each customer in a particular city (e.g., 'London')
SELECT f.title, c.first_name, c.last_name, ci.city
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
JOIN customer c ON r.customer_id = c.customer_id
JOIN address a ON c.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
WHERE ci.city = 'London'
GROUP BY f.title, c.first_name, c.last_name, ci.city;

-- ===========
-- Advanced Joins and GROUP BY
-- ===========

-- 13. Display the top 5 rented movies along with the number of times they've been rented
SELECT f.title, COUNT(r.rental_id) AS rental_count
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
GROUP BY f.title
ORDER BY rental_count DESC
LIMIT 5;

-- 14. Determine the customers who have rented movies from both stores (store ID 1 and store ID 2)
SELECT c.customer_id, c.first_name, c.last_name
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN customer c ON r.customer_id = c.customer_id
WHERE i.store_id IN (1, 2)
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING COUNT(DISTINCT i.store_id) = 2;


-- ===========
-- Window Functions
-- ===========

-- 1. Rank customers based on the total amount spent
SELECT 
    customer_id, 
    SUM(amount) AS total_spent,
    RANK() OVER (ORDER BY SUM(amount) DESC) AS `rank`
FROM payment
GROUP BY customer_id;

-- 2. Calculate cumulative revenue per film
SELECT film_id, SUM(amount) OVER (PARTITION BY film_id ORDER BY payment_date) AS cumulative_revenue
FROM rental
JOIN payment ON rental.rental_id = payment.rental_id
JOIN inventory ON rental.inventory_id = inventory.inventory_id;

-- ===============================
-- 3. Determine the average rental duration for each film, considering films with similar lengths.
-- ===============================
SELECT 
    film_id, 
    title, 
    length, 
    AVG(rental_duration) OVER (PARTITION BY length) AS avg_rental_duration
FROM film;

-- ===============================
-- 4. Identify the top 3 films in each category based on their rental counts.
-- ===============================
WITH RankedFilms AS (
    SELECT 
        c.name AS category, 
        f.title, 
        COUNT(r.rental_id) AS rental_count,
        RANK() OVER (PARTITION BY c.name ORDER BY COUNT(r.rental_id) DESC) AS film_rank
    FROM rental r
    JOIN inventory i ON r.inventory_id = i.inventory_id
    JOIN film f ON i.film_id = f.film_id
    JOIN film_category fc ON f.film_id = fc.film_id
    JOIN category c ON fc.category_id = c.category_id
    GROUP BY c.name, f.title
)
SELECT * FROM RankedFilms WHERE film_rank <= 3;

-- ===============================
-- 5. Calculate the difference in rental counts between each customer's total rentals and the average rentals across all customers.
-- ===============================
WITH CustomerRentals AS (
    SELECT customer_id, COUNT(*) AS total_rentals
    FROM rental
    GROUP BY customer_id
),
AvgRentals AS (
    SELECT AVG(total_rentals) AS avg_rentals FROM CustomerRentals
)
SELECT cr.customer_id, cr.total_rentals, 
       cr.total_rentals - ar.avg_rentals AS rental_difference
FROM CustomerRentals cr, AvgRentals ar;

-- ===============================
-- 6. Find the monthly revenue trend for the entire rental store over time.
-- ===============================
SELECT 
    DATE_FORMAT(payment_date, '%Y-%m') AS month, 
    SUM(amount) AS total_revenue
FROM payment
GROUP BY month
ORDER BY month;

-- ===============================
-- 7. Identify the customers whose total spending on rentals falls within the top 20% of all customers.
-- ===============================
WITH CustomerSpending AS (
    SELECT customer_id, SUM(amount) AS total_spent
    FROM payment
    GROUP BY customer_id
),
RankedCustomers AS (
    SELECT customer_id, total_spent,
           NTILE(5) OVER (ORDER BY total_spent DESC) AS percentile
    FROM CustomerSpending
)
SELECT customer_id, total_spent 
FROM RankedCustomers 
WHERE percentile = 1;

-- ===============================
-- 8. Calculate the running total of rentals per category, ordered by rental count.
-- ===============================
SELECT 
    c.name AS category, 
    COUNT(r.rental_id) AS total_rentals,
    SUM(COUNT(r.rental_id)) OVER (PARTITION BY c.name ORDER BY COUNT(r.rental_id)) AS running_total
FROM rental r
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
GROUP BY c.name, f.title;

-- ===============================
-- 9. Find the films that have been rented less than the average rental count for their respective categories.
-- ===============================
WITH CategoryAvg AS (
    SELECT 
        c.name AS category, 
        f.title, 
        COUNT(r.rental_id) AS rental_count,
        AVG(COUNT(r.rental_id)) OVER (PARTITION BY c.name) AS avg_rentals
    FROM rental r
    JOIN inventory i ON r.inventory_id = i.inventory_id
    JOIN film f ON i.film_id = f.film_id
    JOIN film_category fc ON f.film_id = fc.film_id
    JOIN category c ON fc.category_id = c.category_id
    GROUP BY c.name, f.title
)
SELECT title, category, rental_count 
FROM CategoryAvg 
WHERE rental_count < avg_rentals;

-- ===============================
-- 10. Identify the top 5 months with the highest revenue and display the revenue generated in each month.
-- ===============================
SELECT 
    DATE_FORMAT(payment_date, '%Y-%m') AS month, 
    SUM(amount) AS total_revenue
FROM payment
GROUP BY month
ORDER BY total_revenue DESC
LIMIT 5;


-- ===========
-- Normalization & CTE
-- ===========

-- ===============================
-- 1. First Normal Form (1NF)
-- ===============================
-- The rental table in Sakila could violate 1NF if it stored multiple rental_dates in one column.
-- To normalize, we create a separate row for each rental event.
-- No SQL query is needed, but restructuring the table ensures atomic values.

-- ===============================
-- 2. Second Normal Form (2NF)
-- ===============================
-- A table violates 2NF if it has partial dependencies on a composite primary key.
-- Example: film_actor (film_id, actor_id, actor_name)
-- actor_name depends only on actor_id, not film_id.
-- Solution: Create a separate actor table and link using actor_id.

-- ===============================
-- 3. Third Normal Form (3NF)
-- ===============================
-- A table violates 3NF if it has transitive dependencies.
-- Example: If a customer table stores (customer_id, city, country)
-- city → country is a transitive dependency.
-- Solution: Separate city and country into a different table and link via city_id.

-- ===============================
-- 4. Normalization Process
-- ===============================
-- Unnormalized form:
-- rental (rental_id, customer_info, film_info, rental_date)
-- 1NF: Split customer_info and film_info into separate columns.
-- 2NF: Separate customer and film into different tables.
-- 3NF: Ensure no transitive dependencies (e.g., store address separately).

-- ===============================
-- 5. CTE Basics: Distinct actor names and film count
-- ===============================
WITH ActorFilms AS (
    SELECT actor.actor_id, actor.first_name, actor.last_name, COUNT(film_actor.film_id) AS film_count
    FROM actor
    JOIN film_actor ON actor.actor_id = film_actor.actor_id
    GROUP BY actor.actor_id
)
SELECT * FROM ActorFilms;

-- ===============================
-- 6. CTE with Joins: Film title, language, and rental rate
-- ===============================
WITH FilmLanguages AS (
    SELECT film.title, language.name AS language, film.rental_rate
    FROM film
    JOIN language ON film.language_id = language.language_id
)
SELECT * FROM FilmLanguages;

-- ===============================
-- 7. CTE for Aggregation: Total revenue per customer
-- ===============================
WITH CustomerRevenue AS (
    SELECT customer_id, SUM(amount) AS total_revenue
    FROM payment
    GROUP BY customer_id
)
SELECT * FROM CustomerRevenue ORDER BY total_revenue DESC;

-- ===============================
-- 8. CTE with Window Functions: Rank films by rental duration
-- ===============================
WITH FilmRanking AS (
    SELECT title, rental_duration, 
           RANK() OVER (ORDER BY rental_duration DESC) AS film_rank
    FROM film
)
SELECT * FROM FilmRanking;


-- ===============================
-- 9. CTE and Filtering: Customers with more than 2 rentals
-- ===============================
WITH FrequentCustomers AS (
    SELECT customer_id, COUNT(*) AS rental_count
    FROM rental
    GROUP BY customer_id
    HAVING rental_count > 2
)
SELECT c.customer_id, c.first_name, c.last_name
FROM customer c
JOIN FrequentCustomers fc ON c.customer_id = fc.customer_id;

-- ===============================
-- 10. CTE for Date Calculations: Rentals per month
-- ===============================
WITH MonthlyRentals AS (
    SELECT DATE_FORMAT(rental_date, '%Y-%m') AS month, COUNT(*) AS total_rentals
    FROM rental
    GROUP BY month
)
SELECT * FROM MonthlyRentals ORDER BY month;

-- ===============================
-- 11. CTE and Self-Join: Actors in the same films
-- ===============================
WITH ActorPairs AS (
    SELECT fa1.actor_id AS actor1, fa2.actor_id AS actor2, fa1.film_id
    FROM film_actor fa1
    JOIN film_actor fa2 ON fa1.film_id = fa2.film_id AND fa1.actor_id < fa2.actor_id
)
SELECT a1.first_name AS actor_1, a2.first_name AS actor_2, f.title
FROM ActorPairs
JOIN actor a1 ON ActorPairs.actor1 = a1.actor_id
JOIN actor a2 ON ActorPairs.actor2 = a2.actor_id
JOIN film f ON ActorPairs.film_id = f.film_id;

-- ===============================
-- 12. CTE for Recursive Search: Find employees reporting to a manager
-- ===============================
drop table if exists employee;
CREATE TABLE employee (
    staff_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    reports_to INT NULL
);

INSERT INTO employee (staff_id, first_name, last_name, reports_to) VALUES
(1, 'Alice', 'Smith', NULL), 
(2, 'Bob', 'Johnson', 1),
(3, 'Charlie', 'Brown', 1),
(4, 'David', 'Lee', 2),
(5, 'Eve', 'White', 2),
(6, 'Frank', 'Taylor', 3);

WITH RECURSIVE EmployeeHierarchy AS (
    SELECT staff_id, first_name, last_name, reports_to AS manager_id
    FROM employee
    WHERE reports_to IS NULL
    UNION ALL
    SELECT e.staff_id, e.first_name, e.last_name, eh.manager_id
    FROM employee e
    JOIN EmployeeHierarchy eh ON e.reports_to = eh.staff_id
)
SELECT * FROM EmployeeHierarchy;

