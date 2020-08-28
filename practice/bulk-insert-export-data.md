```sql
CREATE TABLE users (
  id BIGSERIAL NOT NULL PRIMARY KEY,
  first_name VARCHAR(50),
  last_name VARCHAR(50),
  email VARCHAR(100),
  gender VARCHAR(10),
  age INT,
  language VARCHAR(50)
);
```

## Insert Data from CSV Files

```sql
\COPY users (id, first_name, last_name, email, gender, age, language) FROM '/media/foyez/CAD86EE7D86ED0ED/MyBackup/junior-senior-webdev/Database/postgresql/practice/user-data.csv' DELIMITER ',' CSV HEADER;
```
