CREATE SCHEMA IF NOT EXISTS week4examples;

DROP TABLE IF EXISTS week4examples.categories;
CREATE TABLE week4examples.categories (
	category_id serial PRIMARY KEY,
	category_name VARCHAR (255) NOT NULL
);

DROP TABLE IF EXISTS week4examples.products;
CREATE TABLE week4examples.products (
	product_id serial PRIMARY KEY,
	product_name VARCHAR (255) NOT NULL,
	category_id INT NOT NULL,
	FOREIGN KEY (category_id) REFERENCES week4examples.categories (category_id)
);

DROP TABLE IF EXISTS week4examples.employees;
CREATE TABLE week4examples.employees (
    employee_id serial PRIMARY KEY,
    full_name VARCHAR NOT NULL,
    manager_id INT
);

INSERT INTO week4examples.categories (category_name)
VALUES
	('Smart Phone'),
	('Laptop'),
	('Tablet');

INSERT INTO week4examples.products (product_name, category_id)
VALUES
	('iPhone', 1),
	('Samsung Galaxy', 1),
	('HP Elite', 2),
	('Lenovo Thinkpad', 2),
	('iPad', 3),
	('Kindle Fire', 3);
	
INSERT INTO week4examples.employees (
    employee_id,
    full_name,
    manager_id
)
VALUES
    (1, 'M.S Dhoni', NULL),
    (2, 'Sachin Tendulkar', 1),
    (3, 'R. Sharma', 1),
    (4, 'S. Raina', 1),
    (5, 'B. Kumar', 1),
    (6, 'Y. Singh', 2),
    (7, 'Virender Sehwag ', 2),
    (8, 'Ajinkya Rahane', 2),
    (9, 'Shikhar Dhawan', 2),
    (10, 'Mohammed Shami', 3),
    (11, 'Shreyas Iyer', 3),
    (12, 'Mayank Agarwal', 3),
    (13, 'K. L. Rahul', 3),
    (14, 'Hardik Pandya', 4),
    (15, 'Dinesh Karthik', 4),
    (16, 'Jasprit Bumrah', 7),
    (17, 'Kuldeep Yadav', 7),
    (18, 'Yuzvendra Chahal', 8),
    (19, 'Rishabh Pant', 8),
    (20, 'Sanju Samson', 8);

--natural join
SELECT * FROM week4examples.products
NATURAL JOIN week4examples.categories;

--left join
SELECT *
FROM week4examples.products a
LEFT JOIN week4examples.categories b
ON a.category_id=b.category_id;

-- recursive query returns all subordinates with the manager id 3
WITH RECURSIVE subordinates AS (
    SELECT
        employee_id,
        manager_id,
        full_name
    FROM
        week4examples.employees
    WHERE
        employee_id = 3
    UNION
        SELECT
            e.employee_id,
            e.manager_id,
            e.full_name
        FROM
            week4examples.employees e
        INNER JOIN subordinates s ON s.employee_id = e.manager_id
) SELECT     *
FROM
    subordinates;
	
--trigger example
CREATE OR REPLACE FUNCTION week4examples.cat_exists() 
  RETURNS trigger 
AS
$BODY$
BEGIN
    IF (NEW.category_id NOT IN (SELECT DISTINCT category_id
	FROM week4examples.categories) ) THEN RAISE EXCEPTION 'category_id does not exist';
    END IF;
    RETURN NEW; -- this is important for a trigger
END;
$BODY$
LANGUAGE plpgsql;
	
CREATE OR REPLACE TRIGGER product_category_exists
BEFORE INSERT ON week4examples.products
FOR EACH ROW
EXECUTE FUNCTION week4examples.cat_exists();   

INSERT INTO week4examples.products (product_name, category_id)
VALUES
	('Unknown', 10);
	
INSERT INTO week4examples.products (product_name, category_id)
VALUES
	('Unknown', 2);