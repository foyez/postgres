CREATE TABLE car
(
  id BIGSERIAL PRIMARY KEY,
  make VARCHAR(100) NOT NULL,
  model VARCHAR(100) NOT NULL,
  price NUMERIC(19, 2) NOT NULL
);

CREATE TABLE person
(
  id BIGSERIAL PRIMARY KEY,
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  email VARCHAR(50),
  gender VARCHAR(7) NOT NULL,
  date_of_birth DATE NOT NULL,
  country_of_birth VARCHAR(50) NOT NULL,
  car_id BIGINT REFERENCES car (id),
  UNIQUE(car_id)
);

INSERT INTO person
  (first_name, last_name, email, gender, date_of_birth, country_of_birth
  )
VALUES
  ('Foyez', 'Ahmed', 'foyez@email.com', 'Male', DATE
'1993-08-05', 'Bangladesh');
INSERT INTO person
  (first_name, last_name, email, gender, date_of_birth, country_of_birth
  )
VALUES
  ('Manam', 'Ahmed', 'manam@email.com', 'Male', DATE
'1996-06-13', 'Germany');
INSERT INTO person
  (first_name, last_name, email, gender, date_of_birth, country_of_birth
  )
VALUES
  ('Nazmun', 'Nahar', 'nazmun@email.com', 'Female', DATE
'1991-08-05', 'Bangladesh');

INSERT INTO car
  (make, model, price)
VALUES
  ('Land Rover', 'Sterling', '87665.38');
INSERT INTO car
  (make, model, price)
VALUES
  ('GMC', 'Acadia', '17662.69');
