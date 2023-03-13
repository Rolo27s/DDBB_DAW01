/* EJERCICIO DE VARIAS TABLAS DE JARDINERIA */
/* Resuelva todas las consultas utilizando la sintaxis de SQL1 y SQL2. Las consultas con
sintaxis de SQL2 se deben resolver con INNER JOIN y NATURAL JOIN. */

/* 1. Obtén un listado con el nombre de cada cliente y el nombre y apellido de su
representante de ventas. */
-- SQL1
SELECT c.nombre_cliente, e.nombre, e.apellido1, e.apellido2
FROM cliente c, empleado e
WHERE c.codigo_empleado_rep_ventas = e.codigo_empleado;

-- SQL2
SELECT c.nombre_cliente, e.nombre, e.apellido1, e.apellido2
FROM cliente c
INNER JOIN empleado e ON c.codigo_empleado_rep_ventas = e.codigo_empleado;

/* 2. Muestra el nombre de los clientes que hayan realizado pagos junto con el
nombre de sus representantes de ventas. */
-- SQL1
SELECT DISTINCT c.nombre_cliente AS cliente, e.nombre AS Representante_de_ventas
FROM cliente c, pago p, empleado e
WHERE c.codigo_cliente = p.codigo_cliente AND c.codigo_empleado_rep_ventas = e.codigo_empleado;

-- SQL2
SELECT DISTINCT c.nombre_cliente AS cliente, e.nombre AS Representante_de_ventas
FROM cliente c
INNER JOIN pago p ON c.codigo_cliente = p.codigo_cliente
INNER JOIN empleado e ON c.codigo_empleado_rep_ventas = e.codigo_empleado;

/* 3. Muestra el nombre de los clientes que no hayan realizado pagos junto con el
nombre de sus representantes de ventas. */
-- SQL1
SELECT c.nombre_cliente AS cliente, e.nombre AS Representante_de_ventas
FROM cliente c, pago p, empleado e
WHERE c.codigo_cliente = p.codigo_cliente(+)
AND c.codigo_empleado_rep_ventas = e.codigo_empleado
AND p.id_transaccion IS NULL;

-- SQL2
SELECT c.nombre_cliente AS cliente, e.nombre AS Representante_de_ventas
FROM cliente c
LEFT JOIN pago p ON c.codigo_cliente = p.codigo_cliente
INNER JOIN empleado e ON c.codigo_empleado_rep_ventas = e.codigo_empleado
WHERE p.id_transaccion IS NULL;

/* 4. Devuelve el nombre de los clientes que han hecho pagos y el nombre de sus
representantes junto con la ciudad de la oficina a la que pertenece el
representante. */
-- SQL1
SELECT DISTINCT c.nombre_cliente AS cliente, e.nombre AS representante_de_ventas, o.ciudad AS ciudad_de_oficina
FROM cliente c, pedido p, pago pg, empleado e, oficina o
WHERE c.codigo_cliente = p.codigo_cliente 
AND c.codigo_cliente = pg.codigo_cliente 
AND c.codigo_empleado_rep_ventas = e.codigo_empleado 
AND e.codigo_oficina = o.codigo_oficina;

-- SQL2
SELECT DISTINCT c.nombre_cliente AS cliente, e.nombre AS representante_de_ventas, o.ciudad AS ciudad_de_oficina
FROM cliente c
INNER JOIN pedido p ON c.codigo_cliente = p.codigo_cliente
INNER JOIN pago pg ON c.codigo_cliente = pg.codigo_cliente
INNER JOIN empleado e ON c.codigo_empleado_rep_ventas = e.codigo_empleado
INNER JOIN oficina o ON e.codigo_oficina = o.codigo_oficina;

/* 5. Devuelve el nombre de los clientes que no hayan hecho pagos y el nombre
de sus representantes junto con la ciudad de la oficina a la que pertenece el
representante. */
-- SQL1
SELECT DISTINCT c.nombre_cliente AS cliente, e.nombre AS representante_de_ventas, o.ciudad AS ciudad_de_oficina
FROM cliente c, pedido p, pago pg, empleado e, oficina o
WHERE c.codigo_cliente = p.codigo_cliente 
AND c.codigo_empleado_rep_ventas = e.codigo_empleado 
AND e.codigo_oficina = o.codigo_oficina 
AND (pg.codigo_cliente IS NULL OR pg.id_transaccion IS NULL);

-- SQL2
SELECT DISTINCT c.nombre_cliente AS cliente, e.nombre AS representante_de_ventas, o.ciudad AS ciudad_de_oficina
FROM cliente c
INNER JOIN pedido p ON c.codigo_cliente = p.codigo_cliente
LEFT JOIN pago pg ON c.codigo_cliente = pg.codigo_cliente
INNER JOIN empleado e ON c.codigo_empleado_rep_ventas = e.codigo_empleado
INNER JOIN oficina o ON e.codigo_oficina = o.codigo_oficina
WHERE pg.id_transaccion IS NULL;

/* 6. Lista la dirección de las oficinas que tengan clientes en Fuenlabrada. */
-- SQL1
SELECT DISTINCT o.linea_direccion1, o.linea_direccion2
FROM oficina o, empleado e, cliente c
WHERE o.codigo_oficina = e.codigo_oficina 
AND e.codigo_empleado = c.codigo_empleado_rep_ventas 
AND c.ciudad = 'Fuenlabrada';

-- SQL2
SELECT DISTINCT o.linea_direccion1, o.linea_direccion2
FROM oficina o
INNER JOIN empleado e ON o.codigo_oficina = e.codigo_oficina
INNER JOIN cliente c ON e.codigo_empleado = c.codigo_empleado_rep_ventas
WHERE c.ciudad = 'Fuenlabrada';


/* 7. Devuelve el nombre de los clientes y el nombre de sus representantes junto
con la ciudad de la oficina a la que pertenece el representante. */
-- SQL1
SELECT c.nombre_cliente AS cliente, e.nombre AS representante_de_ventas, o.ciudad AS ciudad_de_oficina
FROM cliente c, empleado e, oficina o
WHERE c.codigo_empleado_rep_ventas = e.codigo_empleado 
AND e.codigo_oficina = o.codigo_oficina;

-- SQL2
SELECT c.nombre_cliente AS cliente, e.nombre AS representante_de_ventas, o.ciudad AS ciudad_de_oficina
FROM cliente c
INNER JOIN empleado e ON c.codigo_empleado_rep_ventas = e.codigo_empleado
INNER JOIN oficina o ON e.codigo_oficina = o.codigo_oficina;


/* 8. Devuelve un listado con el nombre de los empleados junto con el nombre de
sus jefes. */
-- SQL1
SELECT e.nombre AS empleado, j.nombre AS jefe
FROM empleado e, empleado j
WHERE e.codigo_jefe = j.codigo_empleado;

-- SQL2
SELECT e.nombre AS empleado, j.nombre AS jefe
FROM empleado e
LEFT JOIN empleado j ON e.codigo_jefe = j.codigo_empleado;


/* 9. Devuelve un listado que muestre el nombre de cada empleados, el nombre
de su jefe y el nombre del jefe de su jefe. */
-- SQL1
SELECT e.nombre AS empleado, j1.nombre AS jefe, j2.nombre AS jefe_de_jefe
FROM empleado e, empleado j1, empleado j2
WHERE e.codigo_jefe = j1.codigo_empleado
AND j1.codigo_jefe = j2.codigo_empleado;

-- SQL2
SELECT e.nombre AS empleado, j1.nombre AS jefe, j2.nombre AS jefe_de_jefe
FROM empleado e
LEFT JOIN empleado j1 ON e.codigo_jefe = j1.codigo_empleado
LEFT JOIN empleado j2 ON j1.codigo_jefe = j2.codigo_empleado;

/* 10.Devuelve el nombre de los clientes a los que no se les ha entregado a tiempo
un pedido */
-- SQL1
SELECT DISTINCT c.nombre_cliente AS cliente
FROM cliente c, pedido p
WHERE c.codigo_cliente = p.codigo_cliente AND p.fecha_entrega > p.fecha_esperada;

-- SQL2
SELECT DISTINCT c.nombre_cliente AS cliente
FROM cliente c
INNER JOIN pedido p ON c.codigo_cliente = p.codigo_cliente
WHERE p.fecha_entrega > p.fecha_esperada;

/* 11.Devuelve un listado de las diferentes gamas de producto que ha comprado
cada cliente */
-- SQL1
SELECT DISTINCT c.nombre_cliente AS cliente, gp.gama
FROM cliente c, pedido p, detalle_pedido dp, producto pr, gama_producto gp
WHERE c.codigo_cliente = p.codigo_cliente
AND p.codigo_pedido = dp.codigo_pedido
AND dp.codigo_producto = pr.codigo_producto
AND pr.gama = gp.gama;

-- SQL2
SELECT DISTINCT c.nombre_cliente AS cliente, gp.gama
FROM cliente c
INNER JOIN pedido p ON c.codigo_cliente = p.codigo_cliente
INNER JOIN detalle_pedido dp ON p.codigo_pedido = dp.codigo_pedido
INNER JOIN producto pr ON dp.codigo_producto = pr.codigo_producto
INNER JOIN gama_producto gp ON pr.gama = gp.gama;

/* ------------------------------------------------- */
/* Resuelva todas las consultas utilizando las cláusulas LEFT JOIN, RIGHT JOIN,
NATURAL LEFT JOIN y NATURAL RIGHT JOIN. */
/* 1. Devuelve un listado que muestre solamente los clientes que no han
realizado ningún pago. */
-- LEFT JOIN
SELECT c.*
FROM cliente c
LEFT JOIN pago p ON c.codigo_cliente = p.codigo_cliente
WHERE p.codigo_cliente IS NULL;

-- RIGHT JOIN
SELECT c.*
FROM pago p
RIGHT JOIN cliente c ON c.codigo_cliente = p.codigo_cliente
WHERE p.codigo_cliente IS NULL;

-- NATURAL LEFT JOIN
SELECT c.*
FROM cliente c
NATURAL LEFT JOIN pago p
WHERE p.codigo_cliente IS NULL;

-- NATURAL RIGHT JOIN
SELECT c.*
FROM pago p
NATURAL RIGHT JOIN cliente c
WHERE p.codigo_cliente IS NULL;

/* 2. Devuelve un listado que muestre solamente los clientes que no han
realizado ningún pedido. */
-- LEFT JOIN
SELECT c.*
FROM cliente c
LEFT JOIN pedido p ON c.codigo_cliente = p.codigo_cliente
WHERE p.codigo_cliente IS NULL OR c.codigo_cliente IS NULL;

-- RIGHT JOIN (no posible), uso INNER JOIN
SELECT c.*
FROM cliente c
INNER JOIN pedido p ON c.codigo_cliente = p.codigo_cliente
WHERE NOT EXISTS (SELECT 1 FROM pago WHERE codigo_cliente = c.codigo_cliente);

-- NATURAL LEFT JOIN
SELECT c.*
FROM cliente c
NATURAL LEFT JOIN pedido p
WHERE p.codigo_cliente IS NULL OR c.codigo_cliente IS NULL;

-- NATURAL RIGHT JOIN
SELECT p.*
FROM cliente c
NATURAL RIGHT JOIN pedido p
WHERE p.codigo_cliente IS NULL OR c.codigo_cliente IS NULL;

/* 3. Devuelve un listado que muestre los clientes que no han realizado ningún
pago y los que no han realizado ningún pedido. */
-- LEFT JOIN
SELECT c.nombre_cliente AS cliente
FROM cliente c
LEFT JOIN pago p ON c.codigo_cliente = p.codigo_cliente
LEFT JOIN pedido pd ON c.codigo_cliente = pd.codigo_cliente
WHERE p.id_transaccion IS NULL AND pd.codigo_cliente IS NULL;

-- RIGHT JOIN
SELECT c.nombre_cliente AS cliente
FROM pago p
RIGHT JOIN cliente c ON c.codigo_cliente = p.codigo_cliente
RIGHT JOIN pedido pd ON c.codigo_cliente = pd.codigo_cliente
WHERE p.id_transaccion IS NULL AND pd.codigo_cliente IS NULL
AND c.codigo_cliente IS NOT NULL;

-- NATURAL LEFT JOIN
SELECT c.nombre_cliente AS cliente
FROM cliente c
NATURAL LEFT JOIN pago p
NATURAL LEFT JOIN pedido pd
WHERE p.id_transaccion IS NULL AND pd.codigo_cliente IS NULL;

-- NATURAL RIGHT JOIN
SELECT c.nombre_cliente AS cliente
FROM pago p
NATURAL RIGHT JOIN cliente c
NATURAL RIGHT JOIN pedido pd
WHERE p.id_transaccion IS NULL AND pd.codigo_cliente IS NULL
AND c.codigo_cliente IS NOT NULL;

/* 4. Devuelve un listado que muestre solamente los empleados que no tienen
una oficina asociada. */
-- LEFT JOIN
SELECT e.nombre AS empleado
FROM empleado e
LEFT JOIN oficina o ON e.codigo_oficina = o.codigo_oficina
WHERE e.codigo_oficina IS NULL;

-- RIGHT JOIN
SELECT e.nombre AS empleado
FROM oficina o
RIGHT JOIN empleado e ON e.codigo_oficina = o.codigo_oficina
WHERE o.codigo_oficina IS NULL;

-- NATURAL LEFT JOIN
SELECT e.nombre AS empleado
FROM empleado e
NATURAL LEFT JOIN oficina o
WHERE e.codigo_oficina IS NULL;

-- NATURAL RIGHT JOIN
SELECT e.nombre AS empleado
FROM oficina o
NATURAL RIGHT JOIN empleado e
WHERE o.codigo_oficina IS NULL;

/* 5. Devuelve un listado que muestre solamente los empleados que no tienen
un cliente asociado. */
-- LEFT JOIN
SELECT e.nombre AS empleado
FROM empleado e
LEFT JOIN cliente c ON e.codigo_empleado = c.codigo_empleado_rep_ventas
WHERE c.codigo_cliente IS NULL;

-- RIGHT JOIN
SELECT e.nombre AS empleado
FROM cliente c
RIGHT JOIN empleado e ON e.codigo_empleado = c.codigo_empleado_rep_ventas
WHERE c.codigo_cliente IS NULL;

-- NATURAL LEFT JOIN
SELECT e.nombre AS empleado
FROM empleado e
NATURAL LEFT JOIN cliente c
WHERE c.codigo_cliente IS NULL;

-- NATURAL RIGHT JOIN
SELECT e.nombre AS empleado
FROM cliente c
NATURAL RIGHT JOIN empleado e
WHERE c.codigo_cliente IS NULL;

/* 6. Devuelve un listado que muestre los empleados que no tienen un cliente
asociado junto con los datos de la oficina donde trabajan. */
-- LEFT JOIN
SELECT e.nombre AS empleado, o.ciudad AS ciudad_de_oficina
FROM empleado e
LEFT JOIN cliente c ON e.codigo_empleado = c.codigo_empleado_rep_ventas
LEFT JOIN oficina o ON e.codigo_oficina = o.codigo_oficina
WHERE c.codigo_cliente IS NULL;

-- RIGHT JOIN
SELECT e.nombre AS empleado, o.ciudad AS ciudad_de_oficina
FROM cliente c
RIGHT JOIN empleado e ON e.codigo_empleado = c.codigo_empleado_rep_ventas
INNER JOIN oficina o ON e.codigo_oficina = o.codigo_oficina
WHERE c.codigo_cliente IS NULL;

-- NATURAL LEFT JOIN
SELECT e.nombre AS empleado, o.ciudad AS ciudad_de_oficina
FROM empleado e
NATURAL LEFT JOIN cliente c 
INNER JOIN oficina o ON e.codigo_oficina = o.codigo_oficina
WHERE c.codigo_cliente IS NULL;

-- NATURAL RIGHT JOIN
SELECT e.nombre AS empleado, o.ciudad AS ciudad_de_oficina
FROM cliente c
NATURAL RIGHT JOIN empleado e
INNER JOIN oficina o ON e.codigo_oficina = o.codigo_oficina
WHERE c.codigo_cliente IS NULL;


/* 7. Devuelve un listado que muestre los empleados que no tienen una oficina
asociada y los que no tienen un cliente asociado. */
-- LEFT JOIN
SELECT e.codigo_empleado, e.nombre, e.codigo_oficina, c.codigo_cliente
FROM empleado e
LEFT JOIN cliente c ON e.codigo_empleado = c.codigo_empleado_rep_ventas
LEFT JOIN oficina o ON e.codigo_oficina = o.codigo_oficina
WHERE c.codigo_cliente IS NULL OR e.codigo_oficina IS NULL;

-- RIGHT JOIN
SELECT e.codigo_empleado, e.nombre, e.codigo_oficina, c.codigo_cliente
FROM empleado e
RIGHT JOIN oficina o ON e.codigo_oficina = o.codigo_oficina
LEFT JOIN cliente c ON e.codigo_empleado = c.codigo_empleado_rep_ventas
WHERE c.codigo_cliente IS NULL OR e.codigo_oficina IS NULL;

-- NATURAL LEFT JOIN
SELECT e.codigo_empleado, e.nombre, e.codigo_oficina, c.codigo_cliente
FROM empleado e
NATURAL LEFT JOIN cliente c
NATURAL RIGHT JOIN oficina o
WHERE c.codigo_cliente IS NULL OR e.codigo_oficina IS NULL;

-- NATURAL RIGHT JOIN
SELECT e.codigo_empleado, e.nombre, e.codigo_oficina, c.codigo_cliente
FROM empleado e
NATURAL LEFT JOIN oficina o
NATURAL RIGHT JOIN cliente c
WHERE c.codigo_cliente IS NULL OR e.codigo_oficina IS NULL;

/* 8. Devuelve un listado de los productos que nunca han aparecido en un
pedido. */
-- LEFT JOIN
SELECT DISTINCT p.nombre
FROM producto p
LEFT JOIN detalle_pedido dp ON p.codigo_producto = dp.codigo_producto
WHERE dp.codigo_producto IS NULL;

-- RIGHT JOIN
SELECT DISTINCT p.nombre
FROM detalle_pedido dp
RIGHT JOIN producto p ON p.codigo_producto = dp.codigo_producto
WHERE dp.codigo_producto IS NULL OR dp.codigo_producto IS NULL;

-- NATURAL LEFT JOIN
SELECT DISTINCT p.nombre
FROM producto p
NATURAL LEFT JOIN detalle_pedido dp
WHERE dp.codigo_producto IS NULL;

-- NATURAL RIGHT JOIN
SELECT DISTINCT p.nombre
FROM detalle_pedido dp
NATURAL RIGHT JOIN producto p
WHERE dp.codigo_producto IS NULL OR dp.codigo_producto IS NULL;

/* 9. Devuelve un listado de los productos que nunca han aparecido en un pedido. El
resultado debe mostrar el nombre, la descripción y la imagen del producto. */
-- LEFT JOIN
SELECT DISTINCT p.nombre AS nombre_del_producto, gp.descripcion_texto, gp.imagen
FROM producto p
INNER JOIN gama_producto gp ON p.gama = gp.gama
LEFT JOIN detalle_pedido dp ON p.codigo_producto = dp.codigo_producto
WHERE dp.codigo_producto IS NULL;

-- RIGHT JOIN
SELECT DISTINCT p.nombre AS nombre_del_producto, gp.descripcion_texto, gp.imagen
FROM detalle_pedido dp
RIGHT JOIN producto p ON dp.codigo_producto = p.codigo_producto
INNER JOIN gama_producto gp ON p.gama = gp.gama
WHERE dp.codigo_producto IS NULL;

-- NATURAL LEFT JOIN
SELECT DISTINCT p.nombre AS nombre_del_producto, gp.descripcion_texto, gp.imagen
FROM producto p
NATURAL LEFT JOIN detalle_pedido dp
INNER JOIN gama_producto gp ON p.gama = gp.gama
WHERE dp.codigo_producto IS NULL;

-- NATURAL RIGHT JOIN
SELECT DISTINCT p.nombre AS nombre_del_producto, gp.descripcion_texto, gp.imagen
FROM detalle_pedido dp
NATURAL RIGHT JOIN producto p
INNER JOIN gama_producto gp ON p.gama = gp.gama
WHERE dp.codigo_producto IS NULL;

/* 10. Devuelve las oficinas donde no trabajan ninguno de los empleados que
hayan sido los representantes de ventas de algún cliente que haya
realizado la compra de algún producto de la gama Frutales. */
-- LEFT JOIN
SELECT o.*
FROM oficina o
LEFT JOIN empleado e ON o.codigo_oficina = e.codigo_oficina
LEFT JOIN cliente c ON e.codigo_empleado = c.codigo_empleado_rep_ventas
LEFT JOIN pedido p ON c.codigo_cliente = p.codigo_cliente
LEFT JOIN detalle_pedido dp ON p.codigo_pedido = dp.codigo_pedido
LEFT JOIN producto pr ON dp.codigo_producto = pr.codigo_producto
LEFT JOIN gama_producto gp ON pr.gama = gp.gama AND gp.gama = 'Frutales'
WHERE e.codigo_empleado IS NULL;

-- RIGHT JOIN
SELECT o.*
FROM empleado e
RIGHT JOIN oficina o ON e.codigo_oficina = o.codigo_oficina
LEFT JOIN cliente c ON e.codigo_empleado = c.codigo_empleado_rep_ventas
LEFT JOIN pedido p ON c.codigo_cliente = p.codigo_cliente
LEFT JOIN detalle_pedido dp ON p.codigo_pedido = dp.codigo_pedido
LEFT JOIN producto pr ON dp.codigo_producto = pr.codigo_producto
LEFT JOIN gama_producto gp ON pr.gama = gp.gama AND gp.gama = 'Frutales'
WHERE o.codigo_oficina IS NOT NULL AND e.codigo_empleado IS NULL;

-- NATURAL LEFT JOIN
SELECT o.*
FROM oficina o
NATURAL LEFT JOIN empleado e
NATURAL LEFT JOIN cliente c
NATURAL LEFT JOIN pedido p
NATURAL LEFT JOIN detalle_pedido dp
NATURAL LEFT JOIN producto pr
NATURAL LEFT JOIN gama_producto gp
WHERE gp.gama = 'Frutales' AND e.codigo_empleado IS NULL;

-- NATURAL RIGHT JOIN
SELECT o.*
FROM empleado e
NATURAL RIGHT JOIN oficina o
NATURAL LEFT JOIN cliente c
NATURAL LEFT JOIN pedido p
NATURAL LEFT JOIN detalle_pedido dp
NATURAL LEFT JOIN producto pr
NATURAL LEFT JOIN gama_producto gp
WHERE gp.gama = 'Frutales' AND o.codigo_oficina IS NOT NULL AND e.codigo_empleado IS NULL;

/* 11. Devuelve un listado con los clientes que han realizado algún pedido pero
no han realizado ningún pago. */
-- LEFT JOIN
SELECT DISTINCT c.nombre_cliente
FROM cliente c
LEFT JOIN pedido pd ON c.codigo_cliente = pd.codigo_cliente
LEFT JOIN pago p ON c.codigo_cliente = p.codigo_cliente
WHERE p.id_transaccion IS NULL AND pd.codigo_pedido IS NOT NULL;

-- RIGHT JOIN
SELECT DISTINCT c.nombre_cliente
FROM pago p
RIGHT JOIN cliente c ON p.codigo_cliente = c.codigo_cliente
LEFT JOIN pedido pd ON c.codigo_cliente = pd.codigo_cliente
WHERE pd.codigo_pedido IS NOT NULL AND p.id_transaccion IS NULL;

-- NATURAL LEFT JOIN
SELECT DISTINCT c.nombre_cliente
FROM cliente c
NATURAL LEFT JOIN pedido pd
NATURAL LEFT JOIN pago p
WHERE p.id_transaccion IS NULL AND pd.codigo_pedido IS NOT NULL;

-- NATURAL RIGHT JOIN
SELECT DISTINCT c.nombre_cliente
FROM pago p
NATURAL RIGHT JOIN cliente c
LEFT JOIN pedido pd ON c.codigo_cliente = pd.codigo_cliente
WHERE pd.codigo_pedido IS NOT NULL AND p.id_transaccion IS NULL;

/* 12. Devuelve un listado con los datos de los empleados que no tienen clientes
asociados y el nombre de su jefe asociado. */
-- LEFT JOIN
SELECT e.nombre, j.nombre AS jefe
FROM empleado e
LEFT JOIN cliente c ON e.codigo_empleado = c.codigo_empleado_rep_ventas
LEFT JOIN empleado j ON e.codigo_jefe = j.codigo_empleado
WHERE c.codigo_cliente IS NULL;

-- RIGHT JOIN
SELECT e.nombre, j.nombre AS jefe
FROM empleado e
RIGHT JOIN empleado j ON e.codigo_jefe = j.codigo_empleado
LEFT JOIN cliente c ON e.codigo_empleado = c.codigo_empleado_rep_ventas
WHERE c.codigo_cliente IS NULL OR e.codigo_empleado IS NULL;

-- NATURAL LEFT JOIN
SELECT e.nombre, j.nombre AS jefe
FROM empleado e
LEFT JOIN cliente c ON e.codigo_empleado = c.codigo_empleado_rep_ventas
NATURAL JOIN empleado j
WHERE c.codigo_cliente IS NULL;

-- NATURAL RIGHT JOIN
SELECT e.nombre, j.nombre AS jefe
FROM empleado j
NATURAL RIGHT JOIN empleado e 
NATURAL LEFT JOIN cliente c
WHERE c.codigo_cliente IS NULL;