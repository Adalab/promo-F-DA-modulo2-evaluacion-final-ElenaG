use sakila;

-- ----------------------------------------------------------------------------------------------
-- 1. Selecciona todos los nombres de las películas sin que aparezcan duplicados
-- ----------------------------------------------------------------------------------------------
SELECT DISTINCT title as "pelis en base de datos"
FROM film;

-- ----------------------------------------------------------------------------------------------
-- 2. Muestra los nombres de todas las películas que tengan una clasificación de "PG-13".
-- ----------------------------------------------------------------------------------------------
SELECT DISTINCT title AS "pelis con clasificación PG-13"
FROM film
WHERE rating = "PG-13";

-- ----------------------------------------------------------------------------------------------
-- 3. Encuentra el título y la descripción de todas las películas que contengan la palabra "amazing" en su descripción.
-- ------------------------------------------------------------------------------------------------ 
SELECT title, description
FROM film
WHERE description like "%amazing%";

-- ----------------------------------------------------------------------------------------------
-- 4. Encuentra el título de todas las películas que tengan una duración mayor a 120 minutos.
-- ------------------------------------------------------------------------------------------------ 
SELECT title
FROM film
WHERE length > 120;

-- --------------------------------------------------------------------------------------------
-- 5. Recupera los nombres de todos los actores.
-- ----------------------------------------------------------------------------------------------
SELECT CONCAT(first_name, " ", last_name) as "nombre"
FROM actor;

-- ----------------------------------------------------------------------------------------------
-- 6. Encuentra el nombre y apellido de los actores que tengan "Gibson" en su apellido.
-- ----------------------------------------------------------------------------------------------
SELECT first_name, last_name
FROM actor
WHERE last_name LIKE "%gibson%";

-- --------------------------------------------------------------------------------------------
-- 7. Encuentra los nombres de los actores que tengan un actor_id entre 10 y 20
-- ----------------------------------------------------------------------------------------------
SELECT first_name, last_name
FROM actor
WHERE actor_id BETWEEN 10 AND 20;

-- ----------------------------------------------------------------------------------------------
-- 8. Encuentra el título de las películas en la tabla film que no sean ni "R" ni "PG-13" en cuanto a su clasificación.
-- ----------------------------------------------------------------------------------------------
SELECT title, rating
FROM film
WHERE rating NOT IN ("R", "PG");

-- --------------------------------------------------------------------------------------------
-- 9. Encuentra la cantidad total de películas en cada clasificación de la tabla film y muestra la clasificación junto con el recuento
-- ----------------------------------------------------------------------------------------------
SELECT rating as "clasificacion_rating", COUNT(title) AS "nro_pelis"
FROM film
GROUP BY rating
ORDER BY rating;

-- ----------------------------------------------------------------------------------------------
-- 10. Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su nombre y apellido junto con la cantidad de películas alquiladas
-- ----------------------------------------------------------------------------------------------
SELECT c.customer_id AS "ID_cliente", CONCAT(first_name, " ",last_name) as "nombre_cliente", COUNT(distinct i.film_id) as "nro_peliculas_alquiladas"
FROM customer as c
INNER JOIN rental as r on c.customer_id = r.customer_id
INNER JOIN inventory as i on r.inventory_id = i.inventory_id
GROUP BY c.customer_id
ORDER BY c.customer_id;

-- --------------------------------------------------------------------------------------------
-- 11. Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el recuento de alquileres.
-- ----------------------------------------------------------------------------------------------
SELECT c.category_id, c.name, COUNT(distinct i.film_id) as "n pelis alquiladas por categoría"
FROM category as c
INNER JOIN film_category as fc on c.category_id = fc.category_id
INNER JOIN inventory as i on fc.film_id = i.film_id
INNER JOIN rental as r on i.inventory_id = r.inventory_id
GROUP BY c.category_id
ORDER BY c.category_id;

-- ----------------------------------------------------------------------------------------------
-- 12. Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y muestra la clasificación junto con el promedio de duración.
-- ----------------------------------------------------------------------------------------------
SELECT rating as "clasificación_rating", AVG(length) AS "promedio_duración"
FROM film
GROUP BY rating
ORDER BY rating;

-- ----------------------------------------------------------------------------------------------
-- 13. Encuentra el nombre y apellido de los actores que aparecen en la película con title "Indian Love".
-- ----------------------------------------------------------------------------------------------
SELECT CONCAT(first_name, " ",last_name) as "nombre_actor/actriz en peli Indian Love"
FROM actor AS a
INNER JOIN film_actor AS fa ON a.actor_id = fa.actor_id
INNER JOIN film as f ON fa.film_id = f.film_id
WHERE f.title = "Indian Love";

-- ----------------------------------------------------------------------------------------------
-- 14. Muestra el título de todas las películas que contengan la palabra "dog" o "cat" en su descripción
-- ----------------------------------------------------------------------------------------------
SELECT title, description
FROM film
WHERE description like "%dog%" OR description like "%cat%";

-- ----------------------------------------------------------------------------------------------
-- 15. Hay algún actor que no aparecen en ninguna película en la tabla film_actor
-- ----------------------------------------------------------------------------------------------
SELECT actor_id
FROM film_actor
WHERE film_id IS NULL;  -- No, todos los actores están ligados a alguna película (film_id no es nulo para ninguno de los actores)

SELECT film.film_id, film_actor.actor_id
FROM film_actor
LEFT JOIN film ON film_actor.film_id = film.film_id
WHERE film.film_id IS NULL; -- Lo confirmamos con el left join

SELECT film.film_id, film_actor.actor_id
FROM film
LEFT JOIN film_actor ON film.film_id = film_actor.film_id
WHERE actor_id IS NULL; -- pero sí hay 3 películas para las cuales no tenemos los actores

-- ----------------------------------------------------------------------------------------------
-- 16. Encuentra el título de todas las películas que fueron lanzadas entre el año 2005 y 2010
-- ----------------------------------------------------------------------------------------------
SELECT title as "pelis_estrenadas_entre_2005y2010"
FROM film
WHERE release_year BETWEEN 2005 AND 2010;

-- ----------------------------------------------------------------------------------------------
-- 17. Encuentra el título de todas las películas que son de la misma categoría que "Family"
-- ----------------------------------------------------------------------------------------------
SELECT title as "pelis categoría: Family"
FROM film as f
INNER JOIN film_category as fc ON f.film_id = fc.film_id
WHERE category_id IN (SELECT category_id
						FROM category
                        WHERE name = "Family");

-- ----------------------------------------------------------------------------------------------
-- 18. Muestra el nombre y apellido de los actores que aparecen en más de 10 películas
-- ----------------------------------------------------------------------------------------------
SELECT CONCAT(first_name, " ",last_name) as "Actor/actriz que han actuado en +10pelis"
FROM actor as a
WHERE actor_id IN (SELECT actor_id
					FROM film_actor
					GROUP BY actor_id
					HAVING COUNT(distinct film_id)  > 10); -- todos han actuado en al menos 10 pelis

-- ----------------------------------------------------------------------------------------------
-- 19. Encuentra el título de todas las películas que empiezan por "R" y tienen una duración mayor a 2 horas en la tabla film
-- ----------------------------------------------------------------------------------------------
SELECT title as "pelis empiezan en R y duracion +2hrs"
FROM film
WHERE title like "R%" and length > 120;

-- ----------------------------------------------------------------------------------------------
-- 20. Encuentra las categorías de películas que tienen un promedio de duración superior a 120 minutos y muestra el nombre de la categoría junto con el promedio de duración
-- ----------------------------------------------------------------------------------------------
SELECT c.category_id, c.name, COUNT(f.film_id) AS "Nro pelis con duración superior a 2hrs", AVG(length) AS "Promedio de duración de pelis de más de 2hrs"
FROM film AS f
INNER JOIN film_category AS fc ON f.film_id = fc.film_id
INNER JOIN category AS c ON fc.category_id = c.category_id
WHERE length > 120
GROUP BY c.category_id
ORDER BY c.category_id;

-- ----------------------------------------------------------------------------------------------
-- 21. Encuentra los actores que han actuado en al menos 5 películas y muestra el nombre del actor junto con la cantidad de películas en las que han actuado
-- ----------------------------------------------------------------------------------------------
WITH tabla AS (SELECT actor_id, COUNT(distinct film_id) AS "nro_pelis" -- CTE da el nro. de pelis por actor
                FROM film_actor
                GROUP BY actor_id)
SELECT a.actor_id, CONCAT(first_name, " ",last_name) as "nombre actor/actriz", nro_pelis
FROM actor AS a
INNER JOIN tabla AS t ON a.actor_id = t.actor_id
GROUP BY a.actor_id
HAVING nro_pelis > 5; -- Todos los actores han actuado en más de 5 pelis

-- ----------------------------------------------------------------------------------------------
-- 22. Encuentra el título de todas las películas que fueron alquiladas por más de 5 días. 
-- **Nota: Utiliza una subconsulta para encontrar los rental_ids con una duración superior a 5 días y luego selecciona las películas correspondientes.
-- ----------------------------------------------------------------------------------------------
WITH tabla AS (SELECT rental_id, inventory_id, return_date, rental_date, DATEDIFF(return_date,rental_date) AS "dias_alquiler" -- CTE da los días de alquiler para todas las pelis devueltas (return date = NOT NULL)
				FROM rental WHERE rental_date IS NOT NULL)
SELECT DISTINCT(title) as "pelis alquiladas +5días" -- pongo distinct porque sino aparecen copias de la misma película
FROM film AS f
INNER JOIN inventory AS i ON f.film_id = i.film_id
INNER JOIN tabla as t ON i.inventory_id = t.inventory_id
WHERE t.dias_alquiler > 5;

-- ----------------------------------------------------------------------------------------------
-- 23. Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría "Horror". 
-- **Nota: Utiliza una subconsulta para encontrar los actores que han actuado en películas de la categoría "Horror" y luego exclúyelos de la lista de actores
-- ----------------------------------------------------------------------------------------------
-- En pelis de horror
SELECT fa.actor_id, first_name, last_name, c.name
FROM actor AS a
LEFT JOIN film_actor AS fa ON a.actor_id = fa.actor_id
LEFT JOIN film AS f ON fa.film_id = f.film_id
LEFT JOIN film_category AS fc ON f.film_id = fc.film_id
LEFT JOIN category AS c ON fc.category_id = c.category_id
WHERE c.name = "Horror"
GROUP by fa.actor_id;

 -- En pelis de horror con subconsulta
SELECT fa.actor_id, first_name, last_name
FROM actor AS a
LEFT JOIN film_actor AS fa ON a.actor_id = fa.actor_id
LEFT JOIN film AS f ON fa.film_id = f.film_id
LEFT JOIN film_category AS fc ON f.film_id = fc.film_id
WHERE category_id IN (SELECT category_id 
						  FROM category
						  WHERE name = "Horror")
GROUP by fa.actor_id;

 -- No en pelis de horror con subconsulta
SELECT fa.actor_id, first_name, last_name
FROM actor AS a
LEFT JOIN film_actor AS fa ON a.actor_id = fa.actor_id
LEFT JOIN film AS f ON fa.film_id = f.film_id
LEFT JOIN film_category AS fc ON f.film_id = fc.film_id
WHERE category_id NOT IN (SELECT category_id 
						  FROM category
						  WHERE name = "Horror")
GROUP by fa.actor_id, first_name, last_name; -- todos los actores han actuado en pelis que no son de horror

-- ----------------------------------------------------------------------------------------------
-- 24. Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la tabla film
-- ----------------------------------------------------------------------------------------------
SELECT title AS "comedias de más de 2.5hrs"
FROM film AS f
INNER JOIN film_category AS fc ON f.film_id = fc.film_id
WHERE category_id IN (SELECT category_id 
						  FROM category
						  WHERE name = "Comedy")
AND length > 180;

-- ----------------------------------------------------------------------------------------------
-- 25. Encuentra todos los actores que han actuado juntos en al menos una película. 
-- **Nota: La consulta debe mostrar el nombre y apellido de los actores y el número de películas en las que han actuado juntos.
-- ----------------------------------------------------------------------------------------------
-- pelis con todos los actores
SELECT f.film_id, actor_id
FROM film AS f
CROSS JOIN film_actor AS fa;

-- opción2: actores por pelis
SELECT title, first_name, last_name
FROM film as f
INNER JOIN film_actor AS fa ON f.film_id = fa.film_id 
INNER JOIN actor AS a ON fa.actor_id = a.actor_id
WHERE a.actor_id IN (SELECT actor_id
					FROM film_actor
                    GROUP BY actor_id
                    HAVING COUNT(*) >=2);

-- Combinación de parejas
SELECT f.film_id, f.title, concat(a1.first_name," ", a1.last_name) AS "actor1", concat(a2.first_name," ", a2.last_name) AS "actor2"
FROM film AS f
INNER JOIN film_actor AS fa1 ON f.film_id = fa1.film_id 
INNER JOIN actor AS a1 ON fa1.actor_id = a1.actor_id
INNER JOIN film_actor AS fa2 ON f.film_id = fa2.film_id 
INNER JOIN actor AS a2 ON fa2.actor_id = a2.actor_id
WHERE a1.first_name!=a2.first_name and a1.last_name!=a2.last_name; -- Quito los que son el mismo actor en a1 y a2

-- Combinación de parejas -- intento 1
SELECT f.film_id, f.title, concat(a1.first_name," ", a1.last_name) AS "actor1", concat(a2.first_name," ", a2.last_name) AS "actor2"
FROM film AS f
INNER JOIN film_actor AS fa1 ON f.film_id = fa1.film_id 
INNER JOIN actor AS a1 ON fa1.actor_id = a1.actor_id
INNER JOIN film_actor AS fa2 ON f.film_id = fa2.film_id 
INNER JOIN actor AS a2 ON fa2.actor_id = a2.actor_id
WHERE a1.first_name!=a2.first_name and a1.last_name!=a2.last_name
AND a1.first_name=a2.first_name and a1.last_name=a2.last_name and a2.first_name=a1.first_name and a2.last_name=a1.last_name
GROUP BY f.film_id;  

--  Combinación de parejas -- intento 2 - Cláusulas adicionales "where" no funcionan
SELECT f.film_id, f.title, concat(a1.first_name," ", a1.last_name) AS "actor1", concat(a2.first_name," ", a2.last_name) AS "actor2"
FROM film AS f
INNER JOIN film_actor AS fa1 ON f.film_id = fa1.film_id -- la tabla intermedia tb tiene q estar 2 veces
INNER JOIN actor AS a1 ON fa1.actor_id = a1.actor_id
INNER JOIN film_actor AS fa2 ON f.film_id = fa2.film_id -- la tabla intermedia tb tiene q estar 2 veces
INNER JOIN actor AS a2 ON fa2.actor_id = a2.actor_id
GROUP BY f.film_id, f.title, a1.first_name, a1.last_name, a2.first_name, a2.last_name
HAVING (a1.first_name!=a2.first_name and a1.last_name!=a2.last_name) AND ((a1.first_name=a2.first_name and a1.last_name=a2.last_name) and (a2.first_name=a1.first_name and a2.last_name=a1.last_name)) and COUNT(f.film_id) >= 2;

-- Copiado de internet -- parejas de actores q trabajaronn juntos
SELECT a.first_name, a.last_name, colega.first_name, colega.last_name, count(*) as n
FROM actor as a
INNER JOIN film_actor as fa1 on a.actor_id = fa1.actor_id
INNER JOIN film_actor as fa2 on (fa1.film_id = fa2.film_id and fa1.actor_id <> fa2.actor_id)
INNER JOIN actor as colega on fa2.actor_id=colega.actor_id 
GROUP BY a.first_name, a.last_name, colega.first_name, colega.last_name
ORDER BY n DESC;
-- LIMIT 1 -- este es para indicar la pareja que han trabajdo más juntas

-- Dudas: a. cómo eliminar las parejas repetidas en esta última query y 2. cómo hacer el ejercicio sin parejas
