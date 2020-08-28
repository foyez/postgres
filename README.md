# PostgreSQL (SQL) at a glance

![PostgreSQL at a glance](./resources/postgresql-banner.jpg)

> A quick important topics about PostgreSQL (SQL).

This repository is constantly being updated and added to by the community. Pull requests are welcome.

## Table of contents

- [What is database](#what-is-database)
- [PostgreSQL](#postgresql)
- [PostgreSQL Installation](#postgresql-installation)
- [PostgreSQL Basic Commands](#postgresql-basic-commands)
- [Queries at a Glance](#queries-at-a-glance)
  - [1. Creating and Deleting Queries](#1-creating-and-deleting-queries)
  - [2. Finding Data Queries](#2-finding-data-queries)
  - [3. Data Modification Queries](#3-data-modification-queries)
  - [4. Aggregate Functions Queries](#4-aggregate-functions-queries)
  - [5. JOIN Queries](#5-join-queries)
  - [6. View Queries](#6-view-queries)
  - [7. Insert and Export Data from Files](#7-insert-and-export-data-from-files)
  - [8. Date Queries](#8-date-queries)
- [Transaction](#transaction)

## What is database

Database is a place where we **store**, **manipulate** and **retrieve** data

## PostgreSQL

PostgreSQL, or Postgres, is a open source relational database management system that provides an implementation of the SQL querying language. It is a popular choice for many small and large projects and has the advantage of being standards-compliant and having many advanced features like reliable transactions and concurrency without read locks.

## PostgreSQL Installation

**Linux downloads (Debian)**
\
To use the apt repository, follow these steps:

```sh
# Create the file repository configuration:
sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'

# Import the repository signing key:
wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -

# Update the package lists:
sudo apt-get update

# Install the latest version of PostgreSQL.
# If you want a specific version, use 'postgresql-12' or similar instead of 'postgresql':
sudo apt-get install postgresql-12
```

## PostgreSQL Basic Commands

- create a linux user by typing (from non-root account):

```sh
$ sudo adduser username
# Example: sudo adduser foyez
```

- Switch over to the postgres account and accessing to postgres prompt by typing:

```sh
$ sudo -i -u postgres
$ psql
```

- Accessing a Postgres Prompt Without Switching Accounts

```sh
$ sudo -u postgres psql
```

- connected to specific database, host & port:

```
$ psql -h localhost -p 5432 -U foyez test
```

- connected to a database from postgres prompt:

```sql
foyez=# \c db_name
```

- connect to a different database

```sh
$ psql -d postgres
```

- create a new user & give permission to create a DB

```sql
-- create a new user without password
postgres=# CREATE USER new_username;

-- create a new user with password
postgres=# CREATE USER new_username WITH SUPERUSER PASSWORD 'testpass';

-- create password for an existing user
postgres=# ALTER USER username WITH PASSWORD 'testpass';

-- give permissions to a existing user
postgres=# ALTER USER new_username SUPERUSER CREATEDB;
```

- Check DB users by typing: `\du`

```
postgres=# \du
```

- Exit the interactive Postgres session by typing: `\q` or `CTRL+D`

```
postgres=# \q
```

- Check your current connection information by typing: `\conninfo`

```
postgres=# \conninfo
```

- show exists database by typing: `\list` or `\l`

```sql
postgres=# \list
postgres=# \l
```

- show exists database tables and sequences by typing: `\d`

```sql
postgres=# \d
```

- show only exists database tables by typing: `\dt`

```sql
postgres=# \dt
```

- show table details by typing: `\d table_name`

```sql
postgres=# \d table_name
```

- to know all psql commands:

```
$ psql --help
```

or

```sql
postgres=# \?
```

- clear postgres prompt by typing: `CTRL+L`

- Insert queries from sql file:

```sql
postgres=# \i /path/file_name.sql
```

- Expanded display by typing: `\x`

## Queries at a Glance

> Sql cheatsheet: [link](https://github.com/enochtangg/quick-SQL-cheatsheet#create)\
> You can also watch out official document: [link](https://www.postgresql.org/docs/current/index.html)

### 1. Creating and Deleting Queries

#### Creating and Deleting Database

```
# if logged in as the postgres account
postgres@server:~$ createdb db_name # Ex: createdb test_db
```

or

```
$ sudo -u postres createdb db_name # Ex: sudo -u postres createdb test_db
```

or

```sql
# if connect to database
postgres=# CREATE DATABASE test_db; # create a new database
postgres=# DROP DATABASE test_db; # delete the database if exists
```

#### Creating and Deleting Tables

```sql
# Create a new table
CREATE TABLE table_name (
  column1 datatype (field_length) column_constraints,
  column2 datatype (field_length),
  column3 datatype (field_length)
);

# delete a table
DROP TABLE table_name; # If the removed table does not exist, PostgreSQL will issue an error.
DROP TABLE IF EXISTS table_name; # remove a table only if it exists
```

Example:

```sql
CREATE TABLE playground (
  equip_id SERIAL PRIMARY KEY, # datatype of equip_id column is serial (means auto-incrementing integer) & constraint is PRIMARY KEY (means values must be unique and not null)
  type VARCHAR (50) NOT NULL, datatype of type column is VARCHAR, field length is 50 & constraint is NOT NULL (means cannot be empty)
  color VARCHAR (25) NOT NULL,
  location VARCHAR(25) check (location IN ('north', 'south', 'west', 'east', 'northeast', 'southeast', 'southwest', 'northwest')), # create a constraint that requires the value to be one of eight possible values
  install_date date
);

DROP TABLE playground;
```

**[Foreign Key](https://www.postgresqltutorial.com/postgresql-foreign-key/)** - A foreign key is a column or a group of columns in a table that reference the primary key of another table.

- The table that contains the foreign key is called the referencing table or child table. And the table referenced by the foreign key is called the referenced table or parent table.
- A table can have multiple foreign keys depending on its relationships with other tables.
- In PostgreSQL, you define a foreign key using the foreign key constraint. The foreign key constraint helps maintain the referential integrity of data between the child and parent tables.
- A foreign key constraint indicates that values in a column or a group of columns in the child table equal the values in a column or a group of columns of the parent table.

```sql
CREATE TABLE table_name (
  column1 datatype (field_length) column_constraints,
  column2 datatype (field_length),
  column3 datatype (field_length)
  [CONSTRAINT fk_name] # specify the name for the foreign key constraint after the CONSTRAINT keyword. The CONSTRAINT clause is optional. If you omit it, PostgreSQL will assign an auto-generated name.
  FOREIGN KEY(column2, column3, ...) # specify one or more foreign key columns in parentheses after the FOREIGN KEY keywords.
  REFERENCES parent_table(parent_key_column1, parent_key_column2, ...) # specify the parent table and parent key columns referenced by the foreign key columns in the REFERENCES clause.
  [ON DELETE|UPDATE action] # specify the delete and update actions in the ON DELETE and ON UPDATE clauses.
);
```

PostgreSQL supports the following actions:

- SET NULL - automatically sets NULL to the foreign key columns in the referencing rows of the child table when the referenced rows in the parent table are updated or deleted.
- CASCADE - automatically updates or deletes all the referencing rows in the child table when the referenced rows in the parent table are updated or deleted. In practice, the ON DELETE CASCADE is the most commonly used option.
- SET DEFAULT - sets the default value to the foreign key column of the referencing rows in the child table when the referenced rows from the parent table are updated or deleted.
- RESTRICT
- NO ACTION - is default action

```sql
# Each playground has zero or many players and each player belongs to zero or one playground.

CREATE TABLE players ( # child table is players
	player_id INT PRIMARY KEY,
	first_name VARCHAR (255) NOT NULL,
	last_name VARCHAR (255) NOT NULL,
	playground_id INT,
  CONSTRAINT fk_playground # specify the name for the foreign key constraint after the CONSTRAINT keyword. The CONSTRAINT clause is optional. If you omit it, PostgreSQL will assign an auto-generated name.
	FOREIGN KEY (playground_id) # playground_id column in the players table is foreign key
	REFERENCES playground (equip_id) # parent table is playground & references primary key column of playground
	ON DELETE CASCADE
);
```

**Add a foreign key constraint to an existing table**

```sql
ALTER TABLE child_table
ADD CONSTRAINT constraint_name
FOREIGN KEY (fk_columns)
REFERENCES parent_table (parent_key_columns);
```

**Add a foreign key constraint to an existing table with `ON DELETE CASCADE`**

Step: 1

```sql
ALTER TABLE child_table
DROP CONSTRAINT constraint_fk;
```

Step: 2

```sql
ALTER TABLE child_table
ADD CONSTRAINT constraint_fk
FOREIGN KEY (fk_columns)
REFERENCES parent_table(parent_key_columns)
ON DELETE CASCADE;
```

### 2. Finding Data Queries

#### SELECT: used to select data from a database

- `SELECT` \* `FROM` table_name;
- `SELECT` column_name `FROM` table_name `LIMIT` 10;

#### DISTINCT: filters away duplicate values and returns rows of specified column

- `SELECT` `DISTINCT` column_name;

#### WHERE: used to filter records/rows

- `SELECT` column1, column2 `FROM` table_name `WHERE` condition;
- `SELECT` \* `FROM` table_name `WHERE` condition1 `AND` condition2;
- `SELECT` \* `FROM` table_name `WHERE` condition1 `OR` condition2;
- `SELECT` \* `FROM` table_name `WHERE` `NOT` condition;
- `SELECT` \* `FROM` table_name `WHERE` condition1 `AND` (condition2 `OR` condition3);
- `SELECT` \* `FROM` table_name `WHERE` EXISTS (`SELECT` column_name `FROM` table_name `WHERE` condition);

#### ORDER BY: used to sort the result-set in ascending or descending order

- `SELECT` \* `FROM` table_name `ORDER BY` column;
- `SELECT` \* `FROM` table_name `ORDER BY` column `DESC`;
- `SELECT` \* `FROM` table_name `ORDER BY` column1 `ASC`, column2 `DESC`;

#### SELECT TOP: used to specify the number of records to return from top of table

- `SELECT TOP` number \* `FROM` table_name `WHERE` condition;
- `SELECT TOP` percent \* `FROM` table_name `WHERE` condition;

Not all database systems support `SELECT TOP`. The MySQL equivalent is the `LIMIT` clause

- SELECT column_names FROM table_name `LIMIT` offset, count;

#### LIKE: operator used in a WHERE clause to search for a specific pattern in a column

- `%` (percent sign) is a wildcard character that represents zero, one or multiple characters
- `_` (underscore) is a wildcard character that represents a single character
- `SELECT` column_names `FROM` table_name WHERE column_name LIKE pattern;
- `LIKE` 'a%' (find any values that start with "a")
- `LIKE` '%a' (find any values that end with "a")
- `LIKE` '%or%' (find any values that contain "or" in any position)
- `LIKE` '\_r%' (find any values that have "r" in the second position)
- `LIKE` 'a\_%\_%' (find any values that start with "a" and are at least 3 character in length)
- `LIKE` '[a-c]%' (find any values starting with "a", "b", or "c")

#### IN: operator that allows you to specify multiple values in a WHERE clause

- essentially the `IN` operator is shorthand for multiple `OR` condition
- `SELECT` column_names `FROM` table_name `WHERE` column_name `IN` (value1, value2, ...);
- `SELECT` column_names `FROM` table_name `WHERE` column_name `IN` (`SELECT` STATEMENT);

#### BETWEEN: operator selects values within a given range inclusive

- `SELECT` column_names `FROM` table_name `WHERE` column_name `BETWEEN` value1 `AND` value2;
- `SELECT` \* `FROM` table_name `WHERE` (column_name1 `BETWEEN` value1 `AND` value2) `AND` `NOT` column_name2 `IN` (value3, value4);

#### NULL: values in a field with no value

- `SELECT` \* `FROM` table_name `WHERE` column_name `IS NULL`;
- `SELECT` \* `FROM` table_name `WHERE` column_name `IS NOT NULL`;

#### AS: aliases are used to assign a temporary name to a table or column

- `SELECT` column_name1 `AS` alias_name1, column_name2 `AS` alias_name2 `FROM` table_name;
- `SELECT` column_name `FROM` table_name `AS` alias_name;

#### UNION: set operator used to combine the result-set of two or more SELECT statements

- Each `SELECT` statement within `UNION` must have the **same number of columns**
- The columns must have **similar data types**
- The columns in each `SELECT` statement **must also be in the same order**
- `SELECT` column_name `FROM` table_name1 `UNION` `SELECT` column_name `FROM` table_name2;
- `UNION` operator only selects distinct values, `UNION ALL` will allow duplicates

#### `INTERSECT`: set operator which is used to return the records that two `SELECT` statements have in common

- Generally used the same way as `UNION`
- `SELECT` column_names `FROM` table_name1 `INTERSECT` `SELECT` column_name `FROM` table_name2;

#### `EXCEPT`: set operator used to return all the records in the first `SELECT` statement that are not found in the second `SELECT` statement

- Generally used the same way as `UNION`
- `SELECT` column_names `FROM` table_name1 `EXCEPT` `SELECT` column_name `FROM` table_name2

#### `ANY` or `ALL`: operator used to check subquery conditions used within a `WHERE` or `HAVING` clauses

- The `ANY` operator returns true if any subquery values meet the condition
- The `ALL` operator returns true if all subquery values meet the condition
- `SELECT` column_names `FROM` table_name1 `WHERE` column_name operator (`ANY`|`ALL`) `SELECT` column_name `FROM` table_name2 `WHERE` condition;

#### `GROUP BY`: statement often used with aggregate functions (`COUNT`, `MAX`, `MIN`, `SUM`, `AVG`) to group the result-set by one or more columns

- `SELECT` column_name1 `COUNT`(column_name2) `FROM` `WHERE` table_name `GROUP BY` column_name1 `ORDER BY` `COUNT`(column_name2) `DESC`;

#### `HAVING`: this clause was added to SQL because the `WHERE` keyword could not be used with aggregate functions

- `SELECT` `COUNT`(column_name1), column_name2 `FROM` table_name `GROUP BY` column_name2 `HAVING` `COUNT`(column_name1) > 5;

#### `WITH`: often used for retrieving hierarchical data or re-using temp result set several times in a query. Also referred to as "Common Table Expression"

- `WITH RECURSIVE` cte `AS` (
  `SELECT` c0.\* `FROM` categories `AS` c0 `WHERE` id = 1
  `UNION ALL`
  `SELECT` c1.\* `FROM` categories `AS` c1 `JOIN` cte `ON` c1.parent_category_id = cte.id
  ) `SELECT` \* `FROM` cte;

### 3. Data Modification Queries

#### `INSERT INTO`: used to insert new records/rows in a table

- `INSERT` `INTO` table_name (column1, column2) `VALUES` (value1, value2);
- `INSERT` `INTO` table_name `VALUES` (value1, value2);

### Upsert (update or insert): when you insert a new row into the table, PostgreSQL will update the row if it already exists, otherwise, it will insert the new row

> help link: [details](https://www.postgresqltutorial.com/postgresql-upsert/)

| id  | name      | email                 |
| --- | --------- | --------------------- |
| 1   | Microsoft | contact@microsoft.com |

```sql
INSERT INTO customers (name, email) VALUES('Microsoft' 'hotline@microsoft.com') ON CONFLICT (name) DO NOTHING;

-- OR

INSERT INTO customers (name, email) VALUES('Microsoft' 'hotline@microsoft.com') ON CONFLICT DO NOTHING;
```

Output:

```
Do Nothing
```

```sql
INSERT INTO customers (name, email) VALUES('Microsoft' 'hotline@microsoft.com') ON CONFLICT (name) DO UPDATE SET email = EXCLUDED.email || ';' || customers.email;
```

Output:

```
INSERT 0 1
```

| id  | name      | email                                       |
| --- | --------- | ------------------------------------------- |
| 1   | Microsoft | hotmail@microsoft.com;contact@microsoft.com |

#### `UPDATE`: used to modify the existing records in a table

- `UPDATE` table_name `SET` column1=value1, column2=value2 `WHERE` condition;
- `UPDATE` table_name `SET` column_name=value;

#### `DELETE`: used to delete existing records/rows in a table

- `DELETE` `FROM` table_name `WHERE` condition;
- `DELETE` \* `FROM` table_name;

#### `ADD COLUMN`: Add one or more column

- `ALTER TABLE` table_name `ADD COLUMN` column_name1 data_type constraint, `ADD COLUMN` column_name2 data_type constraint;

#### `MODIFY`: change data type of column

- `ALTER TABLE` table_name `MODIFY` column_name data_type;
- `ALTER TABLE` table_name `ALTER COLUMN` column_name `TYPE` datatype; (postgresql)

#### `DROP COLUMN`: Delete a column

- `ALTER TABLE` table_name `DROP COLUMN` column_name;
- `ALTER TABLE` table_name `DROP COLUMN` column_name CASCADE; (drop the column and all of its dependent objects)

#### ADD & delete primary key

- `ALTER TABLE` table_name `ADD PRIMARY KEY`(column_name);
- `ALTER TABLE` table_name `DROP CONSTRAINT` table_name_pkey;

#### ADD & delete unique constraint

- `ALTER TABLE` persons `ADD CONSTRAINT` constraint_name `UNIQUE`(column_name);
- `ALTER TABLE` persons `ADD UNIQUE`(column_name);
- `ALTER TABLE` table_name `DROP CONSTRAINT` constraint_name;

#### Add & delete check constraint

- `ALTER TABLE` table_name `ADD CONSTRAINT` constraint_name `CHECK`(gender IN ('value1', 'value2'));
- `ALTER TABLE` table_name `ADD CHECK`(gender IN ('value1', 'value2'));
- `ALTER TABLE` table_name `DROP CONSTRAINT` constraint_name;

### 4. Aggregate Functions Queries

#### `COUNT()`: returns the # of occurrences

- `SELECT` `COUNT`(`DISTINCT` column_name) `FROM` table_name;

#### `MIN()` and `MAX()`: returns the smallest/largest value of the selected column <sup>[help link](https://stackoverflow.com/questions/22319408/postgres-get-min-max-aggregate-values-in-one-select)</sup>

- `SELECT` `MIN`(column_name) `FROM` table_name `WHERE` condition;
- `SELECT` `MAX`(column_name) `FROM` table_name `WHERE` condition;

#### `AVG()`: returns the average value of a numeric column

- `SELECT` `AVG`(column_name) `FROM` table_name `WHERE` condition;

#### `SUM()`: returns the total sum of a numeric column

- `SELECT` `SUM`(column_name) `FROM` table_name `WHERE` condition;

#### `ARRAY_AGG()`: accepts a set of values and returns an array where each value in the input set is assigned to an element of the array

- `SELECT` `ARRAY_AGG`(`DISTINCT` column_name) `AS` Array `FROM` table_name

### 5. JOIN Queries

#### `INNER JOIN`: returns records that have matching value in both tables

- `SELECT` \* `FROM` table_name1 `INNER JOIN` table_name2 `ON` table_name1.column_name=table_name2.column_name;
- `SELECT` table_name1.column_name, table_name2.column_name, table_name3.column_name `FROM` ((table_name1 `INNER JOIN` table_name2 `ON` table_name1.column_name=table_name2.column_name) `INNER JOIN` table_name3 `ON` table_name1.column_name=table_name3.column_name);

#### `LEFT (OUTER) JOIN`: returns all records from the left table(table1), and the matched records from the right table(table2)

- `SELECT` \* `FROM` table_name1 `LEFT JOIN` table_name2 `ON` table_name1.column_name=table_name2.column_name;

#### `RIGHT (OUTER) JOIN`: returns all records from the right table(table2), and the matched records from the right table(table1)

- `SELECT` \* `FROM` table_name1 `RIGHT JOIN` table_name2 `ON` table_name1.column_name=table_name2.column_name;

#### Self JOIN: a regular join, but the table is joined with itself <sup>[help link](https://www.postgresqltutorial.com/postgresql-self-join/)</sup>

- `SELECT` \* `FROM` table_name t1 `LEFT JOIN` table_name t2 `WHERE` condition;
- `SELECT` t1.column_name1 || ' ' || t1.column_name2 alias_name, t2.column_name1 `FROM` table_name1 t1 `INNER JOIN` table_name2 t2 `ON` t1.column_name1=t2.column_name2 `ORDER BY` alias_name;

### 6. View Queries

**View**: A view is a database object that is of a stored query. A view can be accessed as a virtual table in PostgreSQL.

#### `CREATE VIEW`: create a view <sup>[help link](https://www.postgresqltutorial.com/managing-postgresql-views/)</sup>

- `CREATE VIEW` view_name AS `SELECT column_name1, column_name2`FROM`table_name`WHERE` condition;

#### `SELECT`: retrieve a view

- `SELECT` \* `FROM` view_name;

#### `DROP VIEW`: drop a view

- `DROP VIEW` view_name;

### 7. Insert and Export Data from Files

#### Insert & Export Data from/to CSV file

```sql
\COPY table_name (column1, column2, ...) FROM '/absolute_path/file_name.csv' DELIMITER ',' CSV HEADER;

\COPY table_name (column1, column2, ...) TO '/absolute_path/file_name.csv' DELIMITER ',' CSV HEADER;
\COPY table_name (SELECT * FROM table_name) TO '/absolute_path/file_name.csv' DELIMITER ',' CSV HEADER;
```

#### Insert & Export Data from/to sql file

```
# import
postgres# \i /absolute_path/file_name.sql

# export
$ pg_dump -U username -s database_name >> sqlfile.sql
```

### 8. Date Queries

```sql
-- Get the current date
SELECT NOW(); # alternative, SELECT CURRENT_DATE;
SELECT NOW()::date;
SELECT NOW()::time;

-- Get the current date in a specific format
SELECT TO_CHAR(NOW()::DATE, 'dd/mm/yyyy'); # 23/06/2020
SELECT TO_CHAR(NOW()::DATE, 'Mon dd, yyyy'); # Jun 23, 2020

-- Get the interval between two dates
SELECT NOW() - hire_date FROM table_name; # 4191 days 08:25:30.634458
SELECT NOW() - INTERVAL '10 YEARS';
SELECT (NOW() + INTERVAL '10 DAYS')::DATE;

-- Calculate ages in years, months, and days
SELECT AGE(birth_date) FROM table_name; # 36 years 5 mons 22 days
SELECT AGE('2020-03-15', birth_date); # 34 years 5 mons 22 days

-- Extract year, quarter, month, week, day from a date value
SELECT EXTRACT (YEAR FROM birth_date) AS YEAR, EXTRACT (MONTH FROM birth_date) AS MONTH, EXTRACT (DAY FROM birth_date) AS DAY FROM table_name;
```

## Transaction

> helpful resources: [link](https://www.postgresqltutorial.com/postgresql-transaction/)

A database transaction is a **single unit of work** that consists of **one or more operations**. A transactional database guarantees that all the updates made by a transaction are logged in permanent storage (i.e., on disk) before the transaction is reported complete. So the changes will take effect only when all operations of the transaction have successfully finished. If one of the operations failed to execute then none of the operations will take effect at all.\
\
A PostgreSQL transaction is **atomic**, **consistent**, **isolated**, and **durable**. These properties are often referred to as ACID:

- Atomicity guarantees that for a series of operations performed against a database, either every one of them commits together, or they’re all rolled back; no in between states are allowed.
- Consistency ensures the change to data written to the database must be valid and follow predefined rules.
- Isolation determines how transaction integrity is visible to other transactions.
- Durability makes sure that transactions that have been committed will be stored in the database permanently.

```sql
-- start transaction
BEGIN; # BEGIN WORK; or BEGIN TRANSACTION;

-- deduct 1000 from account 1
UPDATE accounts
SET balance = balance - 1000
WHERE id = 1;

-- add 1000 to account 2
UPDATE accounts
SET balance = balance + 1000
WHERE id = 2;

-- select the data from accounts
SELECT id, name, balance
FROM accounts;

-- commit the change (or roll it back later)
COMMIT; # COMMIT WORK; or COMMIT TRANSACTION;
```
