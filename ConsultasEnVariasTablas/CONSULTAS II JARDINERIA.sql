/* EJERCICIO DE VARIAS TABLAS DE JARDINERIA */
/* 1. Obtén un listado con el nombre de cada cliente y el nombre y apellido de su
representante de ventas. */
SELECT c.nombre_cliente, e.nombre, e.apellido1, e.apellido2
FROM cliente c
INNER JOIN empleado e ON c.codigo_empleado_rep_ventas = e.codigo_empleado;

/* 2. Muestra el nombre de los clientes que hayan realizado pagos junto con el
nombre de sus representantes de ventas. */
SELECT DISTINCT c.nombre_cliente AS cliente, e.nombre AS Representante_de_ventas
FROM cliente c
INNER JOIN pago p ON c.codigo_cliente = p.codigo_cliente
INNER JOIN empleado e ON c.codigo_empleado_rep_ventas = e.codigo_empleado;

/* 3. Muestra el nombre de los clientes que no hayan realizado pagos junto con el
nombre de sus representantes de ventas. */
SELECT c.nombre_cliente AS cliente, e.nombre AS Representante_de_ventas
FROM cliente c
LEFT JOIN pago p ON c.codigo_cliente = p.codigo_cliente
INNER JOIN empleado e ON c.codigo_empleado_rep_ventas = e.codigo_empleado
WHERE p.id_transaccion IS NULL;

/* 4. Devuelve el nombre de los clientes que han hecho pagos y el nombre de sus
representantes junto con la ciudad de la oficina a la que pertenece el
representante. */
SELECT DISTINCT c.nombre_cliente AS cliente, e.nombre AS representante_de_ventas, o.ciudad AS ciudad_de_oficina
FROM cliente c
INNER JOIN pedido p ON c.codigo_cliente = p.codigo_cliente
INNER JOIN pago pg ON c.codigo_cliente = pg.codigo_cliente
INNER JOIN empleado e ON c.codigo_empleado_rep_ventas = e.codigo_empleado
INNER JOIN oficina o ON e.codigo_oficina = o.codigo_oficina;

/* 5. Devuelve el nombre de los clientes que no hayan hecho pagos y el nombre
de sus representantes junto con la ciudad de la oficina a la que pertenece el
representante. */
SELECT DISTINCT c.nombre_cliente AS cliente, e.nombre AS representante_de_ventas, o.ciudad AS ciudad_de_oficina
FROM cliente c
INNER JOIN pedido p ON c.codigo_cliente = p.codigo_cliente
LEFT JOIN pago pg ON c.codigo_cliente = pg.codigo_cliente
INNER JOIN empleado e ON c.codigo_empleado_rep_ventas = e.codigo_empleado
INNER JOIN oficina o ON e.codigo_oficina = o.codigo_oficina
WHERE pg.id_transaccion IS NULL;

/* 6. Lista la dirección de las oficinas que tengan clientes en Fuenlabrada. */
SELECT DISTINCT o.linea_direccion1, o.linea_direccion2
FROM oficina o
INNER JOIN empleado e ON o.codigo_oficina = e.codigo_oficina
INNER JOIN cliente c ON e.codigo_empleado = c.codigo_empleado_rep_ventas
WHERE c.ciudad = 'Fuenlabrada';


/* 7. Devuelve el nombre de los clientes y el nombre de sus representantes junto
con la ciudad de la oficina a la que pertenece el representante. */
SELECT c.nombre_cliente AS cliente, e.nombre AS representante_de_ventas, o.ciudad AS ciudad_de_oficina
FROM cliente c
INNER JOIN empleado e ON c.codigo_empleado_rep_ventas = e.codigo_empleado
INNER JOIN oficina o ON e.codigo_oficina = o.codigo_oficina;


/* 8. Devuelve un listado con el nombre de los empleados junto con el nombre de
sus jefes. */
SELECT e.nombre AS empleado, j.nombre AS jefe
FROM empleado e
LEFT JOIN empleado j ON e.codigo_jefe = j.codigo_empleado;


/* 9. Devuelve un listado que muestre el nombre de cada empleados, el nombre
de su jefe y el nombre del jefe de su jefe. */
SELECT e.nombre AS empleado, j1.nombre AS jefe, j2.nombre AS jefe_de_jefe
FROM empleado e
LEFT JOIN empleado j1 ON e.codigo_jefe = j1.codigo_empleado
LEFT JOIN empleado j2 ON j1.codigo_jefe = j2.codigo_empleado;

/* 10.Devuelve el nombre de los clientes a los que no se les ha entregado a tiempo
un pedido */
SELECT DISTINCT c.nombre_cliente AS cliente
FROM cliente c
INNER JOIN pedido p ON c.codigo_cliente = p.codigo_cliente
WHERE p.fecha_entrega > p.fecha_esperada;

/* 11.Devuelve un listado de las diferentes gamas de producto que ha comprado
cada cliente */
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
SELECT c.*
FROM cliente c
LEFT JOIN pago p ON c.codigo_cliente = p.codigo_cliente
WHERE p.codigo_cliente IS NULL;

/* 1b. La misma cláusula pero usando natural join */
SELECT c.*
FROM cliente c
NATURAL LEFT JOIN pago p
WHERE p.codigo_cliente IS NULL;

/* 2. Devuelve un listado que muestre solamente los clientes que no han
realizado ningún pedido. */
SELECT c.*
FROM cliente c
RIGHT JOIN pedido p ON c.codigo_cliente = p.codigo_cliente
WHERE p.codigo_cliente IS NULL;

/* 2b. La misma cláusula pero usando natural join */
SELECT c.*
FROM cliente c
NATURAL RIGHT JOIN pedido p
WHERE p.codigo_cliente IS NULL;

/* 3. Devuelve un listado que muestre los clientes que no han realizado ningún
pago y los que no han realizado ningún pedido. */
SELECT c.nombre_cliente AS cliente
FROM cliente c
LEFT JOIN pago p ON c.codigo_cliente = p.codigo_cliente
LEFT JOIN pedido pd ON c.codigo_cliente = pd.codigo_cliente
WHERE p.id_transaccion IS NULL AND pd.codigo_cliente IS NULL;

/* 4. Devuelve un listado que muestre solamente los empleados que no tienen
una oficina asociada. */
SELECT e.nombre AS empleado
FROM empleado e
LEFT JOIN oficina o ON e.codigo_oficina = o.codigo_oficina
WHERE o.codigo_oficina IS NULL;

/* Compruebo la lista general de empleados para asegurarme de que todos los empleados tienen oficionas asignadas y así es */
select e.* from empleado e;

/* 5. Devuelve un listado que muestre solamente los empleados que no tienen
un cliente asociado. */
SELECT e.nombre AS empleado
FROM empleado e
LEFT JOIN cliente c ON e.codigo_empleado = c.codigo_empleado_rep_ventas
WHERE c.codigo_cliente IS NULL;

/* 6. Devuelve un listado que muestre los empleados que no tienen un cliente
asociado junto con los datos de la oficina donde trabajan. */
SELECT e.nombre AS empleado, o.ciudad AS ciudad_de_oficina
FROM empleado e
LEFT JOIN cliente c ON e.codigo_empleado = c.codigo_empleado_rep_ventas
INNER JOIN oficina o ON e.codigo_oficina = o.codigo_oficina
WHERE c.codigo_cliente IS NULL;


/* 7. Devuelve un listado que muestre los empleados que no tienen una oficina
asociada y los que no tienen un cliente asociado. */
SELECT e.codigo_empleado, e.nombre, e.codigo_oficina, c.codigo_cliente
FROM empleado e
LEFT JOIN cliente c ON e.codigo_empleado = c.codigo_empleado_rep_ventas
RIGHT JOIN oficina o ON e.codigo_oficina = o.codigo_oficina
WHERE c.codigo_cliente IS NULL OR e.codigo_oficina IS NULL;
/* Vemos que todos tienen oficinas, pero no todos tienen clientes asociados */

/* 8. Devuelve un listado de los productos que nunca han aparecido en un
pedido. */
SELECT DISTINCT p.nombre
FROM producto p
LEFT JOIN detalle_pedido dp ON p.codigo_producto = dp.codigo_producto
WHERE dp.codigo_producto IS NULL;

/* 9. Devuelve un listado de los productos que nunca han aparecido en un pedido. El
resultado debe mostrar el nombre, la descripción y la imagen del producto. */
SELECT DISTINCT p.nombre AS nombre_del_producto, gp.descripcion_texto, gp.imagen
FROM producto p
INNER JOIN gama_producto gp ON p.gama = gp.gama
LEFT JOIN detalle_pedido dp ON p.codigo_producto = dp.codigo_producto
WHERE dp.codigo_producto IS NULL;

/* 10. Devuelve las oficinas donde no trabajan ninguno de los empleados que
hayan sido los representantes de ventas de algún cliente que haya
realizado la compra de algún producto de la gama Frutales. */
SELECT o.*
FROM oficina o
LEFT JOIN empleado e ON o.codigo_oficina = e.codigo_oficina
LEFT JOIN cliente c ON e.codigo_empleado = c.codigo_empleado_rep_ventas
LEFT JOIN pedido p ON c.codigo_cliente = p.codigo_cliente
LEFT JOIN detalle_pedido dp ON p.codigo_pedido = dp.codigo_pedido
LEFT JOIN producto pr ON dp.codigo_producto = pr.codigo_producto
LEFT JOIN gama_producto gp ON pr.gama = gp.gama
WHERE gp.gama = 'Frutales' AND e.codigo_empleado IS NULL;
/* Tal y como esta redactada la consulta entiendo que sería de la manera expuesta.
Creo que no tiene mucho sentido ya que vimos anteriormente que todos los empleados trabajaban en alguna oficina, 
por tanto, siempre saldra la consulta con ningun resultado, sea cual sea la condicion de la compra de productos.
Una consulta parecida que creo que tiene mas sentido sería esta:
10b. Devuelve las oficinas donde trabajan empleados que
hayan sido los representantes de ventas de algún cliente que haya
realizado la compra de algún producto de la gama Frutales. 
*/
SELECT DISTINCT o.*
FROM oficina o
LEFT JOIN empleado e ON o.codigo_oficina = e.codigo_oficina
LEFT JOIN cliente c ON e.codigo_empleado = c.codigo_empleado_rep_ventas
LEFT JOIN pedido p ON c.codigo_cliente = p.codigo_cliente
LEFT JOIN detalle_pedido dp ON p.codigo_pedido = dp.codigo_pedido
LEFT JOIN producto pr ON dp.codigo_producto = pr.codigo_producto
LEFT JOIN gama_producto gp ON pr.gama = gp.gama
WHERE gp.gama = 'Frutales';

/* 11. Devuelve un listado con los clientes que han realizado algún pedido pero
no han realizado ningún pago. */
SELECT DISTINCT c.nombre_cliente
FROM cliente c
LEFT JOIN pedido pd ON c.codigo_cliente = pd.codigo_cliente
LEFT JOIN pago p ON c.codigo_cliente = p.codigo_cliente
WHERE p.id_transaccion IS NULL AND pd.codigo_pedido IS NOT NULL;

/* 12. Devuelve un listado con los datos de los empleados que no tienen clientes
asociados y el nombre de su jefe asociado. */
SELECT e.nombre, j.nombre AS jefe
FROM empleado e
LEFT JOIN cliente c ON e.codigo_empleado = c.codigo_empleado_rep_ventas
INNER JOIN empleado j ON e.codigo_jefe = j.codigo_empleado
WHERE c.codigo_cliente IS NULL;