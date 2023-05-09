-- 04_DML_transacciones
-- Ejercicios de Transacciones
-- 1. Realiza una transacción que elimine todas los empleados que no tienen un departamento asociado (BBDD Empleados)
Select * from empleado;

START TRANSACTION;
DELETE FROM empleado WHERE codigo_departamento IS NULL;
-- Si quisiera deshacer los cambios, antes del commit, ejecutar el Rollback
-- ROLLBACK;
COMMIT;

-- 2. Modifica la tabla detalle_pedido para insertar un campo numérico llamado iva. Mediante una transacción, establece el valor de ese campo a 18 para aquellos registros cuyo pedido tenga fecha a partir de Enero de 2009. 
-- A continuación actualiza el resto de pedidos estableciendo el iva al 21. (BBDD Jardinería)
select * from detalle_pedido;
select * from pedido;

START TRANSACTION;
-- Agrego la columna de iva (inicializan a null) Numeric 4,2 es que voy a tener 4 digitos en total, de los cuales 2 van a ser decimales.
ALTER TABLE detalle_pedido ADD COLUMN iva NUMERIC(4,2);

-- Relleno con el valor 18 a partir de Enero de 2009. Necesito vincular tablas para saber las fechas.
UPDATE detalle_pedido dp
INNER JOIN pedido p ON dp.codigo_pedido = p.codigo_pedido
SET dp.iva = 18.00
WHERE p.fecha_pedido >= '2009-01-01';

-- Siguen quedando algunos nulls que rellenare con 21
UPDATE detalle_pedido SET iva = 21.00 WHERE iva IS NULL;

COMMIT;

-- 3. Realiza una transacción que inserte un pedido para cada uno de los clientes que creaste en el ejercicio 14 del tema anterior (ejercicio 3 Insert, Update y Delete). Cada pedido debe incluir dos productos. (BBDD Jardinería)
select * from cliente;
-- Los clientes que se crearon y aun vemos son los de codigo_cliente 39 y 40. Habia un 41 pero se borro en el punto 15, asi que ya no esta.
select * from pedido;
select * from detalle_pedido;

-- Veo que el ultimo pedido es con codigo_pedido 128, asi que el siguiente que cree será con codigo_pedido 129
START TRANSACTION;
INSERT INTO pedido VALUES (129, '2023-04-28', '2023-05-06', '2023-05-10', "Pendiente", "El nuevo cliente ha realizado su primer pedido", 39);

-- Al pedido le agrego dos productos en la tabla detalle_pedido. Por seguir la lógica anterior, al ser un pedido hecho a partir de Enero de 2009, marcaré el iva como un 18
INSERT INTO detalle_pedido
VALUES 	(129, "OR-179", 5, 6, 4, cantidad*precio_unidad + cantidad*precio_unidad*18/100, 18),
		(129, "FR-67", 4, 70, 1, cantidad*precio_unidad + cantidad*precio_unidad*18/100, 18);
-- Me surgió un problema y tuve que usar rollback. Trate de hacer esto: (129, "FR-67", 4, 70, 1, cantidad*precio_unidad + cantidad*precio_unidad*iva/100, 18);
-- Me devolvía null, porque iva aun no se había introducido.
-- ROLLBACK;
COMMIT;

START TRANSACTION;
INSERT INTO pedido VALUES (130, '2023-05-04', '2023-05-16', null, "Pendiente", "El otro nuevo cliente ha realizado su primer pedido", 40);

-- Al pedido le agrego dos productos en la tabla detalle_pedido. Por seguir la lógica anterior, al ser un pedido hecho a partir de Enero de 2009, marcaré el iva como un 18
INSERT INTO detalle_pedido
VALUES 	(130, "OR-247", 1, 462, 4, cantidad*precio_unidad + cantidad*precio_unidad*18/100, 18),
		(130, "OR-222", 6, 59, 1, cantidad*precio_unidad + cantidad*precio_unidad*18/100, 18);
COMMIT;

-- 4. Realiza una transacción que realice los pagos de los pedidos que han realizado los clientes del ejercicio anterior. (BBDD Jardinería)
select * from pago;
select * from cliente;

-- Aqui tengo el total a pagar de cada uno de los pedidos. El 129 es del cliente 39 y el 130 es del cliente 40.
select sum(total_linea) from detalle_pedido where codigo_pedido = 129;
select sum(total_linea) from detalle_pedido where codigo_pedido = 130;

-- Pago del cliente nuevo 1
START TRANSACTION;
INSERT INTO pago
VALUES (39, "PayPal", 'ak-std-000040', DATE_FORMAT(NOW(), '%Y-%m-%d'), (select sum(total_linea) from detalle_pedido where codigo_pedido = 129));

-- voy a suponer que, en la tabla cliente, el ultimo campo (limite_credito) es un fondo que tienen los clientes depositados en nuestras cuentas, por lo que voy a actualizar esa información
UPDATE cliente
INNER JOIN pago ON cliente.codigo_cliente = pago.codigo_cliente
SET cliente.limite_credito = cliente.limite_credito - pago.total 
WHERE cliente.codigo_cliente = 39;
COMMIT;

-- Pago del cliente nuevo 2
START TRANSACTION;
INSERT INTO pago
VALUES (40, "PayPal", 'ak-std-000045', DATE_FORMAT(NOW(), '%Y-%m-%d'), (select sum(total_linea) from detalle_pedido where codigo_pedido = 130));

-- voy a suponer que, en la tabla cliente, el ultimo campo (limite_credito) es un fondo que tienen los clientes depositados en nuestras cuentas, por lo que voy a actualizar esa información
UPDATE cliente
INNER JOIN pago ON cliente.codigo_cliente = pago.codigo_cliente
SET cliente.limite_credito = cliente.limite_credito - pago.total 
WHERE cliente.codigo_cliente = 40;
COMMIT;

-- 5. Considera que tenemos una tabla donde almacenamos información sobre cuentas bancarias definida de la siguiente manera:
CREATE TABLE cuentas (
id INTEGER UNSIGNED PRIMARY KEY,
saldo DECIMAL(11,2) CHECK (saldo >= 0));

select * from cuentas;
-- Suponga que queremos realizar una transferencia de dinero entre dos cuentas bancarias con la siguiente transacción:
START TRANSACTION;
UPDATE cuentas SET saldo = saldo - 100 WHERE id = 20;
UPDATE cuentas SET saldo = saldo + 100 WHERE id = 30;
COMMIT;

-- ● ¿Qué ocurriría si el sistema falla o si se pierde la conexión entre el cliente y el servidor después de realizar la primera sentencia UPDATE?
	-- Que el dinero se sacaría de la cuenta con id 20 pero nunca llegaría a la cuenta con id 30, por lo que la transferencia sería erronea y quedarían 100 perdidos.
    -- Lo lógico sería hacer un rollback en ese caso para no cometer ese error y tratar de ejecutar los dos updates siempre, antes de llegar al commit.
    
-- ● ¿Qué ocurriría si no existiese alguna de las dos cuentas (id = 20 y id = 30)?
	-- Que no se podría hacer la transferencia porque falta o un emisor o un receptor. En este caso MySQL detectaría el error al faltarle o una Primary Key o una Foreign Key y volvería al punto inicial.

-- ● ¿Qué ocurriría en el caso de que la primera sentencia UPDATE falle porque hay menos de 100 € en la cuenta y no se cumpla la restricción del CHECK establecida en la tabla?
	-- Cuando se trate de hacer una sentencia que viola un check, devolverá un error y no se podrá hacer esa consulta. Lo detecta MySQL y vuelve al punto inicial. En este caso al START TRANSACTION.