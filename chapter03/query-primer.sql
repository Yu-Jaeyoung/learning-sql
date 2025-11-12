SET search_path TO sakila, public;

-- Query Mechanics
-- Query fails to yield any results, shows under message
-- 0 rows retrieved in 504 ms (execution: 22 ms, fetching: 482 ms)
SELECT first_name
     , last_name
  FROM customer
 WHERE last_name = 'ZIEGLER';

-- If the query returns one or more rows,
-- 16 rows retrieved starting from 1 in 234 ms (execution: 9 ms, fetching: 225 ms)
SELECT *
  FROM category;

-- Query Clauses
-- Select Clauses
SELECT *
  FROM language;

SELECT language_id
     , name
     , last_update
  FROM language;

SELECT name
  FROM language;

SELECT language_id
     , 'COMMON'           language_usage
     , language_id * 3.14 lang_pi_value
     , UPPER(name)
  FROM language;

-- built-in function example
-- can be included in select clause
SELECT VERSION()
     , USER
     , CURRENT_DATABASE();

-- column aliases
-- can use with/without as keyword
SELECT language_id
     , 'COMMON' AS        language_usage
     , language_id * 3.14 lang_pi_value
     , UPPER(name)
  FROM language;

-- removing duplicates

SELECT DISTINCT actor_id
  FROM film_actor
 ORDER BY actor_id;

-- Keep in mind that generating a distinct set of results requires the
-- data to be sorted, which can be time-consuming for large result
-- sets. Don’t fall into the trap of using distinct just to be sure there
-- are no duplicates; instead, take the time to understand the data you
-- are working with so that you will know whether duplicates are
-- possible.

-- from clause
-- tables
-- 1. Permanent tables (i.e., created using the create table statement)
-- 2. Derived tables   (i.e., rows returned by a subquery and held in memory)
-- 3. Temporary tables (i.e., volatile data held in memory)
-- 4. Virtual tables   (i.e., created using the create view statement)

-- Derived(subquery-generated) tables
SELECT CONCAT(cust.last_name, ', ', cust.first_name) full_name
  FROM (
         SELECT first_name
              , last_name
           FROM customer
          WHERE first_name = 'JESSIE'
       ) cust;

-- Temporary tables
-- Temporary tables are automatically dropped at the end of a session,
-- or optionally at the end of the current transaction

-- PostgreSQL - 3 options
-- CREATE TEMP TABLE temp1 (...) ON COMMIT PRESERVE ROWS;  -- default: maintains data
-- CREATE TEMP TABLE temp2 (...) ON COMMIT DELETE ROWS;    -- delete data when tx ends
-- CREATE TEMP TABLE temp3 (...) ON COMMIT DROP;           -- delete table when tx ends

CREATE TEMPORARY TABLE actors_j
(
  actor_id   NUMERIC(5),
  first_name VARCHAR(45),
  last_name  VARCHAR(45)
);

-- 7 rows affected in 15 ms
INSERT
  INTO actors_j
SELECT actor_id
     , first_name
     , last_name
  FROM actor
 WHERE last_name LIKE 'J%';

SELECT *
  FROM actors_j;

-- Virtual tables(Views)
CREATE VIEW cust_vw(customer_id, first_name, last_name, active) AS
SELECT customer_id
     , first_name
     , last_name
     , active
  FROM customer;

SELECT first_name
     , last_name
  FROM cust_vw
 WHERE active = FALSE;

-- Table Links (join)
SELECT customer.first_name
     , customer.last_name
     , rental.rental_date::TIME rental_time
  FROM customer
       INNER JOIN rental ON customer.customer_id = rental.customer_id
 WHERE rental.rental_date::DATE = '2005-06-14';

-- Defining Table aliases
SELECT c.first_name
     , c.last_name
     , r.rental_date::TIME rental_time
  FROM customer c
       INNER JOIN rental r ON c.customer_id = r.customer_id
 WHERE r.rental_date::DATE = '2005-06-14';

-- Where Clause
SELECT title
  FROM film
 WHERE rating = 'G'
   AND rental_duration >= 7;

SELECT title
     , rating
     , rental_duration
  FROM film
 WHERE (rating = 'G' AND rental_duration >= 7)
    OR (rating = 'PG-13' AND rental_duration < 4);

-- The group by and having Clauses
SELECT c.first_name
     , c.last_name
     , COUNT(*)
  FROM customer c
       INNER JOIN rental r ON c.customer_id = r.customer_id
 GROUP BY c.first_name
        , c.last_name
HAVING COUNT(*) >= 40;

-- The order by Clause
SELECT c.first_name
     , c.last_name
     , r.rental_date::TIME AS rental_time
  FROM customer c
       INNER JOIN rental r ON c.customer_id = r.customer_id
 WHERE r.rental_date::DATE = '2005-06-14'
 ORDER BY c.last_name;

-- Ascending Versus Descending Sort Order
SELECT c.first_name
     , c.last_name
     , r.rental_date::TIME AS rental_time
  FROM customer c
       INNER JOIN rental r ON c.customer_id = r.customer_id
 WHERE r.rental_date::DATE = '2005-06-14'
 ORDER BY r.rental_date::TIME DESC;

-- Sorting via Numeric Placeholders
SELECT c.first_name
     , c.last_name
     , r.rental_date::TIME AS rental_time
  FROM customer c
       INNER JOIN rental r ON c.customer_id = r.customer_id
 WHERE r.rental_date::DATE = '2005-06-14'
 ORDER BY 3 DESC;

-- exercise 3-1
-- retrieve the actor ID, first name, and last name for all actors. Sort by last name and then by first name.
SELECT actor_id
     , first_name
     , last_name
  FROM actor
 ORDER BY last_name
        , first_name;

-- exercise 3-2
-- retrieve the actor ID, first name, and last name for all actors whose last name equals 'WILLIAMS' or 'DAVIS'
SELECT actor_id
     , first_name
     , last_name
  FROM actor
 WHERE last_name IN ('WILLIAMS', 'DAVIS');

-- exercise 3-3
-- Write a query against the rental table that returns the IDs of the customers who rented a film
-- on July 5, 2005(use the rental.rental_date column). Include a single row for each distinct customer ID.
SELECT DISTINCT customer_id
  FROM rental
 WHERE rental_date:: DATE = '2005-07-05';

-- exercise 3-4
-- fill the blanks
SELECT c.email
     , r.return_date
  FROM customer c
       INNER JOIN rental r ON c.customer_id = r.customer_id
 WHERE r.rental_date:: DATE = '2005-06-14'
 ORDER BY return_date DESC;

