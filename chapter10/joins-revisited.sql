SET search_path TO sakila, public;

-- Join Revisited

-- Outer Joins
-- In all the examples thus far that have included multiple tables,
-- we haven't been concerned that the join conditions might fail to find matches
-- for all the rows in the tables.

SELECT f.film_id
     , f.title
     , COUNT(*) num_copies
  FROM film f
       INNER JOIN inventory i ON f.film_id = i.film_id
 GROUP BY f.film_id
        , f.title;

-- While you may have expected 1,000 rows to be returned (one for each film),
-- the query returns only 958 rows. This is because the query uses an inner join
-- which only doesn't appear in the results, for example, because it doesn't have any rows
-- in the inventory table.

-- If you want the query to return all 1,000 films, regardless of whether
-- or not there are rows in the inventory table, you can use an outer join,
-- which essentially makes the join condition optional:

SELECT f.film_id
     , f.title
     , COUNT(i.inventory_id) num_copies
  FROM film f
       LEFT OUTER JOIN inventory i ON f.film_id = i.film_id
 GROUP BY f.film_id
        , f.title
 ORDER BY film_id;

-- Here's the description of the changes from the prior version of query:
-- 1. The join definition was changed from inner to left outer,
--    which instructs the server to include all rows from the table on the left side of the join
--    and then include columns from the table on right side of the join if the join is successful.
-- 2. The num_copies column definition was change from count(*) to count(i.inventory_id) which will
--    count the number of non-null values of the inventory.inventory_id column.

-- Next, let's remove the group by clause and filter out most of the rows in order to clearly
-- see the differences between inner and outer joins.

SELECT f.film_id
     , f.title
     , i.inventory_id
  FROM film f
       INNER JOIN inventory i ON f.film_id = i.film_id
 WHERE f.film_id BETWEEN 13 AND 15;


SELECT f.film_id
     , f.title
     , i.inventory_id
  FROM film f
       LEFT OUTER JOIN inventory i ON f.film_id = i.film_id
 WHERE f.film_id BETWEEN 13 AND 15
 ORDER BY film_id;

-- The results are the same for Ali Forever and Alien Center,
-- but one new row, Alice Fantasia, with a null value for the inventory.inventory_id column.

-- This example illustrates how an outer join will add column values without restricting the
-- number of rows returned by the query. If the join condition fails(as in the case of Alice Fantasia),
-- any columns retrieved from the outer-joined table will be null


-- Left Versus Right Outer Joins
-- In each of the outer join examples in the previous section,
-- I specified left outer join.
-- The keyword left indicates that the table on the left side of the join is responsible for
-- determining the number of rows in the results set, whereas the table on the right side
-- is used to provide column values whenever a match is found.
-- However, you may also specify a right outer join, in which case the table on the right side
-- of the join is responsible for determining the number of rows in the result set, whereas
-- the table on the left side is used to provide column values.

-- Here's the last query from the previous section rearranged to use a right outer join
-- instead of a left outer join.

SELECT f.film_id
     , f.title
     , i.inventory_id
  FROM inventory i
       RIGHT OUTER JOIN film f ON f.film_id = i.film_id
 WHERE f.film_id BETWEEN 13 AND 15;

-- Keep in mind that both version of the query are performing outer joins;
-- the keywords left and right are there just to tell the server which table is
-- allowed to have gaps in the data.
-- If you want to outer-join tables A and B and you want all rows from A with
-- additional columns from B whenever there is matching data, you can specify
-- either A left outer join B or B right outer join A.

-- Since you will rarely(if ever) encounter right outer joins,
-- and since not all database serves support them, I recommend that
-- you always use left outer joins. The outer join keyword is optional,
-- so you may opt for A left join B instead, but I recommend including
-- outer for the sake of clarity


-- Three-way Outer Joins
-- In some cases, you may want to outer-join one table with two other tables.
-- For example, the query from a prior section can be expanded to include data from the rental table:
SELECT f.film_id
     , f.title
     , i.inventory_id
     , r.rental_date
  FROM film f
       LEFT OUTER JOIN inventory i ON f.film_id = i.film_id
       LEFT OUTER JOIN rental r ON i.inventory_id = r.inventory_id
 WHERE f.film_id BETWEEN 13 AND 15
 ORDER BY f.film_id;

-- The results include all rentals of all films in inventory,
-- but the film Alice Fantasia has null values for the columns from both outer-joined tables.


-- Cross Joins
-- In Chapter 5, I introduced the concept of a Cartesian product, which is essentially
-- the result of joining multiple tables without specifying any join conditions.
-- Cartesian products are used fairly frequently by accident (e.g., forgetting to add the join condition
-- to the from clause) but are not so common otherwise. If, however, you do intend to generate the
-- Cartesian product of two tables, you should specify a cross join as in:
SELECT c.name category_name
     , l.name language_name
  FROM category c
       CROSS JOIN language l;

-- This query generates the Cartesian product of the category and language tables,
-- resulting 96 rows (16 category x 6 language rows). But now that you know
-- what a cross join is and how to specify it, what is it used for ?
-- Most SQL books will describe what a cross join is and then tell you that it is seldom useful,
-- but I would like to share with you a situation in which I find the cross join to be quite helpful.

-- In Chapter 9, I discussed how to use subqueries to fabricate tables.
-- The example I used showed how to build a three-row table that could be joined to other tables.
SELECT 'Small Fry' name
     , 0           low_limt
     , 74.99       high_limit
 UNION ALL
SELECT 'Average Joes' name
     , 75             low_limit
     , 149.99         high_limit
 UNION ALL
SELECT 'Heavy Hitters' name
     , 150             low_limit
     , 9999999.99      high_limit;

-- While this table was exactly what was needed for placing customers into three groups
-- based on their total film payments, this strategy of merging single-row tables using
-- the set operator union all doesn't work very well if you need to fabricate a large table.

-- Say, for example, that you want to create a query that generates a row for every day in the year of
-- 2020 but you don't have a table in your database that contains a row for every day. Using the strategy
-- from the example in Chapter 9, you could do something like the following:
SELECT '2020-01-01' dt
 UNION ALL
SELECT '2020-01-02' dt;

-- Building a query that merges together the results of 366 queries is a bit tedious,
-- so maybe a different strategy is needed. What if you generate a table with 366 rows
-- with a single column containing a number between 0 and 366 and then add that number
-- of days to January 1, 2020?

SELECT ones.num + tens.num + hundreds.num
  FROM (
         SELECT 0 num
          UNION ALL
         SELECT 1 num
          UNION ALL
         SELECT 2 num
          UNION ALL
         SELECT 3 num
          UNION ALL
         SELECT 4 num
          UNION ALL
         SELECT 5 num
          UNION ALL
         SELECT 6 num
          UNION ALL
         SELECT 7 num
          UNION ALL
         SELECT 8 num
          UNION ALL
         SELECT 9 num
       ) ones
       CROSS JOIN (
    SELECT 0 num
     UNION ALL
    SELECT 10 num
     UNION ALL
    SELECT 20 num
     UNION ALL
    SELECT 30 num
     UNION ALL
    SELECT 40 num
     UNION ALL
    SELECT 50 num
     UNION ALL
    SELECT 60 num
     UNION ALL
    SELECT 70 num
     UNION ALL
    SELECT 80 num
     UNION ALL
    SELECT 90 num
                  ) tens
       CROSS JOIN (
    SELECT 0 num
     UNION ALL
    SELECT 100 num
     UNION ALL
    SELECT 200 num
     UNION ALL
    SELECT 300 num
                  ) hundreds
 ORDER BY 1;

-- If you take the Cartesian product of the three sets {0,1,2,3,4,5,6,7,8,9},{0,10,20,30,40,50,60,70,80,90}
-- and {0,100,200,300} and add the values in the three column, you get a 400-row result set
-- containing all numbers between 0 and 399. While this is more than the 366 rows needed to generate
-- the set of days in 2020, it's easy enough to get rid of the excess rows, and I'll show you how shortly.

-- The next step is to convert the set of numbers to a set of dates. To do this, I will use the date add function
-- to add each number in the result set to January 1, 2020. Then I'll add a filter condition to throw away
-- any dates that venture into 2021:
SELECT ('2020-01-01' :: DATE + (INTERVAL '1 day' * (ones.num + tens.num + hundreds.num))):: DATE dt
  FROM (
         SELECT 0 num
          UNION ALL
         SELECT 1 num
          UNION ALL
         SELECT 2 num
          UNION ALL
         SELECT 3 num
          UNION ALL
         SELECT 4 num
          UNION ALL
         SELECT 5 num
          UNION ALL
         SELECT 6 num
          UNION ALL
         SELECT 7 num
          UNION ALL
         SELECT 8 num
          UNION ALL
         SELECT 9 num
       ) ones
       CROSS JOIN (
    SELECT 0 num
     UNION ALL
    SELECT 10 num
     UNION ALL
    SELECT 20 num
     UNION ALL
    SELECT 30 num
     UNION ALL
    SELECT 40 num
     UNION ALL
    SELECT 50 num
     UNION ALL
    SELECT 60 num
     UNION ALL
    SELECT 70 num
     UNION ALL
    SELECT 80 num
     UNION ALL
    SELECT 90 num
                  ) tens
       CROSS JOIN (
    SELECT 0 num
     UNION ALL
    SELECT 100 num
     UNION ALL
    SELECT 200 num
     UNION ALL
    SELECT 300 num
                  ) hundreds
 WHERE '2020-01-01'::DATE + (INTERVAL '1 day' * (ones.num + tens.num + hundreds.num)) < '2021-01-01'::DATE
 ORDER BY 1;

-- better way in PostgreSQL
SELECT dt::DATE
  FROM GENERATE_SERIES('2020-01-01'::DATE, '2020-12-31'::DATE, '1 day'::INTERVAL) dt
 ORDER BY 1;

-- The nice thing about this approach is that the result set automatically includes the extra
-- leap day (February 29) without your intervention, since the database server figures it out
-- when it adds 59 days to January 1, 2020

-- Now that you have a mechanism for fabricating all the days in 2020,
-- what should you do with it? Well, you might be asked to generate a report that
-- shows every day in 2020 along with the number of film rentals on that day.
-- The report needs to include every day of the year, including days when no films
-- are rented. Here's what the query might look like:
SELECT days.dt
     , COUNT(r.rental_id) num_rentals
  FROM rental r
       RIGHT OUTER JOIN (
    SELECT ('2005-01-01' :: DATE + (INTERVAL '1 day' * (ones.num + tens.num + hundreds.num))):: DATE dt
      FROM (
             SELECT 0 num
              UNION ALL
             SELECT 1 num
              UNION ALL
             SELECT 2 num
              UNION ALL
             SELECT 3 num
              UNION ALL
             SELECT 4 num
              UNION ALL
             SELECT 5 num
              UNION ALL
             SELECT 6 num
              UNION ALL
             SELECT 7 num
              UNION ALL
             SELECT 8 num
              UNION ALL
             SELECT 9 num
           ) ones
           CROSS JOIN (
        SELECT 0 num
         UNION ALL
        SELECT 10 num
         UNION ALL
        SELECT 20 num
         UNION ALL
        SELECT 30 num
         UNION ALL
        SELECT 40 num
         UNION ALL
        SELECT 50 num
         UNION ALL
        SELECT 60 num
         UNION ALL
        SELECT 70 num
         UNION ALL
        SELECT 80 num
         UNION ALL
        SELECT 90 num
                      ) tens
           CROSS JOIN (
        SELECT 0 num
         UNION ALL
        SELECT 100 num
         UNION ALL
        SELECT 200 num
         UNION ALL
        SELECT 300 num
                      ) hundreds
     WHERE '2005-01-01'::DATE + (INTERVAL '1 day' * (ones.num + tens.num + hundreds.num)) < '2006-01-01'::DATE
                        ) days ON days.dt = r.rental_date::DATE
 GROUP BY days.dt
 ORDER BY 1;

-- This is one of the more interesting queries thus far in the book,
-- in that it includes cross joins, outer joins, a date function, grouping, set operations,
-- and an aggregate function count(). It is also not the most elegant solution to the given problem,
-- but it should serve as an example of how, with a little creativity and a firm grasp on the language,
-- you can make even a seldom-used feature like cross joins a potent tool in your SQL toolkit.


-- Natural Joins
-- If you are lazy (and aren't we all), you can choose a join type that allows you to name the tables
-- to be joined but lets the database server determine what the join conditions need to be.
-- Known as the natural join, this join type relies on identical column names across multiple
-- tables to infer the proper join conditions. For example, the rental table includes a column named
-- customer_id, which is the foreign key to the customer table, whose primary key is also named
-- customer_id. Thus, you could try to write a query that uses natural join to join the two table.

SELECT c.first_name
     , c.last_name
     , r.rental_date ::DATE
  FROM customer c
       NATURAL JOIN rental r;
-- empty set returns

-- Because you specified a natural join, the server inspected the table definitions and
-- added the join condition r.customer_id = c.customer_id to join the two tables.
-- This would have worked fine, but in the Sakila schema all of the tables include the column
-- last_update to show when each row was last modified, so the server is also adding the
-- join condition r.last_update = c.last_update, which causes the query to return no data.

-- The only way around this issue is to use a subquery to restrict the columns for at least one of the tables:
SELECT cust.first_name
     , cust.last_name
     , r.rental_date :: DATE
  FROM (
         SELECT customer_id
              , first_name
              , last_name
           FROM customer
       ) cust
       NATURAL JOIN rental r;

-- So, is the reduced wear and tear on the old fingers from not having to type the join condition
-- worth the trouble? Absolutely not; you should avoid this join type and use inner joins with
-- explicit join conditions.


-- Exercise
-- Using the following table definitions and data, write a query that returns each
-- customer name along with their total payments.

SELECT c.name
     , SUM(p.amount)
  FROM customer c
       LEFT OUTER JOIN payment p ON c.customer_id = p.customer_id
 GROUP BY c.name
        , c.last_name;

-- Reformulate your query from below to use the other outer join type
-- such that the results are identical to below.
SELECT c.name
     , SUM(p.amount)
  FROM payment p
       RIGHT OUTER JOIN customer c ON c.customer_id = p.customer_id
 GROUP BY c.name
        , c.last_name;

-- Devise a query that will generate the set {1, 2, 3, ... , 99, 100}

SELECT one_num.num + ten_num.num + 1
  FROM (
    SELECT 0 num
     UNION ALL
    SELECT 1 num
     UNION ALL
    SELECT 2 num
     UNION ALL
    SELECT 3 num
     UNION ALL
    SELECT 4 num
     UNION ALL
    SELECT 5 num
     UNION ALL
    SELECT 6 num
     UNION ALL
    SELECT 7 num
     UNION ALL
    SELECT 8 num
     UNION ALL
    SELECT 9 num
       ) one_num
     , (
    SELECT 0 num
     UNION ALL
    SELECT 10 num
     UNION ALL
    SELECT 20 num
     UNION ALL
    SELECT 30 num
     UNION ALL
    SELECT 40 num
     UNION ALL
    SELECT 50 num
     UNION ALL
    SELECT 60 num
     UNION ALL
    SELECT 70 num
     UNION ALL
    SELECT 80 num
     UNION ALL
    SELECT 90 num
       ) ten_num
 ORDER BY 1;


SELECT num
  FROM GENERATE_SERIES(1, 100) num;


-- SELECT GENERATE_SERIES(0, 90, 10) ten_num
SELECT one_num + ten_num
  FROM GENERATE_SERIES(1, 10) one_num
     , GENERATE_SERIES(0, 90, 10) ten_num
 ORDER BY 1;

