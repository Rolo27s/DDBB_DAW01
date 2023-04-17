-- SAKILA
-- 1. Actores que tienen de primer nombre 'Scarlett':
SELECT * FROM actor WHERE first_name = 'Scarlett';

-- 2.	Actores que tienen de apellido ‘Johansson’.
SELECT * FROM actor WHERE last_name = 'Johansson';

-- 3.	Actores que contengan una ‘O’ en su nombre.
SELECT * FROM actor WHERE first_name LIKE '%O%';

-- 4.	Actores que contengan una ‘O’ en su nombre y en una ‘A’ en su apellido.
SELECT * FROM actor WHERE first_name LIKE '%O%' AND last_name LIKE '%A%';

-- 5.	Actores que contengan dos ‘O’ en su nombre y en una ‘A’ en su apellido.
SELECT * FROM actor WHERE first_name LIKE '%OO%' AND last_name LIKE '%A%';

-- 6.	Actores donde su tercera letra sea ‘B’.
SELECT * FROM actor WHERE first_name LIKE '__B%';

-- 7.	Ciudades que empiezan por ‘a’.
SELECT * FROM city WHERE city LIKE 'a%';

-- 8.	Ciudades que acaban por ‘s’.
SELECT * FROM city WHERE city LIKE '%s';

-- 9.	Ciudades del country 61.
SELECT * FROM city WHERE country_id = 61;

-- 10.	Ciudades del country ‘Spain’.
SELECT * FROM city WHERE country_id = (SELECT country_id FROM country WHERE country = 'Spain');

-- 11.	Ciudades con nombres compuestos.
SELECT * FROM city WHERE city LIKE '% %';

-- 12.	Películas con una duración entre 80 y 100.
SELECT * FROM film WHERE length BETWEEN 80 AND 100;

-- 13.	Películas con un rental_rate entre 1 y 3.
SELECT * FROM film WHERE rental_rate BETWEEN 1 AND 3;

-- 14.	Películas con un titulo de más de 12 letras.
SELECT * FROM film WHERE LENGTH(title) > 12;

-- 15.	Películas con un rating de PG o G.
SELECT * FROM film WHERE rating IN ('PG', 'G');

-- 16.	Películas que no tengan un rating de NC-17.
SELECT * FROM film WHERE rating != 'NC-17';

-- 17.	Películas con un rating PG y duración de más de 120.
SELECT * FROM film WHERE rating = 'PG' AND length > 120;

-- 18.	¿Cuantos actores hay?
SELECT COUNT(*) FROM actor;

-- 19.	¿Cuántas ciudades tiene el country ‘Spain’?
SELECT COUNT(*) FROM city WHERE country_id = (SELECT country_id FROM country WHERE country = 'Spain');

-- 20.	¿Cuántos countries hay que empiezan por ‘a’?
SELECT COUNT(*) FROM country WHERE country LIKE 'a%';

-- 21.	Media de duración de peliculas con PG.
SELECT AVG(length) FROM film WHERE rating = 'PG';

-- 22.	Suma de rental_rate de todas las películas.
SELECT SUM(rental_rate) FROM film;

-- 23.	Película con mayor duración.
SELECT * FROM film ORDER BY length DESC LIMIT 1;

-- 24.	Película con menor duración.
SELECT * FROM film ORDER BY length LIMIT 1;

-- 25.	Mostrar las ciudades del country Spain
SELECT city FROM city
WHERE country_id = (
  SELECT country_id
  FROM country
  WHERE country = 'Spain'
);

-- 26.	Mostrar el nombre de la película y el nombre de los actores
SELECT f.title AS pelicula, CONCAT(a.first_name, ' ', a.last_name) AS actor
FROM film f
JOIN film_actor fa ON f.film_id = fa.film_id
JOIN actor a ON fa.actor_id = a.actor_id
LIMIT 10000;

-- 27.	Mostrar el nombre de la película y el de sus categorías.
SELECT f.title AS pelicula, GROUP_CONCAT(c.name) AS categorias
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
GROUP BY f.film_id
LIMIT 10000;

-- 28.	Mostrar el country, la ciudad y dirección de cada miembro del staff.
SELECT s.first_name AS staff, c.country, ci.city, a.address
FROM staff s
JOIN address a ON s.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN country c ON ci.country_id = c.country_id;

-- 29.	Mostrar el country, la ciudad y dirección de cada customer.
SELECT c.first_name AS customer, co.country, ci.city, a.address
FROM customer c
JOIN address a ON c.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
JOIN country co ON ci.country_id = co.country_id;

-- 30.	Número de películas de cada rating
SELECT rating AS clasificacion, COUNT(*) AS num_peliculas
FROM film
GROUP BY rating;

-- 31.	Cuántas películas ha realizado el actor ED CHASE.
SELECT a.first_name, a.last_name, COUNT(*) AS num_peliculas
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film f ON fa.film_id = f.film_id
WHERE a.first_name = 'ED' AND a.last_name = 'CHASE';

-- 32.	Media de duración de las películas cada categoría
SELECT c.name AS categoria, AVG(f.length) AS duracion_media
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
GROUP BY c.category_id;

-- 33.	Consulta la categoría y el idioma de la  película ACADEMY DINOSAUR
SELECT c.name AS categoria, l.name AS idioma
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
JOIN language l ON f.language_id = l.language_id
WHERE f.title = 'ACADEMY DINOSAUR';

-- 34.	Pregunta sobre los actores de la película ACADEMY DINOSAUR
SELECT a.first_name, a.last_name
FROM actor a
JOIN film_actor fa ON a.actor_id = fa.actor_id
JOIN film f ON fa.film_id = f.film_id
WHERE f.title = 'ACADEMY DINOSAUR';

-- 35.	Consulta el número de actores en la película ACADEMY DINOSAUR
SELECT COUNT(*) AS num_actores
FROM film f
JOIN film_actor fa ON f.film_id = fa.film_id
WHERE f.title = 'ACADEMY DINOSAUR';

-- 36.	Indica para cada película su id y el número de inventario
SELECT f.film_id, COUNT(*) AS num_inventarios
FROM film f
JOIN inventory i ON f.film_id = i.film_id
GROUP BY f.film_id;

-- 37.	Para cada película (nombre) cuántos inventarios tiene
SELECT f.title AS pelicula, COUNT(*) AS num_inventarios
FROM film f
JOIN inventory i ON f.film_id = i.film_id
GROUP BY f.title;

-- 38.	Consulta la dirección y el nombre de la persona responsable correspondiente a cada almacén
SELECT s.first_name AS staff_nombre, s.last_name AS staff_apellido, a.address
FROM store st
JOIN staff s ON st.manager_staff_id = s.staff_id
JOIN address a ON s.address_id = a.address_id;

-- 39.	Consultar el nombre del personal y su dirección correspondiente
SELECT s.first_name AS staff_nombre, s.last_name AS staff_apellido, a.address
FROM staff s
JOIN address a ON s.address_id = a.address_id;

-- 40.	Indica para cada cliente, cuánto ha alquilado y a cuánto asciende el total pagado
SELECT c.first_name AS customer_nombre, c.last_name AS customer_apellido, 
       COUNT(r.rental_id) AS num_alquileres, SUM(p.amount) AS total_pagado
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
JOIN payment p ON r.rental_id = p.rental_id
GROUP BY c.customer_id;

-- 41.	Consultar las ventas totales de un empleado: nombre del empleado, ventas totales
SELECT CONCAT(s.first_name, ' ', s.last_name) AS empleado_nombre, SUM(p.amount) AS ventas_totales
FROM staff s
JOIN payment p ON s.staff_id = p.staff_id
GROUP BY s.staff_id;

-- 42.	Consultar el nombre de una película prestada por un cliente
SELECT c.first_name AS nombre_cliente, f.title AS nombre_pelicula
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film f ON i.film_id = f.film_id
LIMIT 100000;

-- 43.	Consulta la popularidad de una película y ordena por popularidad
SELECT title AS nombre_pelicula, rating
FROM film
ORDER BY rating DESC
LIMIT 10000;

-- 44.	Consulte el cliente que ha alquilado más películas y cuantas han sido
SELECT c.first_name AS nombre_cliente, COUNT(*) AS total_peliculas_alquiladas
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
GROUP BY c.customer_id
ORDER BY total_peliculas_alquiladas DESC
LIMIT 1;

-- 45.	Consulta la categoría, el idioma y el número de actores a los que pertenece  la película con id=15
SELECT c.name AS categoria, l.name AS idioma, COUNT(*) AS num_actores
FROM film f
JOIN film_category fc ON f.film_id = fc.film_id
JOIN category c ON fc.category_id = c.category_id
JOIN language l ON f.language_id = l.language_id
WHERE f.film_id = 15
GROUP BY c.category_id, l.language_id;

-- 46.	Para cada empleado indica qué clientes les han alquilado películas y cuánto se han gastado
SELECT s.first_name AS nombre_empleado, c.first_name AS nombre_cliente, SUM(p.amount) AS total_gastado
FROM staff s
JOIN rental r ON s.staff_id = r.staff_id
JOIN customer c ON r.customer_id = c.customer_id
JOIN payment p ON r.rental_id = p.rental_id
GROUP BY s.staff_id, c.customer_id
LIMIT 10000;

-- 47.	Consulta el consumo total de cada cliente para aquellos clientes que se han gastado más de 100€ y cuyo nombre comience por A
SELECT c.first_name AS nombre_cliente, SUM(p.amount) AS consumo_total
FROM customer c
JOIN payment p ON c.customer_id = p.customer_id
WHERE c.first_name LIKE 'A%' 
GROUP BY c.customer_id, c.first_name
HAVING SUM(p.amount) > 100;

-- 48.	Indica cuál es la categoría que más gusta a cada cliente
SELECT c.customer_id, c.first_name AS nombre_cliente, cat.name AS categoria_gustada, COUNT(*) AS cantidad
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
JOIN inventory i ON r.inventory_id = i.inventory_id
JOIN film_category fc ON i.film_id = fc.film_id
JOIN category cat ON fc.category_id = cat.category_id
GROUP BY c.customer_id, c.first_name, cat.name
HAVING COUNT(*) = (
  SELECT MAX(count)
  FROM (
    SELECT c.customer_id, COUNT(*) AS count
    FROM customer c
    JOIN rental r ON c.customer_id = r.customer_id
    JOIN inventory i ON r.inventory_id = i.inventory_id
    JOIN film_category fc ON i.film_id = fc.film_id
    JOIN category cat ON fc.category_id = cat.category_id
    GROUP BY c.customer_id, cat.name
  ) AS counts
  WHERE c.customer_id = counts.customer_id
);

-- 49.	encuentra todos los filmes donde ha actuado el actor Nick Stallone
SELECT f.film_id, f.title
FROM film f
JOIN film_actor fa ON f.film_id = fa.film_id
JOIN actor a ON fa.actor_id = a.actor_id
WHERE a.first_name LIKE 'Nick%' AND a.last_name LIKE '%Stallone%';

-- 50.	muestra el nombre de los clientes que hayan realizado algunos alquileres del 25 al 27 de mayo de 2005
SELECT c.first_name, c.last_name
FROM customer c
JOIN rental r ON c.customer_id = r.customer_id
WHERE r.rental_date BETWEEN '2005-05-25' AND '2005-05-27'
GROUP BY c.first_name, c.last_name;

-- 51.	muestra un listado de los clientes que vivan en la ciudad Baybay o Aurora
SELECT c.first_name, c.last_name
FROM customer c
JOIN address a ON c.address_id = a.address_id
JOIN city ci ON a.city_id = ci.city_id
WHERE ci.city IN ('Baybay', 'Aurora');

-- 52.	muestra un listado del clientes cuyo nombre contiene TRACY y apellido contiene COLE
SELECT first_name, last_name
FROM customer
WHERE first_name LIKE '%TRACY%' AND last_name LIKE '%COLE%';

-- 53.	muestra el nombre de los filmes alquilados el 31 mayo del 2005
SELECT f.title
FROM film f
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
WHERE DATE(r.rental_date) = '2005-05-31';

-- 54.	muestra un listado cuyo filmes sea de duración entre 60 y 90 minutos
SELECT title
FROM film
WHERE length BETWEEN 60 AND 90;

-- 55.	muestra un listado de todos los clientes de México que estén activos(1 y 0)
SELECT first_name, last_name
FROM customer
WHERE address_id IN (
  SELECT address_id
  FROM address
  WHERE city_id IN (
    SELECT city_id
    FROM city
    WHERE country_id IN (
      SELECT country_id
      FROM country
      WHERE country = 'Mexico'
    )
  )
)
AND active IN (1, 0);


-- 56.	Actores que tengan una x en el nombre o en el apellido
SELECT first_name, last_name
FROM actor
WHERE first_name LIKE '%x%' OR last_name LIKE '%x%';

-- 57.	Direcciones de california que tengan ‘274’ en el número de teléfono ***
SELECT a.address
FROM address a
JOIN city c ON a.city_id = c.city_id
JOIN country co ON c.country_id = co.country_id
WHERE co.country = 'United States' AND c.city = 'California' AND a.phone LIKE '%274%';


-- 58.	Películas ‘Épicas’ (Epic) o ‘Brillantes’ (brilliant) que duren más de 180 minutos ***
SELECT title
FROM film
WHERE (title LIKE '%Épicas%' OR title LIKE '%Brillantes%') AND length > 180;


-- 59.	Películas que duren entre 100 y 120 minutos o entre 50 y 70 minutos
SELECT title
FROM film
WHERE (length BETWEEN 100 AND 120) OR (length BETWEEN 50 AND 70);

-- 60.	Películas que cuesten 0.99, 2.99 y tengan un rating ‘g’ o ‘r’ y que hablen de cocodrilos (cocodrile) ***
SELECT title
FROM film
WHERE rental_rate IN (0.99, 2.99) AND (rating = 'G' OR rating = 'R') AND description LIKE '%cocodrile%';

-- 61.	Direcciones de ontario o de punjab o que su código postal acabe en 5 o que su teléfono acabe en 5
SELECT address
FROM address
WHERE (city_id IN (SELECT city_id FROM city WHERE city LIKE '%Ontario%') OR city_id IN (SELECT city_id FROM city WHERE city LIKE '%Punjab%')) OR (postal_code LIKE '%5' OR phone LIKE '%5');

-- 62.	Queremos saber que clientes no alquilaron películas.
SELECT customer_id, first_name, last_name 
FROM customer 
WHERE customer_id NOT IN (SELECT DISTINCT customer_id FROM rental);

-- 63.	Queremos generar una lista con el nombre de la película junto con el nombre del cliente, número de teléfono y email, de los alquileres atrasados para que los clientes pueden ser contactados y pedirles que devuelvan la película y también si la película está pagada, en qué fecha se pagó y cuanto se pagó. 
SELECT f.title AS 'Nombre de la Película', 
       CONCAT(c.first_name, ' ', c.last_name) AS 'Nombre del Cliente', 
       c.email AS 'Email', 
       p.payment_date AS 'Fecha de Pago', 
       p.amount AS 'Monto Pagado' 
FROM rental r
INNER JOIN customer c ON r.customer_id = c.customer_id
INNER JOIN inventory i ON r.inventory_id = i.inventory_id
INNER JOIN film f ON i.film_id = f.film_id
LEFT JOIN payment p ON r.rental_id = p.rental_id
WHERE r.return_date > r.rental_date AND p.payment_id IS NULL
LIMIT 0, 1000;

-- 64.	Queremos averiguar cuantas películas ha alquilado cada cliente 
SELECT c.customer_id, 
       CONCAT(c.first_name, ' ', c.last_name) AS 'Nombre del Cliente', 
       COUNT(*) AS 'Número de Películas Alquiladas'
FROM customer c
INNER JOIN rental r ON c.customer_id = r.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY COUNT(*) DESC;

-- 65.	Consulta la categoría, el idioma y el número de actores de cada película
SELECT f.title AS 'Título de la Película', 
       c.name AS 'Categoría', 
       l.name AS 'Idioma', 
       COUNT(a.actor_id) AS 'Número de Actores'
FROM film f
INNER JOIN film_category fc ON f.film_id = fc.film_id
INNER JOIN category c ON fc.category_id = c.category_id
INNER JOIN language l ON f.language_id = l.language_id
LEFT JOIN film_actor fa ON f.film_id = fa.film_id
LEFT JOIN actor a ON fa.actor_id = a.actor_id
GROUP BY f.title, c.name, l.name
ORDER BY f.title ASC
LIMIT 10000;