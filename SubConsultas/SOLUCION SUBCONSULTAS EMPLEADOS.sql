-- SUBCONSULTAS
-- BBDD Gestión de Empleados

-- 1.	Devuelve un listado con todos los empleados que tiene el departamento de Sistemas. (Sin utilizar INNER JOIN).
select *
from empleado
where codigo_departamento = (select codigo from departamento where nombre = 'Sistemas');

-- 2.	Devuelve el nombre del departamento con mayor presupuesto y la cantidad que tiene asignada.
select nombre, presupuesto
from departamento
where presupuesto = (select max(presupuesto) from departamento);

-- 2.b Lo mismo pero con GROUP BY
SELECT nombre, presupuesto
FROM departamento
GROUP BY nombre, presupuesto
HAVING presupuesto = MAX(presupuesto)
ORDER BY 2 DESC
LIMIT 1;

-- 3.	Devuelve el nombre del departamento con menor presupuesto y la cantidad que tiene asignada.
select nombre, presupuesto
from departamento
where presupuesto = (select min(presupuesto) from departamento where presupuesto <> 0);


-- ALL y ANY en Gestión de Empleados

-- 4.Devuelve el nombre del departamento con mayor presupuesto y la cantidad que tiene asignada. Sin hacer uso de MAX, ORDER BY ni LIMIT.
select nombre, presupuesto 
from departamento d
where presupuesto > ALL (select presupuesto from departamento where codigo<>d.codigo);

-- 5.Devuelve el nombre del departamento con menor presupuesto y la cantidad que tiene asignada. Sin hacer uso de MIN, ORDER BY ni LIMIT.
select nombre, presupuesto 
from departamento d           /* Menor presupuesto distinto de 0  */
where presupuesto<>0 and presupuesto <= ALL (select presupuesto from departamento where presupuesto<> 0 and codigo<>d.codigo);

-- 6.Devuelve los nombres de los departamentos que tienen empleados asociados. (Utilizando ALL o ANY).
select nombre 
from departamento
where codigo = ANY (select codigo_departamento from empleado);

-- 7.Devuelve los nombres de los departamentos que no tienen empleados asociados. (Utilizando ALL o ANY).
select nombre 
from departamento        /* cuidado con los NULL */
where codigo <> All (select codigo_departamento from empleado where codigo_departamento is not null);


-- IN y NOT IN en Gestión de Empleados

-- 8.Devuelve los nombres de los departamentos que tienen empleados asociados. (Utilizando IN o NOT IN).
select nombre 
from departamento
where codigo IN (select codigo_departamento from empleado);

-- 9.Devuelve los nombres de los departamentos que no tienen empleados asociados. (Utilizando IN o NOT IN).
select nombre 
from departamento   /* cuidado con los NULL */
where codigo NOT IN (select codigo_departamento from empleado where codigo_departamento is not null);


-- gestión de empleados

-- 10 Devuelve los nombres de los departamentos que tienen empleados asociados. (Utilizando EXISTS o NOT EXISTS).
select nombre 
from departamento
where exists (select * from empleado where codigo_departamento=departamento.codigo);

-- 11 Devuelve los nombres de los departamentos que no tienen empleados asociados. (Utilizando EXISTS o NOT EXISTS).
select nombre 
from departamento
where  not exists (select * from empleado where codigo_departamento=departamento.codigo);