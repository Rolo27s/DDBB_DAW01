/* CONSULTAS II EMPLEADOS */
USE empleados;
/* Vision tabla a tabla */
SELECT * FROM departamento;
SELECT * FROM empleado;

/* ---------------------------------------------------------------- */

/* 1. Devuelve un listado con los empleados y los datos de los departamentos donde trabaja cada uno. */
SELECT * FROM departamento, empleado
WHERE departamento.codigo = empleado.codigo_departamento;

/* 2. Devuelve un listado con los empleados y los datos de los departamentos donde trabaja cada uno. 
Ordena el resultado, en primer lugar por el nombre del departamento (en orden alfabético) y en segundo lugar por los apellidos y el nombre de los empleados. */
SELECT * FROM departamento, empleado
WHERE departamento.codigo = empleado.codigo_departamento
ORDER BY departamento.nombre, empleado.apellido1, empleado.apellido2, empleado.nombre;

/* 3. Devuelve un listado con el código y el nombre del departamento, solamente de aquellos departamentos que tienen empleados. */
SELECT DISTINCT departamento.codigo, departamento.nombre FROM departamento, empleado
WHERE departamento.codigo = empleado.codigo_departamento;

/* 4. Devuelve un listado con el código, el nombre del departamento y el valor del presupuesto actual del que dispone, solamente de aquellos departamentos que tienen empleados. 
El valor del presupuesto actual lo puede calcular restando al valor del presupuesto inicial (columna presupuesto) el valor de los gastos que ha generado (columna gastos). */
SELECT DISTINCT departamento.codigo, departamento.nombre, (departamento.presupuesto - departamento.gastos) AS Presupuesto_Actual FROM departamento, empleado
WHERE departamento.codigo = empleado.codigo_departamento;

/* 5. Devuelve el nombre del departamento donde trabaja el empleado que tiene el nif 38382980M. */
SELECT departamento.nombre, empleado.nombre FROM departamento, empleado
WHERE departamento.codigo = empleado.codigo_departamento AND empleado.nif LIKE '38382980M';

/* 6. Devuelve el nombre del departamento donde trabaja el empleado Pepe Ruiz Santana. */ /* ¿Hay otra forma mas limpia de hacer lo mismo? */
SELECT departamento.nombre, empleado.nombre, empleado.apellido1, empleado.apellido2 FROM departamento, empleado
WHERE departamento.codigo = empleado.codigo_departamento AND empleado.nombre LIKE 'Pepe' AND empleado.apellido1 LIKE 'Ruiz' AND empleado.apellido2 LIKE 'Santana';

/* 7. Devuelve un listado con los datos de los empleados que trabajan en el departamento de I+D. Ordena el resultado alfabéticamente. */
SELECT e.codigo, e.nif, e.nombre, e.apellido1, e.apellido2, e.codigo_departamento FROM departamento, empleado e
WHERE departamento.codigo = e.codigo_departamento AND departamento.nombre LIKE 'I+D'
ORDER BY e.nombre, e.apellido1, e.apellido2;

/* 8. Devuelve un listado con los datos de los empleados que trabajan en el departamento de Sistemas, Contabilidad o I+D. Ordena el resultado alfabéticamente. */
SELECT e.codigo, e.nif, e.nombre, e.apellido1, e.apellido2, e.codigo_departamento, departamento.nombre FROM departamento, empleado e
WHERE departamento.codigo = e.codigo_departamento AND departamento.nombre IN('I+D', 'Contabilidad', 'Sistemas') 
ORDER BY e.nombre, e.apellido1, e.apellido2;

/* 9. Devuelve una lista con el nombre de los empleados que tienen los departamentos que no tienen un presupuesto entre 100000 y 200000 euros. */
SELECT e.codigo, e.nombre, departamento.nombre FROM departamento, empleado e
WHERE departamento.codigo = e.codigo_departamento AND departamento.presupuesto NOT BETWEEN 100000 AND 200000; 
/* Otra opcion de condicional para ver el presupuesto (departamento.presupuesto < 100000 OR departamento.presupuesto > 200000);*/
/* No muestra los departamentos que tienen menor presupuesto si estos no tienen empleados asignados */

/* 10. Devuelve un listado con el nombre de los departamentos donde existe algún empleado cuyo segundo apellido sea NULL. 
Tenga en cuenta que no debe mostrar nombres de departamentos que estén repetidos. */
SELECT e.codigo, e.nombre, e.apellido1, departamento.nombre FROM departamento, empleado e
WHERE departamento.codigo = e.codigo_departamento AND e.apellido2 IS NULL;

/* ------------------------------------------------------------- */

/* Utilizando la base de datos “Gestión de Empleados”, resuelva todas las consultas utilizando las cláusulas LEFT JOIN y RIGHT JOIN. */
/* 1. Devuelve un listado con todos los empleados junto con los datos de los departamentos donde trabajan. 
Este listado también debe incluir los empleados que no tienen ningún departamento asociado. */
SELECT * FROM departamento LEFT JOIN empleado
ON departamento.codigo = empleado.codigo_departamento
UNION
SELECT * FROM departamento RIGHT JOIN empleado
ON departamento.codigo = empleado.codigo_departamento;

/* 2. Devuelve un listado donde sólo aparezcan aquellos empleados que no tienen ningún departamento asociado. */ /*CORREGIR*/
SELECT * FROM departamento RIGHT JOIN empleado
ON departamento.codigo = empleado.codigo_departamento
ORDER BY departamento.nombre
LIMIT 2;

/* 3. Devuelve un listado donde sólo aparezcan aquellos departamentos que no tienen ningún empleado asociado. */ /*CORREGIR*/
SELECT * FROM departamento LEFT JOIN empleado
ON departamento.codigo = empleado.codigo_departamento
ORDER BY empleado.nombre
LIMIT 2;

/* 4. Devuelve un listado con todos los empleados junto con los datos de los departamentos donde trabajan. 
El listado debe incluir los empleados que no tienen ningún departamento asociado y los departamentos que no tienen ningún empleado asociado. 
Ordene el listado alfabéticamente por el nombre del departamento. */ /*CORREGIR*/
(SELECT * FROM departamento LEFT JOIN empleado
ON departamento.codigo = empleado.codigo_departamento)
UNION
(SELECT * FROM departamento RIGHT JOIN empleado
ON departamento.codigo = empleado.codigo_departamento)
ORDER BY departamento.nombre;

/* 5. Devuelve un listado con los empleados que no tienen ningún departamento asociado y los departamentos que no tienen ningún empleado asociado. 
Ordene el listado alfabéticamente por el nombre del departamento. */

