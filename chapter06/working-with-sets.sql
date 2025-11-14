ntersection will be an empty set.
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
