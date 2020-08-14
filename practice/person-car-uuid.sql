CREATE TABLE car
(
  car_uid UUID PRIMARY KEY,
  make VARCHAR(100) NOT NULL,
  model VARCHAR(100) NOT NULL,
  price NUMERIC(19, 2) NOT NULL
);

CREATE TABLE person
(
  person_uid UUID PRIMARY KEY,
  first_name VARCHAR(50) NOT NULL,
  last_name VARCHAR(50) NOT NULL,
  email VARCHAR(50),
  gender VARCHAR(7) NOT NULL,
  date_of_birth DATE NOT NULL,
  country_of_birth VARCHAR(50) NOT NULL,
  car_uid UUID REFERENCES car (car_uid),
  UNIQUE(car_uid),
  UNIQUE(email)
);

INSERT INTO person
  (person_uid, first_name, last_name, email, gender, date_of_birth, country_of_birth
  )
VALUES
  (uuid_generate_v4(), 'Foyez', 'Ahmed', 'foyez@email.com', 'Male', DATE
'1993-08-05', 'Bangladesh');
INSERT INTO person
  (person_uid, first_name, last_name, email, gender, date_of_birth, country_of_birth
  )
VALUES
  (uuid_generate_v4(), 'Manam', 'Ahmed', 'manam@email.com', 'Male', DATE
'1996-06-13', 'Germany');
INSERT INTO person
  (person_uid, first_name, last_name, email, gender, date_of_birth, country_of_birth
  )
VALUES
  (uuid_generate_v4(), 'Nazmun', 'Nahar', 'nazmun@email.com', 'Female', DATE
'1991-08-05', 'Bangladesh');

INSERT INTO car
  (car_uid, make, model, price)
VALUES
  (uuid_generate_v4(), 'Land Rover', 'Sterling', '87665.38');
INSERT INTO car
  (car_uid, make, model, price)
VALUES
  (uuid_generate_v4(), 'GMC', 'Acadia', '17662.69');
