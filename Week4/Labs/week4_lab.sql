
--- Question 2 - how do I use a CTE for this query?
SELECT COUNT(*), CONCAT(first_name,' ',last_name) AS full_name
FROM customer
JOIN rental ON customer.customer_id=rental.customer_id
GROUP BY customer.customer_id
ORDER BY COUNT(*) DESC
;

WITH customer_rentals AS (
	SELECT COUNT(*) AS rentals, customer.customer_id AS ci
	FROM customer
	JOIN rental ON customer.customer_id=rental.customer_id
	GROUP BY customer.customer_id
)
SELECT rentals, CONCAT(first_name,' ',last_name) AS full_name
FROM customer_rentals
JOIN customer ON customer_rentals.ci=customer.customer_id
WHERE rentals = (SELECT MAX(rentals) FROM customer_rentals)
;

--- Question 3
WITH customer_rentals AS (
	SELECT COUNT(*) AS rentals, customer.customer_id AS ci
	FROM customer
	JOIN rental ON customer.customer_id=rental.customer_id
	GROUP BY customer.customer_id
), max_rentals AS (
	SELECT rentals,ci
	FROM customer_rentals
	WHERE rentals = (SELECT MAX(rentals) FROM customer_rentals)
)
SELECT COUNT(*), film.film_id, film.title
FROM customer
JOIN rental ON customer.customer_id=rental.customer_id
JOIN inventory ON rental.inventory_id=inventory.inventory_id
JOIN film ON inventory.film_id=film.film_id
WHERE customer.customer_id IN (SELECT ci FROM max_rentals)
GROUP BY film.film_id
HAVING COUNT(*)>1
;

---Question 4
WITH customer_rentals AS (
	SELECT COUNT(*) AS rentals, customer.customer_id AS ci
	FROM customer
	JOIN rental ON customer.customer_id=rental.customer_id
	GROUP BY customer.customer_id
), max_rentals AS (
	SELECT rentals,ci
	FROM customer_rentals
	WHERE rentals = (SELECT MAX(rentals) FROM customer_rentals)
), categories AS (
	SELECT customer.customer_id, category.category_id, category.name
	FROM customer
	JOIN rental ON customer.customer_id=rental.customer_id
	JOIN inventory ON rental.inventory_id=inventory.inventory_id
	JOIN film ON inventory.film_id=film.film_id
	JOIN film_category ON film.film_id=film_category.film_id
	JOIN category ON film_category.category_id=category.category_id
)
SELECT COUNT(*), categories.name
FROM categories
WHERE categories.customer_id IN (SELECT ci FROM max_rentals)
GROUP BY categories.name
ORDER BY COUNT(*) DESC
LIMIT 1
;

---Question 5
--trigger example
CREATE OR REPLACE FUNCTION delete_inactive() 
  RETURNS trigger 
AS
$BODY$
BEGIN
    IF (NEW.activebool=FALSE)
	THEN DELETE FROM customer WHERE customer.customer_id=New.customer_id ;
    END IF;
    RETURN NULL; -- because this is an AFTER event trigger
END;
$BODY$
LANGUAGE plpgsql;
	
CREATE OR REPLACE TRIGGER inactive_customer
AFTER UPDATE ON customer
FOR EACH ROW
EXECUTE FUNCTION delete_inactive();

UPDATE customer
SET activebool=FALSE
WHERE customer_id=524

SELECT customer_id,activebool
FROM customer
;

-- SELECT *
-- FROM customer
-- JOIN rental ON customer.customer_id=rental.customer_id
-- ORDER BY customer.last_name
-- ;

-- SELECT COUNT(*), customer_id
-- 	FROM customer
-- 	JOIN rental ON customer.customer_id=rental.customer_id
-- 	GROUP BY customer.customer_id
-- 	;

