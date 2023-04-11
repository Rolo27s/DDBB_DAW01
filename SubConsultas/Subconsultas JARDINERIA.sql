-- SUBCONSULTAS JARDINERIA. Tengo muchas tablas.
-- 1. Devuelve el nombre del cliente con mayor límite de crédito.
SELECT nombre_cliente, limite_credito lim FROM cliente c WHERE limite_credito > ALL (SELECT limite_credito FROM cliente WHERE codigo_cliente != c.codigo_cliente);

-- 2. Devuelve el nombre del producto que tenga el precio de venta más caro.
SELECT * FROM producto;
SELECT nombre, precio_venta;

-- 3. Devuelve el nombre del producto del que se han vendido más unidades. 
-- (Tenga en cuenta que tendrá que calcular cuál es el número total de unidades que se han vendido de cada producto a partir de los datos de la tabla detalle_pedido. 
-- Una vez que sepa cuál es el código del producto, puede obtener su nombre fácilmente.)
SELECT p.nombre AS producto_mas_vendido FROM producto p, detalle_pedido dp WHERE p.codigo_producto = dp.codigo_producto AND dp.cantidad = (SELECT max(cantidad) FROM detalle_pedido);

-- 4. Los clientes cuyo límite de crédito sea mayor que los pagos que haya realizado. (Sin utilizar INNER JOIN). ¿Como funciona aqui el ALL?
SELECT * FROM cliente;
SELECT DISTINCT c.nombre_cliente, c.nombre_contacto, c.telefono, c.fax FROM pago p, cliente c 
WHERE c.codigo_cliente = p.codigo_cliente AND c.limite_credito > ALL (SELECT SUM(total) as total_suma FROM pago GROUP BY codigo_cliente);

-- ------------------------------------------------------------------------------------------------------------------------------------------------

-- 4.1. Suma del total de los pedidos realizados agrupados por cliente
SELECT codigo_cliente, SUM(total) as total_suma FROM pago GROUP BY codigo_cliente;

-- 4.2 Ampliacion de tabla. Tambien quiero ver que cantidad les queda para gastar.
SELECT c.nombre_cliente, c.nombre_contacto, c.telefono, c.fax, 
       (c.limite_credito - (SELECT SUM(total) as total_suma FROM pago WHERE codigo_cliente = c.codigo_cliente GROUP BY codigo_cliente))
       AS cantidad_disponible_tras_pago
FROM pago p, cliente c 
WHERE c.codigo_cliente = p.codigo_cliente
AND c.limite_credito > ALL (SELECT SUM(total) as total_suma FROM pago GROUP BY codigo_cliente);

-- 4.3 Lo mismo pero con INNER JOIN
SELECT c.nombre_cliente, c.nombre_contacto, c.telefono, c.fax, 
       (c.limite_credito - (SELECT SUM(total) as total_suma FROM pago WHERE codigo_cliente = c.codigo_cliente GROUP BY codigo_cliente))
       AS cantidad_disponible_tras_pago
FROM pago p
INNER JOIN cliente c ON c.codigo_cliente = p.codigo_cliente
WHERE c.limite_credito > ALL (SELECT SUM(total) as total_suma FROM pago GROUP BY codigo_cliente);

-- 4.4 AMPLIACION REVESA. Los clientes que deberan dinero porque no tienen suficientes fondos. NO MUESTRA CASOS PERO SI LOS HAY. REVISAR EN CLASE.
SELECT c.nombre_cliente, c.nombre_contacto, c.telefono, c.fax, 
       (c.limite_credito - (SELECT SUM(total) as total_suma FROM pago WHERE codigo_cliente = c.codigo_cliente GROUP BY codigo_cliente))
       AS cantidad_disponible_tras_pago
FROM pago p, cliente c 
WHERE c.codigo_cliente = p.codigo_cliente
AND c.limite_credito < ALL (SELECT SUM(total) as total_suma FROM pago GROUP BY codigo_cliente);

-- 4.5 Igual que 4.4 pero con sintaxis mas reducida. ¿Por que me salta este error?
SELECT c.nombre_cliente, c.nombre_contacto, c.telefono, c.fax,
       c.limite_credito - SUM(p.total) AS cantidad_disponible_tras_pago
FROM pago p
JOIN cliente c ON c.codigo_cliente = p.codigo_cliente
GROUP BY c.codigo_cliente
HAVING c.limite_credito < SUM(p.total);

-- 4.6 Otra opcion con mismo error
SELECT c.nombre_cliente, c.nombre_contacto, c.telefono, c.fax,
       c.limite_credito - (SELECT SUM(p.total) FROM pago p WHERE p.codigo_cliente = c.codigo_cliente) AS cantidad_disponible_tras_pago
FROM cliente c
HAVING c.limite_credito < (SELECT SUM(p.total) FROM pago p WHERE p.codigo_cliente = c.codigo_cliente);

-- 4.7 Otra opcion con mismo error
SELECT c.nombre_cliente, c.nombre_contacto, c.telefono, c.fax,
       c.limite_credito - total_pagos.total_suma AS cantidad_disponible_tras_pago
FROM cliente c
JOIN (SELECT codigo_cliente, SUM(total) as total_suma
      FROM pago
      GROUP BY codigo_cliente) total_pagos ON c.codigo_cliente = total_pagos.codigo_cliente
HAVING c.limite_credito < total_pagos.total_suma;

-- 4.8 Otra opcion con mismo error
SELECT c.nombre_cliente, c.nombre_contacto, c.telefono, c.fax,
       c.limite_credito - IFNULL(SUM(p.total), 0) AS cantidad_disponible_tras_pago
FROM cliente c
LEFT JOIN pago p ON c.codigo_cliente = p.codigo_cliente
GROUP BY c.codigo_cliente
HAVING c.limite_credito < IFNULL(SUM(p.total), 0);

-- ------------------------------------------------------------------------------------------------------------------------------------------------

-- 5. Devuelve el producto que más unidades tiene en stock.
select * from producto where cantidad_en_stock >= (SELECT max(cantidad_en_stock) FROM producto);

-- 6. Devuelve el producto que menos unidades tiene en stock.
select * from producto where cantidad_en_stock <= (SELECT min(cantidad_en_stock) FROM producto);

-- 7. Devuelve el nombre, los apellidos y el email de los empleados que están a cargo de Alberto Soria.
select nombre, apellido1, apellido2, email from empleado where codigo_jefe = (SELECT codigo_empleado FROM empleado WHERE nombre = 'Alberto' AND apellido1 = 'Soria');

-- 8. Devuelve el nombre del cliente con mayor límite de crédito.
select nombre_cliente from cliente where limite_credito >= (SELECT max(limite_credito) from cliente);

-- 9. Devuelve el nombre del producto que tenga el precio de venta más caro.
select nombre, precio_venta from producto where precio_venta >= (select max(precio_venta) from producto);

-- 10. Devuelve el producto que menos unidades tiene en stock. REPETIDA.
select nombre, cantidad_en_stock from producto where cantidad_en_stock <= (select min(cantidad_en_stock) from producto);

-- 11. Devuelve el nombre, apellido1 y cargo de los empleados que no representen a ningún cliente.
select apellido1, puesto from empleado where codigo_empleado NOT IN (select codigo_empleado_rep_ventas from cliente);

-- 12. Devuelve un listado que muestre solamente los clientes que no han realizado ningún pago. ??? 
-- 12.b (Enunciado de doble negacion, entiendo como sinónimo este enunciado) Devuelve un listado que muestre solamente los clientes que han realizado algún pago.
select * from cliente c where EXISTS (select codigo_cliente from pago p where c.codigo_cliente=p.codigo_cliente);

-- 13. Devuelve un listado que muestre solamente los clientes que sí han realizado ningún pago. ???
-- 13.b (Negación simple con orden inverso. Enunciado similar para mi) Devuelve un listado que muestre solamente los clientes que no han realizado algún pago.
select * from cliente c where NOT EXISTS (select codigo_cliente from pago p where c.codigo_cliente=p.codigo_cliente);

-- 14. Devuelve un listado de los productos que nunca han aparecido en un pedido.
select * from producto p where not exists (select codigo_producto from detalle_pedido dp where p.codigo_producto=dp.codigo_producto);

-- 15. Devuelve el nombre, apellidos, puesto y teléfono de la oficina de aquellos empleados que no sean representante de ventas de ningún cliente. REPETIDA
select apellido1, puesto from empleado where codigo_empleado NOT IN (select codigo_empleado_rep_ventas from cliente);

-- 16. Devuelve las oficinas donde no trabajan ninguno de los empleados que hayan sido los representantes de ventas de algún cliente que haya realizado la compra de algún producto de la gama Frutales.
-- 16b Doble negacion = afirmacion. Enunciado similar mas claro:
-- Devuelve las oficinas donde trabaja algún empleado, que haya sido representante de ventas de algún cliente, que haya realizado la compra de algún producto de la gama Frutales.
select o.* from oficina o, gama_producto gp where exists (select apellido1, puesto from empleado where codigo_empleado IN (select codigo_empleado_rep_ventas from cliente)) AND gp.gama = 'Frutales';

-- 17. Devuelve un listado con los clientes que han realizado algún pedido pero no han realizado ningún pago.
select nombre_cliente from cliente c where exists 
	(select codigo_cliente from pedido ped where c.codigo_cliente=ped.codigo_cliente)
    AND c.codigo_cliente NOT IN (select p.codigo_cliente from pago p); -- No eran necesarios los ultimos alias

-- 18. Devuelve un listado que muestre solamente los clientes que no han realizado ningún pago.
select nombre_cliente from cliente c where not exists (select codigo_cliente from pago p where c.codigo_cliente=p.codigo_cliente);

-- 19. Devuelve un listado que muestre solamente los clientes que sí han realizado algún pago.
select nombre_cliente from cliente c where exists (select codigo_cliente from pago p where c.codigo_cliente=p.codigo_cliente);

-- 20. Devuelve un listado de los productos que nunca han aparecido en un pedido. REPETIDA.
select * from producto p where not exists (select codigo_producto from detalle_pedido dp where p.codigo_producto=dp.codigo_producto);

-- 21. Devuelve un listado de los productos que han aparecido en un pedido alguna vez.
select * from producto p where exists (select codigo_producto from detalle_pedido dp where p.codigo_producto=dp.codigo_producto);
