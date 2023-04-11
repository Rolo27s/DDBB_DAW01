-- SUBCONSULTAS VENTAS. Tengo solo estas 3 tablas en esta base de datos.
SELECT * FROM cliente;
SELECT * FROM comercial;
SELECT * FROM pedido;

-- 1. Devuelve un listado con todos los pedidos que ha realizado Adela Salas Díaz. (Sin utilizar INNER JOIN).
SELECT * FROM pedido WHERE id_cliente = (SELECT id FROM cliente WHERE nombre = 'Adela' AND apellido1 = 'Salas' AND apellido2 = 'Díaz');
SELECT * FROM pedido WHERE id_cliente = (SELECT id FROM cliente WHERE concat_ws(' ', nombre, apellido1, apellido2) = 'Adela Salas Díaz');

-- 2. Devuelve el número de pedidos en los que ha participado el comercial Daniel Sáez Vega. (Sin utilizar INNER JOIN)
SELECT * FROM pedido WHERE id_comercial = (SELECT id FROM comercial WHERE concat_ws(' ', nombre, apellido1, apellido2) = 'Daniel Sáez Vega');

-- 3. Devuelve los datos del cliente que realizó el pedido más caro en el año 2019. (Sin utilizar INNER JOIN)
SELECT * FROM cliente WHERE id = (SELECT id_cliente FROM pedido WHERE total = ((SELECT max(total) FROM pedido WHERE year(fecha) = '2019')));

-- 4. Devuelve la fecha y la cantidad del pedido de menor valor realizado por el cliente Pepe Ruiz Santana.
SELECT fecha, total FROM pedido WHERE id_cliente = (SELECT id FROM cliente WHERE concat_ws(' ', nombre, apellido1, apellido2) = 'Pepe Ruiz Santana')
ORDER BY 2
LIMIT 1;

-- 5. Devuelve un listado con los datos de los clientes y los pedidos, de todos los clientes que han realizado un pedido 
-- durante el año 2017 con un valor mayor o igual al valor medio de los pedidos realizados durante ese mismo año.
SELECT * FROM cliente, pedido WHERE cliente.id = pedido.id_cliente AND year(fecha) = '2017' AND total >= (SELECT AVG(total) FROM pedido WHERE year(fecha) = '2017');

-- 6. Devuelve el pedido más caro que existe en la tabla pedido sin hacer uso de MAX, ORDER BY ni LIMIT.
SELECT * FROM pedido p WHERE total > ALL (SELECT total FROM pedido WHERE id != p.id);

-- 7. Devuelve un listado de los clientes que no han realizado ningún pedido. (Utilizando ANY o ALL).
SELECT * FROM cliente WHERE id != ALL (SELECT id_cliente FROM pedido);

-- 8. Devuelve un listado de los comerciales que no han realizado ningún pedido. (Utilizando ANY o ALL).
SELECT * FROM comercial WHERE id != ALL (SELECT id_comercial FROM pedido);

-- 9. Devuelve un listado de los clientes que no han realizado ningún pedido. (Utilizando IN o NOT IN).
SELECT * FROM cliente WHERE id NOT IN (SELECT id_cliente FROM pedido);

-- 10. Devuelve un listado de los comerciales que no han realizado ningún pedido. (Utilizando IN o NOT IN).
SELECT * FROM comercial WHERE id NOT IN (SELECT id_comercial FROM pedido);

-- 11. Devuelve un listado de los clientes que no han realizado ningún pedido. (Utilizando EXISTS o NOT EXISTS).
SELECT * FROM cliente c WHERE NOT EXISTS (SELECT id_cliente FROM pedido WHERE id_cliente=c.id);

-- 12. Devuelve un listado de los comerciales que no han realizado ningún pedido. (Utilizando EXISTS o NOT EXISTS).
SELECT * FROM comercial c WHERE NOT EXISTS (SELECT id_comercial FROM pedido WHERE id_comercial=c.id);
