SET search_path TO sakila, public;

SELECT column_name
     , data_type
     , character_maximum_length
     , is_nullable
  FROM information_schema.columns
 WHERE table_name = 'customer';


SELECT column_name
     , data_type
     , character_maximum_length
     , is_nullable
  FROM information_schema.columns
 WHERE table_name = 'address';

-- Cartesian Product
SELECT c.first_name
     , c.last_name
     , a.address
  FROM customer c
     , address a;

-- Inner Joins
SELECT c.first_name
     , c.last_name
     , a.address
  FROM customer c
       JOIN address a ON c.address_id = a.address_id;

-- The ANSI Join Syntax
SELECT c.first_name
     , c.last_name
     , a.address
  FROM customer c
     , address a
 WHERE c.address_id = a.address_id;

SELECT c.first_name
     , c.last_name
     , a.address
  FROM customer c
     , address a
 WHERE c.address_id = a.address_id
   AND a.postal_code = '52137';

-- SQL92 join syntax
SELECT c.first_name
     , c.last_name
     , a.address
  FROM customer c
       INNER JOIN address a ON c.address_id = a.address_id
 WHERE a.postal_code = '52137';

-- Joining Three or More Tables
SELECT c.first_name
     , c.last_name
     , ct.city
  FROM customer c
       INNER JOIN address a ON c.address_id = a.address_id
       INNER JOIN city ct ON a.city_id = ct.city_id;

-- Using Subqueries as Tables
SELECT c.first_name
     , c.last_name
     , addr.address
     , addr.city
  FROM customer c
       INNER JOIN (
    SELECT a.address_id
         , a.address
         , ct.city
      FROM address a
           INNER JOIN city ct ON a.city_id = ct.city_id
     WHERE a.district = 'California'
                  ) addr ON c.address_id = addr.address_id;

-- Using the Same Table Twice
SELECT f.title
  FROM film f
       INNER JOIN film_actor fa ON f.film_id = fa.film_id
       INNER JOIN actor a ON fa.actor_id = a.actor_id
 WHERE ((a.first_name = 'CATE' AND a.last_name = 'MCQUEEN') OR (a.first_name = 'CUBA' AND a.last_name = 'BIRCH'));

SELECT f.title
  FROM film f
       INNER JOIN film_actor fa1 ON f.film_id = fa1.film_id
       INNER JOIN actor a1 ON fa1.actor_id = a1.actor_id
       INNER JOIN film_actor fa2 ON f.film_id = fa2.film_id
       INNER JOIN actor a2 ON fa2.actor_id = a2.actor_id
 WHERE (a1.first_name = 'CATE' AND a1.last_name = 'MCQUEEN')
   AND (a2.first_name = 'CUBA' AND a2.last_name = 'BIRCH');

-- Self-Joins

SELECT column_name
     , data_type
     , character_maximum_length
     , is_nullable
  FROM information_schema.columns
 WHERE table_name = 'film';

ALTER TABLE film
  ADD COLUMN prequel_film_id SMALLINT;

UPDATE film
   SET prequel_film_id = (
     SELECT film_id
       FROM film
      WHERE title LIKE 'FIDDLER%'
                         )
 WHERE film_id = (
   SELECT film_id
     FROM film
    WHERE title LIKE 'FIDDLER%'
                 );

SELECT *
  FROM film
 WHERE title LIKE 'FIDDLER%';

SELECT f.title
     , f_prnt.title prequel
  FROM film f
       INNER JOIN film f_prnt ON f_prnt.film_id = f.prequel_film_id
 WHERE f.prequel_film_id IS NOT NULL;

-- exercise
-- Write a query that returns the title of every film in which an actor
-- with the first name JOHN appeared.
SELECT f.title
  FROM film f
     , film_actor fa
 WHERE f.film_id = fa.film_id
   AND fa.actor_id IN (
   SELECT actor_id
     FROM actor
    WHERE first_name LIKE 'JOHN'
                      );

-- Construct a query that returns all address that are in the same city.
-- You will need to join the address table to itself, and each row should include two different addresses.
SELECT a1.address
     , a2.address
  FROM address a1
     , address a2
 WHERE a1.city_id = a2.city_id
   AND a1.address <> a2.address;



