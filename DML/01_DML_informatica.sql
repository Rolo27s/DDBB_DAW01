-- INSERT, UPDATE y DELETE sobre la BD Tienda de informática
-- Realice las siguientes operaciones sobre la base de datos tienda.
select * from fabricante;
select * from producto;
select * from fabricante_productos;

-- 1.	Inserta un nuevo fabricante indicando su código y su nombre.
INSERT INTO fabricante (codigo, nombre) VALUES (10, 'Dell');

-- 2.	Inserta un nuevo fabricante indicando solamente su nombre.
INSERT INTO fabricante (nombre) VALUES ('Apple');

-- 3.	Inserta un nuevo producto asociado a uno de los nuevos fabricantes. 
-- La sentencia de inserción debe incluir: código, nombre, precio y código_fabricante.
INSERT INTO producto (codigo, nombre, precio, codigo_fabricante) 
VALUES (12, 'Macbook Pro', 1499.99, 10);

-- 4.	Inserta un nuevo producto asociado a uno de los nuevos fabricantes. La sentencia de inserción debe incluir: nombre, precio y código_fabricante.
INSERT INTO producto (nombre, precio, codigo_fabricante) 
VALUES ('iPad', 499.99, 11);

-- 5.	Crea una nueva tabla con el nombre fabricante_productos que tenga las siguientes columnas: 
-- nombre_fabricante, nombre_producto y precio. Una vez creada la tabla inserta todos los registros de la 
-- base de datos tienda en esta tabla haciendo uso de única operación de inserción.
CREATE TABLE fabricante_productos (
    nombre_fabricante VARCHAR(100) NOT NULL,
    nombre_producto VARCHAR(100) NOT NULL,
    precio DOUBLE NOT NULL
);

INSERT INTO fabricante_productos (nombre_fabricante, nombre_producto, precio)
SELECT f.nombre, p.nombre, p.precio FROM fabricante f
JOIN producto p ON f.codigo = p.codigo_fabricante;

-- 6.	Elimina el fabricante Asus. ¿Es posible eliminarlo? Si no fuese posible, 
-- ¿qué cambios debería realizar para que fuese posible borrarlo?
-- Respuesta: No es posible eliminar el fabricante "Asus" mientras existan productos asociados a él en la tabla "producto"
DELETE FROM fabricante WHERE nombre = 'Asus';

-- Para poder eliminar el fabricante "Asus" tendríamos que borrar primero todos los productos asociados a él:
DELETE FROM producto WHERE codigo_fabricante = (SELECT codigo FROM fabricante WHERE nombre = 'Asus');

-- Una vez eliminado todos los productos de asus, si podemos eliminarlo. RECORDAR deshabilitar el modo seguro en Edit/Preferences/SQLEditor y deseleccionar la ultima opcion
DELETE FROM fabricante WHERE nombre = 'Asus';

-- Tambien es posible modificar la constraint para hacer mas directo el proceso de edicion de este tipo
ALTER TABLE producto DROP FOREIGN KEY producto_ibfk_1;
ALTER TABLE producto ADD FOREIGN KEY (codigo_fabricante) REFERENCES fabricante(codigo) ON DELETE CASCADE ON UPDATE CASCADE;

-- 7.	Elimina el fabricante Xiaomi. ¿Es posible eliminarlo? Si no fuese posible, ¿qué cambios debería realizar para que fuese posible borrarlo?
-- Lo puedo eliminar porque ya he ejecutado la modificacion de la foreign key que trabaje en cascada.
-- En caso de no haberlo hecho tendría que hacer las mismas comprobaciones que en el caso anterior.
DELETE FROM fabricante WHERE codigo = 9;

-- 8.	Actualiza el código del fabricante Lenovo y asígnale el valor 20. ¿Es posible actualizarlo? Si no fuese posible, ¿qué cambios debería realizar para que fuese actualizarlo?
UPDATE fabricante SET codigo = 20 WHERE nombre = 'Lenovo';
-- En este caso si nos deja actualizarlo porque el id 20 estaba libre y no tenia productos asociados. En caso de ya estar ocupado nos mostrará un error. Para que funcionase debería de dejar libre esa id haciendo update.

-- 9.	Actualiza el código del fabricante Huawei y asígnale el valor 30. ¿Es posible actualizarlo? Si no fuese posible, ¿qué cambios debería realizar para que fuese actualizarlo?
/* 
No es posible actualizar el código del fabricante Huawei a 30, 
ya que existen productos en la tabla producto que tienen asignado el código del fabricante Huawei como llave foránea en la columna codigo_fabricante. 
Si se intenta actualizar el código del fabricante Huawei a 30, se violaría la restricción de integridad referencial.

Primero actualizamos el codigo de fabricante de la tabla "producto"
*/
UPDATE producto SET codigo_fabricante = 30 WHERE codigo_fabricante = 8;

-- Una vez actualizamos los productos ya podemos actualizar el fabricante
UPDATE fabricante SET codigo = 30 WHERE nombre = 'Huawei';

-- 10.	Actualiza el precio de todos los productos sumándole 5 € al precio actual.
UPDATE producto SET precio = ROUND(precio + 5, 2);

-- 11.	Elimina todas las impresoras que tienen un precio menor de 200 €.
DELETE FROM producto WHERE nombre LIKE '%Impresora%' AND precio < 200;
