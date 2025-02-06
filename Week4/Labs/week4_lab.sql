
--- Question 2 - how do I use a CTE for this query?
SELECT COUNT(*), CONCAT(first_name,' ',last_name) AS customer_name
FROM customer
JOIN rental ON customer.customer_id=rental.customer_id
GROUP BY customer.customer_id
ORDER BY COUNT(*) DESC
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

-- SELECT *
-- FROM customer
-- JOIN rental ON customer.customer_id=rental.customer_id
-- ORDER BY customer.last_name
-- ;

SELECT COUNT(*), customer_id
	FROM customer
	JOIN rental ON customer.customer_id=rental.customer_id
	GROUP BY customer.customer_id
	;

