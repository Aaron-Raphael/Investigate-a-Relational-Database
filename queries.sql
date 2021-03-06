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

/*
Question 3
 We would like to know who were our top 10 paying customers, 
 how many payments they made on a monthly basis during 2007 and 
 what was the amount of the monthly payments. 
 Can you write a query to capture the customer name, 
 month and year of payment and 
 total payment amount for each month by these top 10 paying customers?
*/

WITH top_customers AS(SELECT p.customer_id, 
                (c.first_name||' '||c.last_name) AS fullname, 
                SUM(p.amount) AS pay_amount
                FROM payment p
                JOIN customer c
                ON p.customer_id = c.customer_id
                GROUP BY 1, 2
                ORDER BY 3 DESC
                LIMIT 10),
     results AS (SELECT DATE_TRUNC('month',p.payment_date) AS pay_mon,
                c.first_name || ' ' || c.last_name AS fullname,
          		COUNT(*) AS pay_counterpermon, SUM(p.amount) AS pay_amount
          		FROM PAYMENT AS p
          		JOIN CUSTOMER AS c
          		ON p.customer_id = c.customer_id
          		WHERE DATE_TRUNC('month',p. payment_date) > '2007-01-01'
          		GROUP BY 1,2
          		ORDER BY fullname)
SELECT r.pay_mon, t_c.fullname, r.pay_counterpermon, r.pay_amount
FROM results AS r
JOIN top_customers AS t_c
ON r.fullname = t_c.fullname
ORDER BY fullname, pay_mon;

/*
Question 4
 Write a query to find the top 10 buyers in the first accounted month
*/

/*
The query below is used to find the first accounted month

SELECT DATE_TRUNC('month', MIN(payment_date))
FROM payment

*/

/*
The query below lists the top 10 buyers
*/
WITH first_buyers AS( SELECT c.first_name||' '||c.last_name AS full_name,
       COUNT(*) AS payment_count,
       SUM(pt.amount) AS total_amt
FROM customer AS c
JOIN payment pt
ON c.customer_id = pt.customer_id
WHERE pt.payment_date BETWEEN '2007-02-01' AND '2007-02-27'
GROUP BY 1)

SELECT full_name , payment_count ,total_amt
FROM first_buyers
GROUP BY 1, 2, 3 
ORDER BY 3 DESC
LIMIT 10;