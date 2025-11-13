SET search_path TO sakila, public;

-- Condition Types
-- Equality Conditions
SELECT c.email
  FROM customer c
       INNER JOIN rental r ON c.customer_id = r.customer_id
 WHERE r.rental_date::DATE = '2005-06-14';

-- Inequality Conditions
SELECT c.email
  FROM customer c
       INNER JOIN rental r ON c.customer_id = r.customer_id
 WHERE r.rental_date::DATE <> '2005-06-14';

-- Data modification using equality conditions
DELETE
  FROM rental
 WHERE EXTRACT(YEAR FROM rental_date) = '2004';

-- Range Conditions
SELECT customer_id
     , rental_date
  FROM rental
 WHERE rental_date < '2005-05-25';

SELECT customer_id
     , rental_date
  FROM rental
 WHERE rental_date <= '2005-06-16'
   AND rental_date >= '2005-06-14';

-- The between operator
SELECT customer_id
     , rental_date
  FROM rental
 WHERE rental_date BETWEEN '2005-06-14' AND '2005-06-16';

SELECT customer_id
     , payment_date
     , amount
  FROM payment
 WHERE amount BETWEEN 10.0 AND 11.99;

-- String ranges
SELECT last_name
     , first_name
  FROM customer
 WHERE last_name BETWEEN 'FA' AND 'FR';

SELECT last_name
     , first_name
  FROM customer
 WHERE last_name BETWEEN 'FA' AND 'FRB';

-- Membership Conditions
-- locate all films that have a rating of either 'G' or 'PG'
SELECT title
     , rating
  FROM film
 WHERE rating = 'G'
    OR rating = 'PG';

-- if expressions must contain 10 or 20 members, use in operator
SELECT title
     , rating
  FROM film
 WHERE rating IN ('G', 'PG');

-- using subqueries
-- if film whose title includes the string 'PET' would be safe for family viewing,
SELECT title
     , rating
  FROM film
 WHERE rating IN (
   SELECT rating
     FROM film
    WHERE title LIKE '%PET%'
                 );

-- using not in
SELECT title
     , rating
  FROM film
 WHERE rating NOT IN ('PG-13', 'R', 'NC-17');

-- matching conditions
SELECT last_name
     , first_name
  FROM customer
 WHERE LEFT(last_name, 1) = 'Q';

-- using wildcards
-- - Exactly one character
-- % Any number of characters
SELECT last_name
     , first_name
  FROM customer
 WHERE last_name LIKE '_A_T%S';

-- if your needs are a bit more sophisticated, however, you can use multiple search expressions
SELECT last_name
     , first_name
  FROM customer
 WHERE last_name LIKE 'Q%'
    OR last_name LIKE 'Y%';


-- using regular expressions
SELECT last_name
     , first_name
  FROM customer
 WHERE last_name ~ '^[QY]';

-- Null
-- null is the absence of a value

-- various flavors of null:
-- 1. not applicable
-- 2. value not yet known
-- 3. value undefined

-- when working with null, we should remember:
-- 1. an expression can be null, but it can never equal null
-- 2. two nulls are never equal to each other

-- To test whether an expression is null, you need to use the is null operator
SELECT rental_id
     , customer_id
  FROM rental
 WHERE return_date IS NULL;

-- Here's the same query using = null instead of is null
-- SELECT rental_id
--      , customer_id
--   FROM rental
--  WHERE return_date = NULL;
-- the query parses and executes but does not return any rows.

-- if you want to see whether a value has been assigned to a column,
-- you can use the is not null operator
SELECT rental_id
     , customer_id
     , return_date
  FROM rental
 WHERE return_date IS NOT NULL;

-- potential pitfall (잠재적인 함정)
-- you have been asked to find all rentals that were not returned during May through August 2005
SELECT rental_id
     , customer_id
     , return_date
  FROM rental
 WHERE return_date NOT BETWEEN '2005-05-01' AND '2005-09-01';


-- rows returned have a non-null return date
-- To answer the question correctly, therefore, you need to account for the possibility
-- that some rows might contain a null in the return_date column:
SELECT rental_id
     , customer_id
     , rental.return_date
  FROM rental
 WHERE return_date IS NULL
    OR return_date NOT BETWEEN '2005-05-01' AND '2005-09-01';

-- exercise
-- construct a query that retrieves all rows from the payments table
-- where the amount is either 1.98, 7.98, 9.98
SELECT *
  FROM payment
 WHERE amount IN (1.98, 7.98, 9.98);

-- construct a query that finds all customers whose last name contains an A in second position
-- and a W anywhere after the A
SELECT last_name
     , first_name
  FROM customer
 WHERE last_name LIKE '_A%W%';
