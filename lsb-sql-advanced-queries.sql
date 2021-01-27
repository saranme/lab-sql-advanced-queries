/*
Lab | SQL Advanced queries
In this lab, you will be using the Sakila database of movie rentals.

Instructions
List each pair of actors that have worked together.
For each film, list actor that has acted in more films.
*/
Use sakila;
-- List each pair of actors that have worked together.
select DISTINCT f1.film_id,
		f1.actor_id as actor_1, a1.first_name as actor_f1, a1.last_name as actor_l1,
        f2.actor_id as actor_2, a2.first_name as actor_f2, a2.last_name as actor_l2
from sakila.film_actor as f1
join sakila.film_actor as f2
on f1.actor_id <> f2.actor_id
and f1.film_id=f2.film_id
join sakila.actor as a1
on f1.actor_id=a1.actor_id
join sakila.actor as a2
on f2.actor_id=a2.actor_id;

-- For each film, list actor that has acted in more films.
CREATE VIEW n_films_actor_ AS
WITH n_films_actor AS (SELECT actor_id, COUNT(film_id) n_films
												FROM film_actor
												GROUP BY 1)
SELECT fa.actor_id, fa.film_id, nfa.n_films
FROM film_actor fa
JOIN n_films_actor nfa
ON fa.actor_id = nfa.actor_id;

SELECT fa.actor_id, CONCAT(a.first_name,' ',a.last_name) actor_name, fa.film_id, f.title movie, fa.n_films
FROM (SELECT actor_id, film_id, n_films,RANK() OVER(PARTITION BY film_id ORDER BY n_films DESC) AS ordering
	  FROM n_films_actor_) AS fa
JOIN actor a
ON fa.actor_id = a.actor_id
JOIN film f
ON f.film_id = fa.film_id
WHERE ordering = 1;


