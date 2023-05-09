-- 05_DML_Vistas
-- Base de datos: Jardinería. Ejercicios de vistas
-- 1.	Escriba una vista que se llame listado_pagos_clientes que muestre un listado donde aparezcan todos los clientes y los pagos que ha realizado cada uno de ellos. 
-- La vista deberá tener las siguientes columnas: nombre y apellidos del cliente concatenados, teléfono, ciudad, pais, fecha_pago, total del pago, id de la transacción, id del cliente
select * from cliente;
select * from pago;

CREATE VIEW listado_pagos_clientes AS
SELECT CONCAT(nombre_contacto, ' ', apellido_contacto) AS contacto, telefono, ciudad, pais, fecha_pago, total, id_transaccion, pago.codigo_cliente
FROM cliente 
JOIN pago ON cliente.codigo_cliente = pago.codigo_cliente;

select * from listado_pagos_clientes;

select * from pedido;
select * from detalle_pedido;

-- 2.	Escriba una vista que se llame listado_pedidos_clientes que muestre un listado donde aparezcan todos los clientes y los pedidos que ha realizado cada uno de ellos. 
-- La vista debe tener las siguientes columnas: nombre y apellidos del cliente concatenados, teléfono, ciudad, pais, código del pedido, fecha del pedido, fecha esperada, 
-- fecha de entrega y la cantidad total del pedido, que será la suma del producto de todas las cantidades por el precio de cada unidad, que aparecen en cada línea de pedido.
CREATE VIEW listado_pedidos_clientes AS
SELECT CONCAT(nombre_contacto, ' ', apellido_contacto) AS contacto, 
       telefono, 
       ciudad, 
       pais, 
       pedido.codigo_pedido, 
       fecha_pedido, 
       fecha_esperada, 
       fecha_entrega, 
       SUM(cantidad * precio_unidad) AS total_pedido
FROM cliente 
JOIN pedido ON cliente.codigo_cliente = pedido.codigo_cliente
JOIN detalle_pedido ON pedido.codigo_pedido = detalle_pedido.codigo_pedido
GROUP BY pedido.codigo_pedido;

select * from listado_pedidos_clientes;

-- 3.	Utilice las vistas que ha creado en los pasos anteriores para devolver un listado de los clientes de la ciudad de Madrid que han realizado pagos.
SELECT * FROM listado_pagos_clientes WHERE ciudad = 'Madrid';

-- 4.	Utilice las vistas que ha creado en los pasos anteriores para devolver un listado de los clientes que todavía no han recibido su pedido.
SELECT * FROM listado_pedidos_clientes WHERE fecha_entrega IS NULL;

-- 5.	Utilice las vistas que ha creado en los pasos anteriores para calcular el número de pedidos que se ha realizado cada uno de los clientes.
SELECT contacto, COUNT(contacto) AS numero_de_pedidos 
FROM listado_pedidos_clientes 
GROUP BY contacto;

-- 6.	Utilice las vistas que ha creado en los pasos anteriores para calcular el valor del pedido máximo y mínimo que ha realizado cada cliente.
SELECT contacto, MAX(total_pedido) AS max_pedido, MIN(total_pedido) AS min_pedido
FROM listado_pedidos_clientes
GROUP BY contacto;

-- 7.	Modifique el nombre de las vista listado_pagos_clientes y asígnele el nombre listado_de_pagos. 
-- Una vez que haya modificado el nombre de la vista ejecute una consulta utilizando el nuevo nombre de la vista para comprobar que sigue funcionando correctamente.
RENAME TABLE listado_pagos_clientes TO listado_de_pagos;
select * from listado_de_pagos;

-- 8.	Elimine las vistas que ha creado en los pasos anteriores.
DROP VIEW IF EXISTS listado_pedidos_clientes;
DROP VIEW IF EXISTS listado_de_pagos;