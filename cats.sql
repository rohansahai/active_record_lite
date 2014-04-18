CREATE TABLE cats (
  id INTEGER PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  owner_id INTEGER NOT NULL,

  FOREIGN KEY(owner_id) REFERENCES human(id)
);

CREATE TABLE humans (
  id INTEGER PRIMARY KEY,
  fname VARCHAR(255) NOT NULL,
  lname VARCHAR(255) NOT NULL,
  house_id INTEGER NOT NULL,

  FOREIGN KEY(house_id) REFERENCES human(id)
);

CREATE TABLE houses (
  id INTEGER PRIMARY KEY,
  address VARCHAR(255) NOT NULL
);

INSERT INTO
  houses (address)
      SELECT "26th and Guerrero" AS address
UNION SELECT "Dolores and Market";
 
INSERT INTO
  humans (fname, lname, house_id)
      SELECT "Devon" AS fname, "Watts" AS lname, 1 AS house_id
UNION SELECT "Matt", "Rubens", 1
UNION SELECT "Ned", "Ruggeri", 2;
 
INSERT INTO
  cats (name, owner_id)
    SELECT "Breakfast" AS name, 1 AS owner_id
UNION SELECT "Earl", 2
UNION SELECT "Haskell", 3
UNION SELECT "Markov", 3;
  
