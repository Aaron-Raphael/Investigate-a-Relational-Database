/*
Question 1
Provide a table with the family-friendly film category,
 each of the quartiles and 
 the corresponding count of movies within each combination of film category 
 for each corresponding rental duration category.
*/

WITH f_category AS (
  SELECT f.title AS film_title, c.name AS category,
  f.rental_duration ,
  NTILE(4) OVER (ORDER BY f.rental_duration) AS standard_quartile
  FROM film f
  JOIN film_category fc
  ON f.film_id = fc.film_id
  JOIN category c
  ON fc.category_id = c.category_id
  WHERE c.name IN ('Animation', 'Children', 'Classics', 'Comedy', 'Family', 'Music'))
  
SELECT category, standard_quartile, COUNT(rental_duration) AS count
FROM f_category
GROUP BY 1, 2
ORDER BY 1, 2

/*
Question 2:
 Write a query that returns the store ID for the store, 
 the year and month and the number of rental orders each store has fulfilled for that month. 
 Your table should include a column for each of the following: 
 year, month, store ID and count of rental orders fulfilled during that month
*/

SELECT DATE_PART('month',r.rental_date) AS rental_month, 
    DATE_PART('year',r.rental_date) AS rental_year, 
    s.store_id AS store_id,
count(*) AS count_rentals
FROM rental AS r
JOIN staff AS s
ON r.staff_id = s.staff_id
GROUP BY 1,2,3
ORDER BY 4 DESC