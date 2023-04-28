-- Realice las siguientes operaciones sobre la base de datos empleados.
select * from departamento;
select * from empleado;

-- 1.	Inserta un nuevo departamento indicando su código, nombre y presupuesto.
INSERT INTO departamento (codigo, nombre, presupuesto, gastos)
VALUES (8, 'Marketing', 200000, 0);

-- 2.	Inserta un nuevo departamento indicando su nombre y presupuesto.
INSERT INTO departamento (nombre, presupuesto) VALUES ('Compras', 80000);
-- Me salta un error porque no defino el campo gastos y no esta definido con un valor por defecto en caso de obviarlo

-- 3.	Inserta un nuevo departamento indicando su código, nombre, presupuesto y gastos.
INSERT INTO departamento (nombre, presupuesto, gastos) VALUES ('Compras', 80000, 70000);

-- 4.	Inserta un nuevo empleado asociado a uno de los nuevos departamentos. 
-- La sentencia de inserción debe incluir: código, nif, nombre, apellido1, apellido2 y codigo_departamento.
INSERT INTO empleado (codigo, nif, nombre, apellido1, apellido2, codigo_departamento)
VALUES (14, '94321987T', 'Laura', 'García', 'Fernández', 8);

-- 5.	Inserta un nuevo empleado asociado a uno de los nuevos departamentos. 
-- La sentencia de inserción debe incluir: nif, nombre, apellido1, apellido2 y codigo_departamento.
INSERT INTO empleado (nif, nombre, apellido1, apellido2, codigo_departamento)
VALUES ('12345678A', 'Juan', 'García', 'Pérez', 8);

-- 6.	Crea una nueva tabla con el nombre departamento_backup que tenga las mismas columnas que la tabla departamento. 
-- Una vez creada copia todos las filas de tabla departamento en departamento_backup.
CREATE TABLE departamento_backup LIKE departamento;
INSERT INTO departamento_backup SELECT * FROM departamento;

select * from departamento_backup;

-- 7.	Elimina el departamento Proyectos. ¿Es posible eliminarlo? Si no fuese posible, ¿qué cambios debería realizar para que fuese posible borrarlo?
-- Primero debemos eliminar todos los empleados asociados a él
DELETE FROM empleado WHERE codigo_departamento = 6;
DELETE FROM departamento WHERE codigo = 6;

-- 8.	Elimina el departamento Desarrollo. ¿Es posible eliminarlo? Si no fuese posible, ¿qué cambios debería realizar para que fuese posible borrarlo?
-- Elimino los empleados que estén asociados al departamento Desarrollo
DELETE FROM empleado WHERE codigo_departamento = 1;
DELETE FROM departamento WHERE codigo = 1;

-- 9.	Actualiza el código del departamento Recursos Humanos y asígnale el valor 30. ¿Es posible actualizarlo? Si no fuese posible, ¿qué cambios debería realizar para que fuese actualizarlo?
-- Como tengo empleados con el codigo actual de recursos humanos, primero tengo que actualizar esa informacion.
-- Una posible solucion concreta es pasar todos los empleados temporalmente al departamento 7 de publicidad, que estaba vacio y luego volverlo a pasar a RRHH con el nuevo codigo.
UPDATE empleado SET codigo_departamento = 7 WHERE codigo_departamento = 3;

-- Elimino la constraint de la foreign key
ALTER TABLE empleado DROP FOREIGN KEY empleado_ibfk_1;

-- Hago el cambio que queria
UPDATE departamento SET codigo = 30 WHERE nombre = 'Recursos Humanos';

-- vuelvo a agregar la constraint
ALTER TABLE empleado ADD CONSTRAINT empleado_ibfk_1 FOREIGN KEY (codigo_departamento) REFERENCES departamento (codigo);

-- Reasigno los trabajadores del departamento publicidad (que use de manera temporal por estar vacio) a RRHH
UPDATE empleado SET codigo_departamento = 30 where codigo_departamento = 7;

-- 10.	Actualiza el código del departamento Publicidad y asígnale el valor 40. ¿Es posible actualizarlo? Si no fuese posible, ¿qué cambios debería realizar para que fuese actualizarlo?
UPDATE departamento SET codigo = 40 WHERE nombre = 'Publicidad';
-- Si que puedo porque justo estaba vacio. En caso de no estarlo habría que hacer operaciones similares al ejercicio anterior.

-- 11.	Actualiza el presupuesto de los departamentos sumándole 50000 € al valor del presupuesto actual, solamente a aquellos departamentos que tienen un presupuesto menor que 20000 €.
UPDATE departamento SET presupuesto = presupuesto + 50000 WHERE presupuesto < 20000;
