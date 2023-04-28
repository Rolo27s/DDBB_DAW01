-- Realice las siguientes operaciones sobre la base de datos jardineria.
select * from cliente;
select * from detalle_pedido;
select * from empleado;
select * from gama_producto;
select * from oficina;
select * from pago;
select * from pedido;
select * from producto;

-- 1.	Inserta una nueva oficina en Almería.
INSERT INTO oficina (codigo_oficina, ciudad, pais, region, codigo_postal, telefono, linea_direccion1, linea_direccion2)
VALUES ('ALM-ES','Almería', 'España', 'La Alpujarra', '04470', '+34 950 51 47 87', 'Calle Real, 3', 'Calle Fuente del Barrio, 2');

-- 2.	Inserta un empleado para la oficina de Almería que sea representante de ventas.
INSERT INTO empleado (codigo_empleado, nombre, apellido1, apellido2, extension, email, codigo_oficina, codigo_jefe, puesto) 
VALUES (32, 'Juan', 'Pérez', 'Alcala', '2626', 'JuanPA@jardineria.es', 'ALM-ES', 2, 'Representante de Ventas');

-- 3.	Inserta un cliente que tenga como representante de ventas el empleado que hemos creado en el paso anterior.
INSERT INTO cliente (codigo_cliente, nombre_cliente, nombre_contacto, apellido_contacto, telefono, fax, linea_direccion1, linea_direccion2, ciudad, region, codigo_postal, codigo_empleado_rep_ventas, limite_credito)
VALUES (39, 'La Casa del Jardín', 'Sara', 'García', '+34 950 123 456', '+34 950 123 457', 'Calle Mayor 14', 'Bajo', 'Almería', 'Andalucía', '04001', 32, 5000.00);

-- 4.	Inserte un pedido para el cliente que acabamos de crear, que contenga al menos dos productos.
INSERT INTO pedido
VALUES (129, '2023-04-28', '2023-05-01', '2023-05-08', "Pendiente", "El nuevo cliente ha realizado su primer pedido", 39);
-- Al pedido le agrego dos productos en la tabla detalle_pedido;
INSERT INTO detalle_pedido
VALUES 	(129, "OR-179", 5, 6, 4),
		(129, "FR-67", 4, 70, 1);

-- 5.	Actualiza el código del cliente que hemos creado en el paso anterior y averigua si hubo cambios en las tablas relacionadas. ME SALE PERO CREO QUE DOY MUCHAS VUELTAS ¿NO HAY OTRA MANERA MAS FACIL?
UPDATE cliente SET codigo_cliente = 40 WHERE codigo_cliente = 39;

-- No puedo hacer ese cambio por la foreign key, asi que la actualizo y la configuro para que funcione en cascada
ALTER TABLE cliente DROP FOREIGN KEY cliente_ibfk_1;
ALTER TABLE cliente ADD CONSTRAINT `cliente_ibfk_1` FOREIGN KEY (`codigo_empleado_rep_ventas`) REFERENCES `empleado` (`codigo_empleado`) ON UPDATE CASCADE ON DELETE CASCADE;

-- Me doy cuenta que el problema era que realmente tenia que cambiar los registros de la tabla pedido para que el codigo de la tabla cliente sea 40 en vez de 39 y no caer en problemas de restricciones.
-- Conozco que el cliente 6 no ha realizado ningun pedido, asi que lo voy a usar como puente. Así los pedidos de mi cliente 39 será temporalmente los pedidos del 6
UPDATE pedido SET codigo_cliente = 6 WHERE codigo_cliente = 39;

-- Ahora si me permite hacer las clausulas porque el cliente 39 ahora mismo no tendría pedidos
UPDATE cliente SET codigo_cliente = 40 WHERE codigo_cliente = 39;

-- vuelvo a poner los pedidos en el cliente correcto
UPDATE pedido SET codigo_cliente = 40 WHERE codigo_cliente = 6;

-- Reviso como quedo la informacion
SELECT * FROM pedido WHERE codigo_cliente = 40;

-- 6.	Borra el cliente y averigua si hubo cambios en las tablas relacionadas.
-- Tengo que borrar primero los pedidos que tenga ese cliente
DELETE FROM detalle_pedido WHERE codigo_pedido = 129;
DELETE FROM pedido WHERE codigo_cliente = 40;
DELETE FROM cliente WHERE codigo_cliente = 40;
SELECT * FROM cliente;

-- Han habido cambios en las tablas relacionadas porque directamente los he hecho yo.
-- Entiendo que otra manera es ajustar el constraint de las tablas relacionadas con respuesta en cascada.

-- 7.	Elimina los clientes que no hayan realizado ningún pedido.
DELETE FROM cliente
WHERE NOT EXISTS (SELECT * FROM pedido WHERE pedido.codigo_cliente = cliente.codigo_cliente);
-- Compruebo que pase de 38 clientes a 19 clientes.

-- 8.	Incrementa en un 20% el precio de los productos que no tengan pedidos.
UPDATE producto
SET precio_venta = precio_venta * 1.2
WHERE codigo_producto NOT IN (SELECT DISTINCT codigo_producto FROM detalle_pedido);
-- ¿Lo lógico no sería hacer exactamente lo contrario? Es decir, rebajarlos de precio.

-- 9.	Borra los pagos del cliente con menor límite de crédito.
-- Quien es el cliente con el menor limite de credito?
SELECT codigo_cliente FROM cliente
ORDER BY limite_credito ASC
LIMIT 1;

-- solucion
DELETE FROM pago WHERE codigo_cliente = (SELECT codigo_cliente FROM cliente ORDER BY limite_credito ASC LIMIT 1);

-- 10.	Establece a 0 el límite de crédito del cliente que menos unidades pedidas tenga del producto OR-179.
UPDATE cliente 
SET limite_credito = 0 
WHERE codigo_cliente = (
    SELECT codigo_cliente 
    FROM pedido 
    WHERE codigo_pedido = (
		SELECT codigo_pedido FROM detalle_pedido 
		WHERE codigo_producto = 'OR-179' 
		ORDER BY cantidad
		LIMIT 1
    )
);
SELECT * FROM cliente;

-- codigo del cliente buscado
SELECT codigo_cliente 
    FROM pedido 
    WHERE codigo_pedido = (
		SELECT codigo_pedido FROM detalle_pedido 
		WHERE codigo_producto = 'OR-179' 
		ORDER BY cantidad
		LIMIT 1
    );
SELECT * FROM pedido;

-- codigo del pedido con menor cantidad del producto OR-179    
SELECT codigo_pedido FROM detalle_pedido 
WHERE codigo_producto = 'OR-179' 
ORDER BY cantidad
LIMIT 1;
;
SELECT * FROM detalle_pedido;
-- El codigo pedido es 56. cod cliente es 13

-- 11.	Modifica la tabla detalle_pedido para incorporar un campo numérico llamado total_linea y actualiza todos sus registros para calcular su valor con la fórmula:
-- total_linea = precio_unidad*cantidad * (1 + (iva/100));
ALTER TABLE detalle_pedido ADD total_linea DECIMAL(10,2);

UPDATE detalle_pedido
SET total_linea = precio_unidad*cantidad*(1+(21/100));

-- 12.	Borra el cliente que menor límite de crédito tenga. ¿Es posible borrarlo solo con una consulta? ¿Por qué?
DELETE FROM cliente WHERE limite_credito = 0;
-- No es posible eliminarlo solo con una consulta porque tiene registros relacionados en otras tablas. En este caso en la tabla pago.
-- Es una restriccion de la clave foranea

-- 13.	Inserta una oficina con sede en Granada y tres empleados que sean representantes de ventas.
INSERT INTO oficina
VALUES ('GRA-ES', 'Granada', 'España', 'Aguila', '18002', '+34 958 44 55 66', 'Calle de los rios, 4', 'Avda. Fuenlabrada, 18');

INSERT INTO empleado
VALUES 
		(33, 'Adolfo', 'Perez', 'Serrano', 2627, 'AdolfoPS@jardineria.es', 'GRA-ES', 2, 'Representante de Ventas'), 
		(34, 'Adela', 'Ginebra', 'marquez', 2627, 'AdelaGM@jardineria.es', 'GRA-ES', 2, 'Representante de Ventas'), 
        (35, 'Marta', 'Sanchez', 'Sanchez', 2627, 'MartaSS@jardineria.es', 'GRA-ES', 2, 'Representante de Ventas');

-- 14.	Inserta tres clientes que tengan como representantes de ventas los empleados que hemos creado en el paso anterior.
INSERT INTO cliente
VALUES
	(39, 'Compañía de Jardinería Verde y más S.L.', 'Laura', 'García', '914787413', '914787411', 'C/ Gran Vía, 7', 'Alcorcón', 'Madrid', 'Madrid', 'Spain', '28013', 33, 35000.00),
    (40, 'TecnoSoft SA', 'Juan', 'Pérez', '987654321', '987654322', 'C/ Pintor Sorolla, 12', 'Valencia', 'Valencia', 'Valencia', 'Spain', '46013', 34, 350000.00),
    (41, 'Viajes Globales SL', 'María', 'García', '555666777', '555666778', 'Av. del Mediterráneo, 25', 'Málaga', 'Málaga', 'Andalucía', 'Spain', '29002', 35, 90000.00);

-- 15.	Borra uno de los clientes y comprueba si hubo cambios en las tablas relacionadas.
DELETE FROM cliente WHERE codigo_cliente = 41;

SELECT * FROM cliente;
-- Si no hubo cambios, modifica las tablas necesarias estableciendo la clave foránea con la cláusula ON DELETE CASCADE.
-- En este caso borre el cliente con codigo_cliente = 41 que lo acababa de generar y se pudo hacer sin problemas.
-- En caso de tener problemas del estilo constraint por foreign key debemos eliminar la constraint y generarla nuevamente con la cláusula ON DELETE CASCADE ON UPDATE CASCADE
