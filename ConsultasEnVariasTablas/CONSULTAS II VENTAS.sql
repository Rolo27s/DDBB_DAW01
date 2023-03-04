-- Resuelva todas las consultas utilizando la sintaxis de SQL1 y SQL2.
/* Primero miro tabla a tabla para la comprension de la base de datos */
SELECT * FROM cliente;
SELECT * FROM comercial;
SELECT * FROM pedido;

-- 1. Devuelve un listado con el identificador, nombre y los apellidos de todos los clientes que han realizado algún pedido. 
-- El listado debe estar ordenado alfabéticamente y se deben eliminar los elementos repetidos.
SELECT DISTINCT cliente.id, cliente.nombre, cliente.apellido1, cliente.apellido2
FROM cliente, pedido
WHERE cliente.id = pedido.id_cliente
ORDER BY cliente.nombre, cliente.apellido1, cliente.apellido2;

-- 2. Devuelve un listado que muestre todos los pedidos que ha realizado cada cliente. 
-- El resultado debe mostrar todos los datos de los pedidos y del cliente. 
-- El listado debe mostrar los datos de los clientes ordenados alfabéticamente.
SELECT DISTINCT cliente.id, cliente.nombre, cliente.apellido1, cliente.apellido2, cliente.ciudad, cliente.categoría,
pedido.id, pedido.total, pedido.fecha, pedido.id_cliente, pedido.id_comercial
FROM cliente, pedido
WHERE cliente.id = pedido.id_cliente
ORDER BY cliente.nombre, cliente.apellido1, cliente.apellido2;

-- 3. Devuelve un listado que muestre todos los pedidos en los que ha participado un comercial. 
-- El resultado debe mostrar todos los datos de los pedidos y de los comerciales. 
-- El listado debe mostrar los datos de los comerciales ordenados alfabéticamente.
SELECT DISTINCT comercial.id, comercial.nombre, comercial.apellido1, comercial.apellido2, comercial.comisión, 
pedido.id, pedido.total, pedido.fecha, pedido.id_cliente, pedido.id_comercial
FROM comercial, pedido
WHERE comercial.id = pedido.id_comercial
ORDER BY comercial.nombre, comercial.apellido1, comercial.apellido2;

-- 4. Devuelve un listado que muestre todos los clientes, con todos los pedidos que han realizado y con los datos de los comerciales asociados a cada pedido.
SELECT DISTINCT comercial.id, comercial.nombre, comercial.apellido1, comercial.apellido2, comercial.comisión, 
pedido.id, pedido.total, pedido.fecha, pedido.id_cliente, pedido.id_comercial,
cliente.id, cliente.nombre, cliente.apellido1, cliente.apellido2, cliente.ciudad, cliente.categoría
FROM comercial, pedido, cliente
WHERE comercial.id = pedido.id_comercial AND pedido.id_cliente = cliente.id;

-- 5. Devuelve un listado de todos los clientes que realizaron un pedido durante el año 2017, cuya cantidad esté entre 300 € y 1000 €.
SELECT DISTINCT cliente.id, cliente.nombre, cliente.apellido1, cliente.apellido2, cliente.ciudad, cliente.categoría,
pedido.id, pedido.total, pedido.fecha, pedido.id_cliente, pedido.id_comercial
FROM cliente, pedido
WHERE cliente.id = pedido.id_cliente
AND pedido.fecha LIKE '2017%' 
AND pedido.total BETWEEN 300 AND 1000;

-- 6. Devuelve el nombre y los apellidos de todos los comerciales que han participado en algún pedido realizado por María Santana Moreno.
-- (María tiene id cliente 6, ha hecho 2 pedidos y el id comercial que le atendio es el 1, Daniel.)
SELECT DISTINCT comercial.nombre, comercial.apellido1, comercial.apellido2
FROM comercial, pedido, cliente
WHERE comercial.id = pedido.id_comercial AND pedido.id_cliente = cliente.id
AND cliente.nombre LIKE 'María'
AND cliente.apellido1 LIKE 'Santana'
AND cliente.apellido2 LIKE 'Moreno';

-- 7. Devuelve el nombre de todos los clientes que han realizado algún pedido con el comercial Daniel Sáez Vega.
SELECT DISTINCT cliente.nombre, cliente.apellido1, cliente.apellido2
FROM comercial, pedido, cliente
WHERE comercial.id = pedido.id_comercial AND pedido.id_cliente = cliente.id
AND comercial.nombre LIKE 'Daniel'
AND comercial.apellido1 LIKE 'Sáez'
AND comercial.apellido2 LIKE 'Vega';


-- Resuelva todas las consultas utilizando las cláusulas LEFT JOIN y RIGHT JOIN.

-- 1. Devuelve un listado con todos los clientes junto con los datos de los pedidos que han realizado. 
-- Este listado también debe incluir los clientes que no han realizado ningún pedido. 
-- El listado debe estar ordenado alfabéticamente por el primer apellido, segundo apellido y nombre de los clientes.
SELECT DISTINCT cliente.id, cliente.nombre, cliente.apellido1, cliente.apellido2,
pedido.id, pedido.total, pedido.fecha, pedido.id_cliente, pedido.id_comercial
FROM cliente LEFT JOIN pedido
ON cliente.id = pedido.id_cliente
ORDER BY cliente.apellido1, cliente.apellido2, cliente.nombre;
/* Aclaracion didactica: Con right join me sale los clientes que hicieron algun pedido y con left join me saldrían todos los clientes, hayan o no hayan realizado un pedido. 
El join coge completo la parte donde se referencia, en este caso con el right join, coge la parte completa de pedidos y excluye a los clientes que no hizo ninguno */ 


-- 2. Devuelve un listado con todos los comerciales junto con los datos de los pedidos que han realizado. 
-- Este listado también debe incluir los comerciales que no han realizado ningún pedido. 
-- El listado debe estar ordenado alfabéticamente por el primer apellido, segundo apellido y nombre de los comerciales.
SELECT DISTINCT comercial.id, comercial.nombre, comercial.apellido1, comercial.apellido2, comercial.comisión, 
pedido.id, pedido.total, pedido.fecha, pedido.id_cliente, pedido.id_comercial
FROM comercial LEFT JOIN pedido
ON comercial.id = pedido.id_comercial
ORDER BY comercial.apellido1, comercial.apellido2, comercial.nombre;

-- 3. Devuelve un listado que solamente muestre los clientes que no han realizado ningún pedido.
SELECT DISTINCT cliente.id, cliente.nombre, cliente.apellido1, cliente.apellido2
FROM cliente LEFT JOIN pedido
ON cliente.id = pedido.id_cliente
WHERE pedido.id IS NULL;

-- 4. Devuelve un listado que solamente muestre los comerciales que no han realizado ningún pedido.
SELECT DISTINCT comercial.id, comercial.nombre, comercial.apellido1, comercial.apellido2, comercial.comisión
FROM comercial LEFT JOIN pedido
ON comercial.id = pedido.id_comercial
WHERE pedido.id IS NULL;

-- 5. Devuelve un listado con los clientes que no han realizado ningún pedido y de los comerciales que no han participado en ningún pedido. 
-- Ordene el listado alfabéticamente por los apellidos y el nombre.

SELECT id, nombre, apellido1, apellido2
FROM (
SELECT DISTINCT cliente.id, cliente.nombre, cliente.apellido1, cliente.apellido2
FROM cliente LEFT JOIN pedido
ON cliente.id = pedido.id_cliente
WHERE pedido.id IS NULL
) t1

UNION

SELECT id, nombre, apellido1, apellido2
FROM (
SELECT DISTINCT comercial.id, comercial.nombre, comercial.apellido1, comercial.apellido2
FROM comercial LEFT JOIN pedido
ON comercial.id = pedido.id_comercial
WHERE pedido.id IS NULL
) t2

ORDER BY apellido1, apellido2, nombre;

-- ¿Se podrían realizar las consultas anteriores con NATURAL LEFT JOIN o NATURAL RIGHT JOIN? Justifique su respuesta.
/* No, porque las columnas que se unen en el JOIN tienen diferentes nombres, tipos de variables, numero de campos...
Para usar un NATURAL JOIN todo debe ser similar, y en caso de serlo, sigue siendo más seguro tratar de usar otros JOIN */