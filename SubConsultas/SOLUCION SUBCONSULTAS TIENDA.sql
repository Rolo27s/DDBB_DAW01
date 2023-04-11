-- SUBCONSULTAS
-- Tienda de Informática

-- 1.	Devuelve todos los productos del fabricante Lenovo. (Sin utilizar INNER JOIN).
select *
from producto
where codigo_fabricante = (select codigo from fabricante where nombre='Lenovo');

-- 2.	Devuelve todos los datos de los productos que tienen el mismo precio que el producto más caro del fabricante Lenovo. (Sin utilizar INNER JOIN).
select *
from producto
where precio = (select max(precio) from producto where codigo_fabricante= (select codigo from fabricante where nombre='Lenovo'));

-- 3.	Lista el nombre del producto más caro del fabricante Lenovo.
select nombre
from producto p 
where codigo_fabricante=(select codigo from fabricante where nombre='Lenovo')
and precio = (select max(precio) from producto where codigo_fabricante=p.codigo_fabricante);

-- 4.	Lista el nombre del producto más barato del fabricante Hewlett-Packard.
select nombre
from producto p
where codigo_fabricante=(select codigo from fabricante where nombre='Hewlett-Packard')
and precio = (select min(precio) from producto where codigo_fabricante=p.codigo_fabricante);

-- 5.	Devuelve todos los productos de la base de datos que tienen un precio mayor o igual al producto más caro del fabricante Lenovo.
select nombre
from producto 
where precio >= (select max(precio) from producto where codigo_fabricante= (select codigo from fabricante where nombre='Lenovo'));

-- 6.	Lista todos los productos del fabricante Asus que tienen un precio superior al precio medio de todos sus productos.
select *
from producto p
where codigo_fabricante = (select codigo from fabricante where nombre='Asus')
and precio > (select avg(precio) from producto where codigo_fabricante=p.codigo_fabricante);

-- ALL y ANY en Tienda de Informática

-- 7.Devuelve el producto más caro que existe en la tabla producto sin hacer uso de MAX, ORDER BY ni LIMIT.
select *
from producto p
where precio > ALL (select precio from producto where codigo != p.codigo);

-- 8.Devuelve el producto más barato que existe en la tabla producto sin hacer uso de MIN, ORDER BY ni LIMIT.
select *
from producto p
where precio < ALL (select precio from producto where codigo<>p.codigo);

-- 9.Devuelve los nombres de los fabricantes que tienen productos asociados. (Utilizando ALL o ANY). (Esto es como trabaja un JOIN, pero usando subconsultas)
select nombre
from fabricante 
where codigo = ANY (select codigo_fabricante from producto);

-- 10.Devuelve los nombres de los fabricantes que no tienen productos asociados. (Utilizando ALL o ANY).
select nombre
from fabricante 
where codigo <> ALL (select codigo_fabricante from producto);


-- IN y NOT IN en Tienda de Informática

-- 11.Devuelve los nombres de los fabricantes que tienen productos asociados. (Utilizando IN o NOT IN).
select nombre
from fabricante 
where codigo IN (select codigo_fabricante from producto);

-- 12.Devuelve los nombres de los fabricantes que no tienen productos asociados. (Utilizando IN o NOT IN).
select nombre
from fabricante 
where codigo NOT IN (select codigo_fabricante from producto);

-- tienda de informática
-- 13 Devuelve los nombres de los fabricantes que tienen productos asociados. (Utilizando EXISTS o NOT EXISTS).
select nombre 
from fabricante
where exists (select * from producto where codigo_fabricante=fabricante.codigo);

-- 14 Devuelve los nombres de los fabricantes que no tienen productos asociados. (Utilizando EXISTS o NOT EXISTS).
select nombre 
from fabricante
where not exists (select * from producto where codigo_fabricante=fabricante.codigo);
