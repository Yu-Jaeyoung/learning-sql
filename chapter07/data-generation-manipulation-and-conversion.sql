his is a piece of extremely long varchar data';

-- Including single quotes
-- To make the server ignore the apostrophe in the word, you will need to add an escape to
-- the string so that the server treats the apostrophe like any other character in the string
UPDATE string_tbl
   SET text_fld = 'This string didn''t work, but it does now';

UPDATE string_tbl
   SET text_fld = E'This string didn\'t work, but it does now';

-- Including special characters
SELECT 'abcdefg'
     , CHR(97) || CHR(98) || CHR(99) || CHR(100) || CHR(101) || CHR(102) || CHR(103);

-- use concant()
SELECT CONCAT('danke sch', CHR(246), 'n');

-- to find its ASCII equivalent
SELECT ASCII('ö');

-- String Manipulation
DELETE
  FROM string_tbl;

INSERT
  INTO string_tbl (char_fld, vchar_fSET search_path TO sakila, public;

-- Working with String Data
-- CHAR
-- - Holds fixed-length, blank-padded strings.
-- varchar
-- - Holds variable-length strings.
-- text
-- Holds ver large variable-length strings

CREATE TABLE string_tbl
(
  char_fld  CHAR(30),
  vchar_fld VARCHAR(30),
  text_fld  TEXT
);

-- String Generation
-- The simples way to populate a character column is to enclose a string in quotes
INSERT
  INTO string_tbl (char_fld, vchar_fld, text_fld)
VALUES ('This is char data', 'This is varchar data', 'This is text data');

-- When inserting string data into a table, remeber that if the length of the string
-- exceeds the maximum size for the character column, the server will throw an exception
UPDATE string_tbl
   SET vchar_fld = 'Tld, text_fld)
VALUES ( 'This string is 28 characters', 'This string is 29 characters'
       , 'This string is 29 characters');

-- String functions that return numbers
SELECT LENGTH(char_fld)  char_length
     , LENGTH(vchar_fld) varchar_length
     , LENGTH(text_fld)  text_length
  FROM string_tbl;

-- find the location of a substring within a string
SELECT POSITION('characters' IN vchar_fld)
  FROM string_tbl;

SELECT STRPOS(vchar_fld, 'is')
  FROM string_tbl;

-- position of the string 'is' starting at the fifth character in the vchar_fld column
-- case 1
SELECT vchar_fld
     , REGEXP_INSTR(vchar_fld, 'is', 1, 2)
  FROM string_tbl;

-- case 2
SELECT CASE
         WHEN STRPOS(SUBSTRING(vchar_fld, 5), 'is') > 0 THEN STRPOS(SUBSTRING(vchar_fld, 5), 'is') + 4
         ELSE 0 END AS position
  FROM string_tbl;

-- start in position 5, use substring
SELECT SUBSTRING(vchar_fld, 5)
  FROM string_tbl;

-- make MySQL strcmp() function
-- MySQL's strcmp() function is case insensitive
CREATE OR REPLACE FUNCTION strcmp(str1 TEXT, str2 TEXT) RETURNS INT AS
$$
BEGIN
  IF UPPER(str1) = UPPER(str2) THEN RETURN 0; ELSIF UPPER(str1) < UPPER(str2) THEN RETURN -1; ELSE RETURN 1; END IF;
END;
$$ LANGUAGE plpgsql IMMUTABLE;

SELECT strcmp('12345', '12345') "12345_12345"
     , strcmp('abcd', 'xyz')
     , strcmp('abcd', 'QRSTUV')
     , strcmp('qrstuv', 'QRSTUV')
     , strcmp('12345', 'xyz')
     , strcmp('xyz', 'qrstuv');


-- usage example of like and regexp in select clause
SELECT name
     , name LIKE '%y' ends_in_y
  FROM category;

SELECT name
     , name ~ 'y$' AS ends_in_y
  FROM category;

SELECT name
     , REGEXP_LIKE(name, 'y$') AS ends_in_y
  FROM category;

-- String functions that return strings

INSERT
  INTO string_tbl(text_fld)
VALUES ('This string was 29 characters');

UPDATE string_tbl
   SET text_fld = CONCAT(text_fld, ', but now it is longer');

SELECT text_fld
  FROM string_tbl;

-- concat() function generally use to build a string from individual pieces of data.
SELECT CONCAT(first_name, ' ', last_name, ' has been a customer since ', create_date::DATE) cust_narrative
  FROM customer;


-- extracts five characters from string starting at the ninth position
SELECT SUBSTR('goodbye cruel world', 9, 5);


-- Working with Numeric Data
SELECT (37 * 59) / (78 - (8 * 6));

-- modulo operator, which calculates the remainder when one number is divided into another number
SELECT MOD(10, 4);

SELECT MOD(22.75, 5);

-- pow() function, which returns one number raised to the power of a second number
SELECT pow(2, 8)  kilobyte
     , pow(2, 20) megabyte
     , pow(2, 30) gigabyte
     , pow(2, 40) terabyte;


-- Controlling Number Precision
-- ceil() and floor() functions are used to round either up or down to the closest integer
SELECT CEIL(72.445)
     , FLOOR(72.445);

-- ceil() will round up even if the decimal portion of a number is very small,
-- floor() will round down even if the decimal portion is quite significant
SELECT CEIL(72.00000000001)
     , FLOOR(72.99999999999);

-- use round() function to round up or down from the midpoint between two integers
SELECT ROUND(72.49999)
     , ROUND(72.5)
     , ROUND(72.50001);


-- use the second argument to round the number 72.0909 to one, two, and three decimal places
SELECT ROUND(72.0909, 1)
     , ROUND(72.0909, 2)
     , ROUND(72.0909, 3);

-- Like the round() function, truncate() function allows an optional second argument to specify the number of digits
-- to the right of the decimal, but truncate() simply discards the unwanted digits without rounding.
SELECT TRUNC(72.0909, 1)
     , TRUNC(72.0909, 2)
     , TRUNC(72.0909, 3);

-- Both truncate() and round() also allow a negative value for the second argument,
-- meaning that numbers to the lef of the decimal place are truncated or rounded.
SELECT ROUND(17, -1)
     , TRUNC(17, -1);

-- Handling Signed Data
-- If you are working with numeric columns that allow negative values, several numeric functions
-- might be of use. Let's say, for example, that you are asked to generate a report showing the
-- current status of a set of bank accounts using the following data from the account table:
CREATE TABLE account
(
  account_id NUMERIC,
  acct_type  VARCHAR(20),
  balance    NUMERIC
);

INSERT
  INTO account(account_id, acct_type, balance)
VALUES (123, 'MONEY MARKET', 785.22)
     , (456, 'SAVINGS', 0.00)
     , (789, 'CHECKING', -324.22);


-- following query returns three columns useful for generating the report:
-- sign() function return -1 if the account balance is negative, 0 if the account balance is zero,
-- and 1 if the account balance is positive.
-- abs() returns absolute value of the account balance
SELECT account_id
     , SIGN(balance)
     , ABS(balance)
  FROM account;


-- Working with Temporal Data
SHOW TIMEZONE;

-- Generating Temporal Data
-- string-to-date conversions

SELECT ('2025-11-16 15:30:00'::TIMESTAMP);

SELECT ('2025-11-16'::DATE)    date_field
     , ('108:17:57'::INTERVAL) time_field;


-- functions for generating dates
SELECT TO_DATE('November 17, 2025', 'Month DD, YYYY');

SELECT TO_DATE('Nov 17, 2025', 'Mon DD, YYYY');

SELECT TO_DATE('Monday, November 17, 2025', 'Day, Month DD, YYYY');

SELECT TO_TIMESTAMP('November 17, 2025 14:30:00', 'Month DD, YYYY HH24:MI:SS');

-- Manipulating Temporal Data
-- Temporal functions that return dates
SELECT CURRENT_DATE + INTERVAL '5 days';

SELECT NOW() + INTERVAL '5 days';

SELECT CURRENT_DATE + 5;

-- last day of current month
SELECT (DATE_TRUNC('month', CURRENT_DATE) + INTERVAL '1 month - 1 day')::DATE;

SELECT DATE_TRUNC('YEAR', '2019-09-08'::DATE)::DATE;

-- EXTRACT: sunday=0, saturday=6
SELECT EXTRACT(DOW FROM CURRENT_DATE);

-- Monday
SELECT TO_CHAR(CURRENT_DATE, 'Day');
SELECT TO_CHAR(CURRENT_DATE, 'FMDay');

-- Mon
SELECT TO_CHAR(CURRENT_DATE, 'Dy');

-- monday
SELECT TO_CHAR(CURRENT_DATE, 'day');

-- MONDAY
SELECT TO_CHAR(CURRENT_DATE, 'DAY');

-- Exercise
-- write a query that returns the 17th through 25th characters of the string
-- 'Please find the substring in this string.'

SELECT SUBSTR('Please find the substring in this string.', 17, 25);

-- write a query that returns the absolute value and sign(-1, 0 or 1) of the number
-- -25.76823. Also return the number rounded to the nearest hundredth.
SELECT ABS(-25.76823)
     , SIGN(-25.76823)
     , ROUND(-25.76823, 1);

-- write a query to return just the month portion of the current date.
SELECT TO_CHAR(CURRENT_DATE, 'Month');


