SET search_path TO sakila, public;

-- Set Theory in Practice
-- When dealing with actual data, there is a need to describe the composition of the data sets
-- involved if they are to be combined.

SELECT *
  FROM information_schema.columns
 WHERE table_name = 'customer';

SELECT *
  FROM information_schema.columns
 WHERE table_name = 'city';

-- Therefore, when performing set operations on two data sets, the following guidelines must apply:
-- 1. Both data sets must have the same number of columns.
-- 2. The data types of each column across the two data sets must be the same(or the server
--    must be able to convert one to the other).


-- You perform a set operation by placing a set operator between two select statements,
-- as demonstrated by the following:

SELECT 1     num
     , 'abc' str
 UNION
SELECT 9     num
     , 'xyz' str;

-- Each of the individual queries yields a data set consisting of a single row having a numeric
-- column and a string column. The set operator, which in this case is union, tells the database server
-- to combine all rows from the two sets. Thus, the final set includes two rows of two columns.
-- This query is known as a compound query because it comprises multiple, otherwise-independent queries.
-- As you will see later, compound queries may include more than two queries if multiple set operations
-- are needed to attain the final results.

-- Set Operators
-- The union Operator
-- The union and union all operators allow you to combine multiple data sets.
-- The differSET search_path TO sakila, public;

-- Set Theory in Practice
-- When dealing with actual data, there is a need to describe the composition of the data sets
-- involved if they are to be combined.

SELECT *
  FROM information_schema.columns
 WHERE table_name = 'customer';

SELECT *
  FROM information_schema.columns
 WHERE table_name = 'city';

-- Therefore, when performing set operations on two data sets, the following guidelines must apply:
-- 1. Both data sets must have the same number of columns.
-- 2. The data types of each column across the two data sets must be the same(or the server
--    must be able to convert one to the other).


-- You perform a set operation by placing a set operator between two select statements,
-- as demonstrated by the ence between the two is that union sorts the combined set and removes duplicates,
-- whereas union all does not. With union all, the number of rows in the final data set will
-- always equal the sum of the number of rows in the sets being combined.
-- This operation is the simplest set operation to perform (from the server's point of view),
-- since there is no need for the server to check for overlapping data.

SELECT 'CUST' typ
     , c.first_name
     , c.last_name
  FROM customer c
 UNION ALL
SELECT 'ACTR' type
     , a.first_name
     , a.last_name
  FROM actor a;

SELECT c.first_name
     , c.last_name
  FROM customer c
 WHERE c.first_name LIKE 'J%'
   AND c.last_name LIKE 'D%'
 UNION ALL
SELECT a.first_name
     , a.last_name
  FROM actor a
 WHERE a.first_name LIKE 'J%'
   AND a.last_name LIKE 'D%';


-- exclude duplicate rows,
SELECT c.first_name
     , c.last_name
  FROM customer c
 WHERE c.first_name LIKE 'J%'
   AND c.last_name LIKE 'D%'
 UNION
SELECT a.first_name
     , a.last_name
  FROM actor a
 WHERE a.first_name LIKE 'J%'
   AND a.last_name LIKE 'D%';

-- The intersect Operator
-- If the two queries in a compound query return nonoverlapping data sets,
-- then the intersection will be an empty set.
   SELECT c.first_name
        , c.last_name
     FROM customer c
    WHERE c.first_name LIKE 'D%'
      AND c.last_name LIKE 'T%'
INTERSECT
   SELECT a.first_name
        , a.last_name
     FROM actor a
    WHERE a.first_name LIKE 'D%'
      AND a.last_name LIKE 'T%';

-- if name was founded in both results sets,
-- yields data
   SELECT c.first_name
        , c.last_name
     FROM customer c
    WHERE c.first_name LIKE 'J%'
      AND c.last_name LIKE 'D%'
INTERSECT
   SELECT a.first_name
        , a.last_name
     FROM actor a
    WHERE a.first_name LIKE 'J%'
      AND a.last_name LIKE 'D%';

-- The except Operator
-- The except operator returns the first result set minus any overlap with the second result set.
SELECT a.fiSET search_path TO sakila, public;

SELECT 1     num
     , 'abc' str
 UNION
SELECT 9     nnum
     , 'xyz' str;

-- Set Operators
-- The union Operator
-- union all operator doesn't remove duplicates
SELECT 'CUST' typ
     , c.first_name
     , c.last_name
  FROM customer c
 UNION ALL
SELECT 'ACTR' typ
     , a.first_name
     , a.last_name
  FROM actor a;

-- to exclude duplicate rows, use union operator
SELECT c.first_name
     , c.last_name
  FROM customer c
 WHERE c.first_name LIKE 'J%'
   AND c.last_name LIKE 'D%'
 UNION
SELECT a.first_name
     , a.last_name
  FROM actor a
 WHERE a.first_name LIKE 'J%'
   AND a.last_name LIKE 'D%';

-- The intersect Operator
-- if the two queries in a compound query return nonoverlapping data sets,
-- then the irst_name
     , a.last_name
  FROM actor a
 WHERE a.first_name LIKE 'J%'
   AND a.last_name LIKE 'D%'
EXCEPT
SELECT c.first_name
     , c.last_name
  FROM customer c
 WHERE c.first_name LIKE 'J%'
   AND c.last_name LIKE 'D%';

-- Set Operation Rules
-- Sorting Compound Query Results
-- add an order by clause after the last query
-- recommend giving the columns in both queries identical column aliases
SELECT c.first_name fname
     , c.last_name  lname
  FROM customer c
 WHERE c.first_name LIKE 'J%'
   AND c.last_name LIKE 'D%'
 UNION ALL
SELECT a.first_name
     , a.last_name
  FROM actor a
 WHERE a.first_name LIKE 'J%'
   AND a.last_name LIKE 'D%'
 ORDER BY lname
        , fname;


-- Set Operation Precedence
-- If your compound query contains more than two queries using different set operators,
-- you need to think about the order in which to place the queries in your compound statement
-- to achieve the desired results.
SELECT a.first_name
     , a.last_name
  FROM actor a
 WHERE a.first_name LIKE 'J%'
   AND a.last_name LIKE 'D%'
 UNION ALL
SELECT a.first_name
     , a.last_name
  FROM actor a
 WHERE a.first_name LIKE 'M%'
   AND a.last_name LIKE 'T%'
 UNION
SELECT c.first_name
     , c.last_name
  FROM customer c
 WHERE c.first_name LIKE 'J%'
   AND c.last_name LIKE 'D%';

-- In general, compound queries containing three or more queries are evaluated in order from top to bottom,
-- but with the following caveats:
-- 1. The ANSI SQL specification calls for the intersect operator to have precedence over the other set operators
-- 2. You may dictate the order in which queries are combined by enclosing multiple queries in parentheses.
SELECT a.first_name
     , a.last_name
  FROM actor a
 WHERE a.first_name LIKE 'J%'
   AND a.last_name LIKE 'D%'
 UNION
(
  SELECT a.first_name
       , a.last_name
    FROM actor a
   WHERE a.first_name LIKE 'M%'
     AND a.last_name LIKE 'T%'
   UNION ALL
  SELECT c.first_name
       , c.last_name
    FROM customer c
   WHERE c.first_name LIKE 'J%'
     AND c.last_name LIKE 'D%'
);

-- exercise
-- Write a compound query that finds the first and last names of all actors and customers
-- whose last name start with L.

SELECT a.first_name
     , a.last_name
  FROM actor a
 WHERE a.last_name LIKE 'L%'
 UNION ALL
SELECT c.first_name
     , c.last_name
  FROM customer c
 WHERE c.last_name LIKE 'L%';

-- Sort the results from upper results by the last_name column
SELECT a.first_name
     , a.last_name
  FROM actor a
 WHERE a.last_name LIKE 'L%'
 UNION ALL
SELECT c.first_name
     , c.last_name
  FROM customer c
 WHERE c.last_name LIKE 'L%'
 ORDER BY last_name;
