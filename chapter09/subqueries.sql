SET search_path TO sakila, public;

-- Subqueries
-- A subquery is a query contained within another SQL statement (which I refer to as the containing
-- statement for the rest of this discussion). A subquery is always enclosed within parentheses,
-- and it is usually executed prior to the containing statement.

-- Like any query, a subquery returns a result set that may consist of:
-- 1. A single row with a single column
-- 2. Multiple rows with a single column
-- 3. Multiple rows having multiple columns

-- The type of result set returned by the subquery determines how it may be used and
-- which operators the containing statement may use to interact with the data the subquery returns.
-- When the containing statement has finished executing, the data returned by any subqueries is
-- discarded, making a subquery act like a temporary table with statement scope.

SELECT customer_id
     , first_name
     , last_name
  FROM customer
 WHERE customer_id = (
   SELECT MAX(customer_id)
     FROM customer
                     );

-- Subquery Types
-- Along with the differences noted previously regarding the type of result set returned by subquery,
-- you can use another feature to differentiate subqueries;
-- some subqueries are completely self-contained (called noncorrelated subqueries),
-- while other reference columns from the containing statement (called correlated subqueries).

-- Noncorrelated Subqueries
-- The example from earlier in the chapter is a noncorrelated subquery;
-- it may be executed alone and does not reference anything from the containing statement.
-- Most subqueries that you encounter will be of this type unless you are writing update or
-- delete statements, which frequently make use of correlated subqueries.

SELECT city_id
     , city
  FROM city
 WHERE country_id <> (
   SELECT country_id
     FROM country
    WHERE country = 'India'
                     );

-- Multiple-Row, Single Column Subqueries
-- If your subquery returns more than one row,
-- you will not be able to use it on one side of an equality condition.
-- However, there are four additional operators that you can use to build conditions
-- with these types of subqueries.

-- The in and not in operators
-- While you can't equate a single value to a set of values,
-- you can check to see whether a single value can be found within a set of values.
SELECT country_id
  FROM country
 WHERE country IN ('Canada', 'Mexico');

SELECT city_id
     , city.city
  FROM city
 WHERE country_id IN (
   SELECT country_id
     FROM country
    WHERE country IN ('Canada', 'Mexico')
                     );

SELECT city_id
     , city.city
  FROM city
 WHERE country_id NOT IN (
   SELECT country_id
     FROM country
    WHERE country IN ('Canada', 'Mexico')
                         );

-- The all operator
-- While the in operator is used to see whether an expression
-- can be found within a set of expressions, the all operator allows you to
-- make comparisons between a single value and every value in set.
-- To build such a condition, you will need to use one of the comparison operators
-- (=, <>, <, >, etc.) in conjunction with the all operator.

-- Moet people would prefer to phrase the query differently and avoid using the all operator.
SELECT first_name
     , last_name
  FROM customer
 WHERE customer_id <> ALL (
   SELECT customer_id
     FROM payment
    WHERE amount = 0
                          );

-- use not in
SELECT first_name
     , last_name
  FROM customer
 WHERE customer_id NOT IN (
   SELECT customer_id
     FROM payment
    WHERE amount = 0
                          );

-- another example using all operator
SELECT customer_id
     , COUNT(*)
  FROM rental
 GROUP BY customer_id
HAVING COUNT(*) > ALL (
  SELECT COUNT(*)
    FROM rental r
         INNER JOIN customer c ON r.customer_id = c.customer_id
         INNER JOIN address a ON c.address_id = a.address_id
         INNER JOIN city ct ON a.city_id = ct.city_id
         INNER JOIN country co ON ct.country_id = co.country_id
   WHERE co.country IN ('United States', 'Mexico', 'Canada')
   GROUP BY r.customer_id
                      );

-- The subquery in this example returns the total number of film rentals for all customer
-- in North America, and the containing query returns all customers
-- whose total number of film rentals exceeds any of the North American customers.

-- The any operator
-- Like the all operator, the any operator allows a value to be compared to the members
-- of a set of values; unlike all, however, a condition using the any operator evaluates to true
-- as soon as a single comparison is favorable.
-- This example will find all customers whose total film rental payments exceed the total
-- payments for all customers in Bolivia, Paraguay, or Chile:
SELECT customer_id
     , SUM(amount)
  FROM payment
 GROUP BY customer_id
HAVING SUM(amount) > ANY (
  SELECT SUM(p.amount)
    FROM payment p
         INNER JOIN customer c ON p.customer_id = c.customer_id
         INNER JOIN address a ON c.address_id = a.address_id
         INNER JOIN city ct ON a.city_id = ct.city_id
         INNER JOIN country co ON ct.country_id = co.country_id
   WHERE co.country IN ('Bolivia', 'Paraguay', 'Chile')
   GROUP BY co.country
                         );

-- THe subquery returns the total film rental fees for all customers in Bolivia,
-- Paraguay, and Chile, and the containing query returns all customers who outspent at least
-- one of these three countries

-- Although most people prefer to use in, using = any is equivalent to
-- using the in operator

-- Multicolumn Subqueries
-- So far, the subquery examples in this chapter have returned a single column and
-- one or more rows. In certain situations, however, you can use subqueries that return
-- two or more columns. To show the utility of multicolumn subqueries,
-- it might help to look first at an example that uses multiple, single-column subqueries:
SELECT fa.actor_id
     , fa.film_id
  FROM film_actor fa
 WHERE fa.actor_id IN (
   SELECT actor_id
     FROM actor
    WHERE last_name = 'MONROE'
                      )
   AND fa.film_id IN (
   SELECT film_id
     FROM film
    WHERE rating = 'PG'
                     );
-- This query uses two subqueries to identify all actors with the last name Monroe
-- and all films rated PG, and the containing query then uses this information to retrieve all
-- cases where an actor named Monroe appeared in a PG film.
-- However, you could merge the two single-column subqueries into one multicolumn
-- subquery and compare the results to two columns in the film_actor table.
-- To do so, your filter condition must name both columns from the film_actor table
-- surrounded by parentheses and in the same order as returned by the subquery, as in:
SELECT actor_id
     , film_id
  FROM film_actor
 WHERE (actor_id, film_id) IN (
   SELECT a.actor_id
        , f.film_id
     FROM actor a
          CROSS JOIN film f
    WHERE a.last_name = 'MONROE'
      AND f.rating = 'PG'
                              );

-- This version of the query performs the same function as the previous example,
-- but with a single subquery that returns two columns instead of two subqueries
-- that each return a single column.
-- The subquery in this version uses a type of join called a cross join,
-- which will be explored in the next chapter.


-- Correlated Subqueries
-- All of the subqueries shown thus far have been independent of their containing statements,
-- meaning that you can execute them by themselves and inspect the results.
-- A correlated subquery, on the other hand, is dependent on its containing statement from which
-- it references one or more columns.
-- Unlike a noncorrelated subquery, a correlated subquery is not executed once prior to execution
-- of the containing statement; instead, the correlated subquery is executed once for each candidate row
-- (rows that might be included in the final results).

-- For example, the following query uses a correlated subquery to count the number of film
-- rentals for each customer, and the containing query then retrieves those customers
-- who have rented exactly 20 films.

SELECT c.first_name
     , c.last_name
  FROM customer c
 WHERE 20 = (
   SELECT COUNT(*)
     FROM rental r
    WHERE r.customer_id = c.customer_id
            );
-- The reference to c.customer_id at the very end of the subquery is what makes the subquery correlated;
-- the containing query must supply values for c.customer_id for the subquery to execute.
-- In this case, the containing query retrieves all 599 rows from the customer table
-- and executes the subquery once for each customer, passing in the appropriate customer ID for each execution.
-- If the subquery returns the value 20, then the filter condition is met, and the row is added to the result set.

-- One word of caution: since the correlated subquery will be executed once for each row of the containing
-- query, the use of correlated subqueries can cause performance issues if the containing
-- query returns a large number of rows.

-- Along with equality conditions, you can use correlated subqueries in other types of conditions,
-- such as the range condition illustrated here:
SELECT c.first_name
     , c.last_name
  FROM customer c
 WHERE (
         SELECT SUM(p.amount)
           FROM payment p
          WHERE p.customer_id = c.customer_id
       ) BETWEEN 180 AND 240;

-- This variation on the previous query finds all customers whose total payments for all film
-- rentals are between $180 and $240.
-- Once again, the correlated subquery is executed 500 times,
-- and each execution of the subquery returns the total account balance for the given customer.

-- The exists Operator
-- While you will often see correlated subqueries used in equality and range conditions,
-- the most common operator used to build conditions that utilize correlated subqueries
-- is the exists operator. You use the exists operator when you want to identify that
-- a relationship exists without regard for the quantity;

-- for example, the following query finds all the customers who rented at least on film prior to
-- May 25, 2025, without regard for how many films were rented:
SELECT c.first_name
     , c.last_name
  FROM customer c
 WHERE EXISTS (
   SELECT 1
     FROM rental r
    WHERE r.customer_id = c.customer_id
      AND r.rental_date:: DATE < '2005-05-25'
              );

-- Using the exists operator, your subquery can return zero, one, or many rows, and the condition
-- simply checks whether the subquery returned one or more rows.
-- If you look at the select clause of the subquery, you will see that it consists of a single literal(1);
-- since the condition in the containing query only needs to know how many rows have been returned,
-- the actual data the subquery returned is irrelevant.
-- Your subquery can return whatever strikes your fancy, as demonstrated next:
SELECT c.first_name
     , c.last_name
  FROM customer c
 WHERE EXISTS (
   SELECT r.rental_date
        , r.customer_id
        , 'ABCD'    str
        , 2 * 3 / 7 nmbr
     FROM rental r
    WHERE r.customer_id = c.customer_id
      AND r.rental_date:: DATE < '2005-05-25'
              );

-- However, the convention is to specify either select 1 or select * when using exists.

-- You may also use not exists to check for subqueries that return no rows, as demonstrated by the following:
SELECT a.first_name
     , a.last_name
  FROM actor a
 WHERE NOT EXISTS (
   SELECT 1
     FROM film_actor fa
          INNER JOIN film f ON f.film_id = fa.film_id
    WHERE fa.actor_id = a.actor_id
      AND f.rating = 'R'
                  );

-- Data Manipulation Using Correlated Subqueries

-- Subqueries are used heavily in update, delete, and insert statements as well,
-- with correlated subqueries appearing frequently in update and delete statements.
UPDATE customer c
   SET last_update = (
     SELECT MAX(r.rental_date)
       FROM rental r
      WHERE r.customer_id = c.customer_id
                     );
-- This statement modifies every row in the customer table (since there is no where clause)
-- by finding the latest rental date for each customer in the rental table.

-- While it seems reasonable to expect that every customer will have at least one film rental,
-- it would be best to check before attempting to update the last_update column;
-- otherwise, the column will be set to null, since the subquery would return no rows.

-- Here's another version of the update statement, this time employing a where clause
-- with a second correlated subquery:
UPDATE customer c
   SET c.last_update = (
     SELECT MAX(r.rental_date)
       FROM rental r
      WHERE r.customer_id = c.customer_id
                       )
 WHERE EXISTS (
   SELECT 1
     FROM rental r
    WHERE r.customer_id = c.customer_id
              );
-- The two correlated subqueries are identical except for the select clauses.
-- The subquery in the set clause, however, executes only if the condition in the update
-- statement's where clause evaluates to true(meaning that at least one rental was found
-- for the customer), thus protecting the data in the last_update column from being
-- overwritten with a null


-- When to Use Subqueries

-- Subqueries as Data Sources
-- Subquery generates a result set containing rows and columns of data,
-- it is perfectly valid to include subqueries in your from clause along with tables.
-- Although it might, at first glance, seem like an interesting feature
-- without much practical merit, using subqueries alongside tables is one of the most
-- powerful tools available when writing queries.

SELECT c.first_name
     , c.last_name
     , pymnt.num_rentals
     , pymnt.tot_payments
  FROM customer c
       INNER JOIN (
    SELECT customer_id
         , COUNT(*)    num_rentals
         , SUM(amount) tot_payments
      FROM payment
     GROUP BY customer_id
                  ) pymnt ON c.customer_id = pymnt.customer_id;

-- In this example, a subquery generates a list of customers IDs slong with the number of
-- film rentals and the total payments.
-- Here's the result set generated by the subquery:
SELECT customer_id
     , COUNT(*)    num_rentals
     , SUM(amount) tot_payments
  FROM payment
 GROUP BY customer_id;

-- The subquery is given the name pymnt and is joined to the customer table via the customer_id
-- column. The containing query then retrieves the customer's name from the customer table,
-- along with the summary columns from the pymnt subquery.

-- Subqueries used in the from clause must be noncorrelated; they are executed first,
-- and the data is held in memory until the containing query finished execution.
-- Subqueries offer immense flexibility when writing queries, because you can go far beyond
-- the set of available tables to create virtually any view of the data that you desire and then join
-- the results to other tables or subqueries. If you are writing reports or generating data feeds
-- to external systems, you may be able to do things with a single query that used to demand
-- multiple queries or a procedural language to accomplish

-- Data fabrication
-- Along with using subqueries to summarize existing data, you can use subqueries to
-- generate data that doesn't exist in any form within your database.

-- To generate these groups within a single query, you will need a way to define these three groups.
-- The first step is to define a query that generates the group definitions:
SELECT 'Small Fry' name
     , 0           low_limit
     , 74.99       high_limit
 UNION ALL
SELECT 'Average Joes' name
     , 75             low_limit
     , 149.99         high_limit
 UNION ALL
SELECT 'Heavy Hitters' name
     , 150             low_limit
     , 9999999.99      high_limit;

-- Now we have a query to generate the desired groups,
-- and you can place it into the from clause of another query to generate your customer groups:
SELECT pymnt_grps.name
     , COUNT(*) num_customers
  FROM (
         SELECT customer_id
              , COUNT(*)    num_rentals
              , SUM(amount) tot_payments
           FROM payment
          GROUP BY customer_id
       ) pymnt
       INNER JOIN (
    SELECT 'Small Fry' name
         , 0           low_limit
         , 74.99       high_limit
     UNION ALL
    SELECT 'Average Joes' name
         , 75             low_limit
         , 149.99         high_limit
     UNION ALL
    SELECT 'Heavy Hitters' name
         , 150             low_limit
         , 9999999.99      high_limit
                  ) pymnt_grps ON pymnt.tot_payments BETWEEN pymnt_grps.low_limit AND pymnt_grps.high_limit
 GROUP BY pymnt_grps.name;


-- you could simply decide to build a permanent (or temporary) table to hold the group definitions
-- instead of using a subquery. Using that approach, you would find your database to be littered
-- with small special-purpose tables after a while, and you wouldn't remember the reason
-- for which most of them were created. Using subqueries, however, you will be able to
-- adhere to a policy where tables are added to a database only when there is a clear
-- business need to store new data.

-- Task-oriented subqueries

SELECT c.first_name
     , c.last_name
     , ct.city
     , SUM(p.amount) tot_payments
     , COUNT(*)      tot_rentals
  FROM payment p
       INNER JOIN customer c ON p.customer_id = c.customer_id
       INNER JOIN address a ON p.customer_id = c.customer_id
       INNER JOIN city ct ON a.city_id = ct.city_id
 GROUP BY c.first_name
        , c.last_name
        , ct.city;

-- This query returns the desired data, but if you look at the query closely, you will see
-- that the customer, address, and city tables are needed only for display purpose and that
-- the payment table has everything needed to generate the groupings (customer_id and amount)
-- Therefore, you could separate out the task of generating the groups into a subquery and
-- then join the other three tables to the table generated by the subquery to achieve
-- the desired end result.
SELECT customer_id
     , COUNT(*)    tot_rentals
     , SUM(amount) tot_payments
  FROM payment
 GROUP BY customer_id;

-- This is the heart of the query; the other tables are needed only to provide
-- meaningful strings in place of the customer_id value.
SELECT c.first_name
     , c.last_name
     , ct.city
  FROM (
         SELECT customer_id
              , COUNT(*)    tot_rentals
              , SUM(amount) tot_payments
           FROM payment
          GROUP BY customer_id
       ) pymnt
       INNER JOIN customer c ON pymnt.customer_id = c.customer_id
       INNER JOIN address a ON c.address_id = a.address_id
       INNER JOIN city ct ON a.city_id = ct.city_id;

-- This version of the query to be far more satisfying than the big, flat version.
-- This version may execute faster as well,
-- because the grouping is being done on a single numeric column (customer_id)
-- instead of multiple lengthy string columns (customer.first_name, customer.last_name, city.city)

-- Common table expressions
-- Common table expressions(a.k.a CTEs) is a named subquery that appears at the top of a query
-- in a with clause, which can contain multiple CTEs separated by commas.
-- Along with making queries more understandable, this feature also allows each CTE to refer to any
-- other CTE defined above it in the same with clause.
-- The following example includes three CTEs, where the second refers to the first, and the third refers to the second:

  WITH actors_s AS (
    SELECT actor_id
         , first_name
         , last_name
      FROM actor
     WHERE last_name LIKE 'S%'
                   )
     , actors_s_pg AS (
    SELECT s.actor_id
         , s.first_name
         , s.last_name
         , f.film_id
         , f.title
      FROM actors_s s
           INNER JOIN film_actor fa ON s.actor_id = fa.actor_id
           INNER JOIN film f ON f.film_id = fa.film_id
     WHERE f.rating = 'PG'
                   )
     , actor_s_pg_revenue AS (
    SELECT spg.first_name
         , spg.last_name
         , p.amount
      FROM actors_s_pg spg
           INNER JOIN inventory i ON i.film_id = spg.film_id
           INNER JOIN rental r ON i.inventory_id = r.inventory_id
           INNER JOIN payment p ON r.rental_id = p.rental_id
                   )
SELECT spg_rev.first_name
     , spg_rev.last_name
     , SUM(spg_rev.amount) tot_revenue
  FROM actor_s_pg_revenue spg_rev
 GROUP BY spg_rev.first_name
        , spg_rev.last_name
 ORDER BY 3 DESC;

-- This query calculates the total revenues generated from PG-rated film
-- rentals where the cast includes an actor whose last name starts with S.
-- The first subquery (actors_s) finds all actors whose last name starts with S,
-- the second subquery (actors_s_pg) joins that data set to the film table and
-- filters on films having a PG rating, and the third subquery (actors_s_pg_revenue) joins that
-- data set to the payment table to retrieve the amounts paid to rent any of these films.
-- The final query simply groups the data from actors_s_pg_revenue by first/last names and
-- sums the revenues

-- Those who tend to utilize temporary tables to store query results
-- for use in subsequent queries may find CTEs an attractive alternative.


-- Subqueries as Expression Generators
-- Along with being used in filter conditions, scalar subqueries may be used wherever
-- an expression can appear, including the select and order by clauses of a query and the
-- values clause of an insert statement.

SELECT (
  SELECT c.first_name
    FROM customer c
   WHERE c.customer_id = p.customer_id
       )             first_name
     , (
  SELECT c.last_name
    FROM customer c
   WHERE c.customer_id = p.customer_id
       )             last_name
     , (
  SELECT ct.city
    FROM customer c
         INNER JOIN address a ON c.address_id = a.address_id
         INNER JOIN city ct ON a.city_id = ct.city_id
   WHERE c.customer_id = p.customer_id
       )             city
     , SUM(p.amount) tot_payments
     , COUNT(*)      tot_rentals
  FROM payment p
 GROUP BY p.customer_id;

-- There are two main differences between this query and the earlier version using a subquery in the from clause:
-- 1. Instead of joining the customer, address, and city tables to the payment data,
-- correlated scalar subqueries are used in the select clause to look up the customer's first/last names and city
-- 2. The customer table is accessed three times (once in each of the three subqueries) rather than just once

-- The customer table is accessed three times because scalar subqueries can return only a single column and row,
-- so if we need three columns related to the customer, it is necessary to use three different subqueries.

-- Scalar subqueries can also appear in the order by clause.
-- The following query retrieves an actor's first and last names and sorts by the number of
-- films in which the actor appeared:
SELECT a.actor_id
     , a.first_name
     , a.last_name
  FROM actor a
 ORDER BY (
            SELECT COUNT(*)
              FROM film_actor fa
             WHERE fa.actor_id = a.actor_id
          ) DESC;

-- The query uses a correlated scalar subquery in the order by clause to return just the
-- number of film appearances, and this value is used solely for sorting purpose.

-- Along with using correlated scalar subqueries in select statements, you can use
-- noncorrelated scalar subqueries to generate values for an insert statement.
-- For example, let's say you are going to generate a new row in the film_actor table,
-- and you've been given the following data:
-- 1. The first and last name of the actor
-- 2. The name of the film

-- You have two choices for how to go about it:
-- 1. execute two queries to retrieve the primary key values from film and actor
-- and place those values into an insert statement or
-- 2. use subqueries to retrieve the two key values from within an insert statement.

INSERT
  INTO film_actor (actor_id, film_id, last_update)
VALUES ((
          SELECT actor_id
            FROM actor
           WHERE first_name = 'JENNIFER'
             AND last_name = 'DAVIS'
        ), (
          SELECT film_id
            FROM film
           WHERE title = 'ACE GOLDFINGER'
           ), NOW());


-- Exercise
-- Construct a query against the film table that uses a filter condition with a noncorrelated subquery
-- against the category table to find all action films (category.name = 'Action')

SELECT film_id
  FROM film
 WHERE film_id IN (
   SELECT film_id
     FROM film_category
    WHERE category_id = (
      SELECT category_id
        FROM category
       WHERE name = 'Action'
                        )
                  );

-- rework the query below using a correlated subquery against the
-- category and film_category tables to achieve the same results.

SELECT film_id
  FROM film f
 WHERE EXISTS (
   SELECT 1
     FROM film_category fc
          INNER JOIN category c ON fc.category_id = c.category_id
    WHERE fc.film_id = f.film_id
      AND c.name = 'Action'
              );

-- Join the following query to a subquery against the film_actor table to show the level of each actor:
-- The subquery against the film_actor table should count the number of rows for each actor
-- using group by actor_id. and the count should be compared to the min_roles/max_roles
-- columns to determine which level each actor belongs to.


SELECT actor_id
     , lev.level
  FROM (
         SELECT actor_id
              , COUNT(film_id) roles_count
           FROM film_actor
          GROUP BY actor_id
       ) fa
       INNER JOIN (
    SELECT 'Hollywood Star' level
         , 30               min_roles
         , 99999            max_roles
     UNION ALL
    SELECT 'Prolific actor' level
         , 20               min_roles
         , 29               max_roles
     UNION ALL
    SELECT 'Newcomer' level
         , 1          min_roles
         , 19         max_roles
                  ) lev ON fa.roles_count BETWEEN lev.min_roles AND lev.max_roles;


