-- BAD
CREATE TABLE persons
(
  id INT,
  first_name VARCHAR(50),
  last_name VARCHAR(50),
  gender VARCHAR(7),
  -- date_of_birth TIMESTAMP,
  date_of_birth DATE
);

-- GOOD
CREATE TABLE persons
(
  id BIGSERIAL NOT NULL PRIMARY KEY,
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  gender VARCHAR(7) NOT NULL,
  date_of_birth TIMESTAMP NOT NULL
);

-- CHANGE DATATYPE OF A COLUMN
ALTER TABLE persons ALTER COLUMN date_of_birth TYPE
DATE;

-- INSERT
INSERT INTO persons
  (first_name, last_name, gender, date_of_birth)
VALUES
  ('Foyez', 'Ahmed', 'male', date
'1993-08-05');

-- ADD A COLUMN IN AN EXISTING TABLE
ALTER TABLE persons ADD COLUMN email VARCHAR
(40);

-- UPDATE A COLUMN
UPDATE persons SET email='foyez@email.com' WHERE id=1;

-- Add 1000 Rows from mockaroo.com
-- \i /path/file_name.sql

-- Select first_name & last_name of first 10 item order by first_name
SELECT first_name, country_of_birth
FROM persons
ORDER BY country_of_birth DESC
LIMIT 10;

-- Select distinct countries
SELECT DISTINCT country_of_birth
FROM persons;

-- WHERE clause AND
SELECT *
FROM persons
WHERE gender='Male' AND (country_of_birth='Bangladesh' OR country_of_birth='China');

-- COMPARISONS
-- equal =, greater than >, greater than or equal >=, less than <, less than or equal <=, not equal <>

-- LIMIT, OFFSET & FETCH
SELECT *
FROM persons OFFSET
5 LIMIT 5;
SELECT *
FROM persons OFFSET
5
FETCH FIRST 5 ROW ONLY;

-- IN
SELECT *
FROM persons
WHERE country_of_birth IN ('China', 'France');

-- BETWEEN
SELECT *
FROM persons
WHERE date_of_birth BETWEEN '2019-01-01' AND '2020-01-01';

-- LIKE & ILIKE (case insensative)
SELECT *
FROM persons
WHERE email LIKE '%bloomberg.com';

SELECT *
FROM persons
WHERE email LIKE 'a________@about.%';

SELECT *
FROM persons
WHERE country_of_birth
ILIKE
'p%';

-- GROUP BY (grouping by a column)
SELECT country_of_birth, COUNT(*) AS number_of_persons
FROM persons
GROUP BY country_of_birth
ORDER BY number_of_persons;

-- GROUP BY HAVING
SELECT country_of_birth, COUNT(*) AS number_of_persons
FROM persons
GROUP BY country_of_birth
HAVING COUNT(*) >= 40
ORDER BY number_of_persons;

-- MIN, MAX & AVG
SELECT MAX(price)
from cars;

SELECT MIN(price)
from cars;

SELECT ROUND(AVG(price))
from cars;

SELECT make, MIN(price)
FROM cars
GROUP BY make;

SELECT make, model, MIN(price)
FROM cars
GROUP BY make, model;

-- SUM
SELECT SUM(price)
FROM cars;

SELECT make, SUM(price)
FROM cars
GROUP BY make;

-- ARITHMATIC SIGNS
-- +, -, *, /, %, ^ (power), ! (factorial)
SELECT 10 ^ 2;

SELECT id, make, model, price, ROUND(price * .10, 2) AS discount, ROUND(price - (price * .10), 2) as new_price
FROM cars;

-- COALESCE
SELECT COALESCE(null, 1, 10);

SELECT COALESCE(email, 'Email not provided')
FROM persons;

-- NULLIF - return null if two values are equal
SELECT NULLIF(0, 0);
SELECT COALESCE(10/NULLIF(0, 0), 0);

-- TIMESTAMP & DATE
SELECT NOW();
SELECT NOW()
::DATE;
SELECT NOW()
::TIME;
SELECT NOW() - INTERVAL '10 YEARS';
SELECT EXTRACT(YEAR FROM NOW());
SELECT first_name, TO_CHAR(AGE(NOW(), date_of_birth), 'YY "Years" mm "Months" DD "Days"') AS age
FROM persons
ORDER BY age DESC;

-- UNIQUE CONSTRAINT 
SELECT email, COUNT(*)
FROM persons
GROUP BY email
HAVING COUNT(*) > 1;

ALTER TABLE persons ADD CONSTRAINT unique_email_address UNIQUE(email);
ALTER TABLE persons ADD UNIQUE(email);

ALTER TABLE persons DROP CONSTRAINT unique_email_address;

-- CHECK
ALTER TABLE persons ADD CHECK(gender IN ('Male', 'Female'));

insert into persons
  (first_name, last_name, email, gender, date_of_birth, country_of_birth)
values
  ('Roddie', 'Hilldrup', 'rhilldrup0@nyu.edu', 'Males', '6/14/2020', 'Honduras');

-- Delete records/rows
DELETE FROM persons WHERE gender='Female' AND country_of_birth='Nigeria';

-- UPDATE records
UPDATE persons SET email='foyez@email.com', first_name='Foyez', last_name='Ahmed' WHERE id = 3;

-- On CONFLICT - column_name need to be either primary key or unique constraint
INSERT INTO persons
  (id, first_name, last_name, email, gender, date_of_birth, country_of_birth)
VALUES
  (3, 'Foyez', 'Ahmed', 'foyezali@email.com', 'Male', DATE
'1993-08-05', 'Bangladesh')
ON CONFLICT
(id) DO NOTHING;

INSERT INTO persons
  (id, first_name, last_name, email, gender, date_of_birth, country_of_birth)
VALUES
  (3, 'Foyez', 'Ahmed', 'foyezali@email.com', 'Male', DATE
'1993-08-05', 'Bangladesh')
ON CONFLICT
(id) DO
UPDATE SET email = EXCLUDED.email, country_of_birth=EXCLUDED.country_of_birth;

-- Foreign Keys, Joins & Relationships
-- Person has car
-- Person can only have one car
-- Car can belong to one person only
-- shouldn't use ON CASCADE

UPDATE person SET car_id = 2 WHERE id = 1;

-- INNER JOIN - commons between two table
-- LEFT INNER JOIN - left table & commons of right table
-- RIGHT INNER JOIN - right table & commons of left table

SELECT person.first_name, car.make, car.model, car.price
FROM person JOIN car ON person.car_id = car.id;

SELECT person.first_name, car.make, car.model, car.price
FROM person
  LEFT JOIN car ON person.car_id = car.id;

SELECT person.first_name, car.make, car.model, car.price
FROM person
  LEFT JOIN car ON person.car_id = car.id
WHERE car.* IS NULL;

SELECT person.first_name, car.make, car.model, car.price
FROM person RIGHT JOIN car ON person.car_id = car.id;

-- Exporting Query Results To CSV
-- \copy (SELECT * FROM person LEFT JOIN car ON car.id = person.car_id) TO '/media/foyez/CAD86EE7D86ED0ED/MyBackup/junior-senior-webdev/Database/postgresql/practice/results.csv' DELIMITER ',' CSV HEADER;

-- SERIAL & SEQUENCES
-- SERIAL is integer datatype which is auto incrementing

SELECT *
FROM person_id_seq;

SELECT nextval('person_id_seq'
::regclass);

ALTER SEQUENCE person_id_seq RESTART WITH 10;

-- Extensions
SELECT *
FROM pg_available_extensions;

-- Install Extension
CREATE EXTENSION
IF NOT EXISTS "uuid-ossp";

-- UUID(Universally Unique IDentifier)
SELECT uuid_generate_v4();

-- UUID as PRIMARY KEY
-- Benifits
-- It's very hard for attackers to track the next id
-- It's easy to migrate to another database without conflicts (since it's globally unique)

SELECT *
FROM person JOIN car USING (car_uid) ;