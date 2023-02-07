/*1*/
SELECT apellido1 FROM empleado;

/*2*/
SELECT DISTINCT apellido1 FROM empleado;

/*3*/
SELECT * FROM empleado;

/*4*/
SELECT nombre, apellido1, apellido2 FROM empleado;

/*5*/
SELECT codigo_departamento FROM empleado;

/*6*/
SELECT DISTINCT codigo_departamento FROM empleado;

/*7*/
SELECT concat_ws(" ", nombre, apellido1, apellido2) FROM empleado;

/*8*/
SELECT upper( concat_ws(" ", nombre, apellido1, apellido2)) FROM empleado;

/*9*/
SELECT lower( concat_ws(" ", nombre, apellido1, apellido2)) FROM empleado;

/*10*/
SELECT codigo, left(nif, 8), right(nif, 1)  FROM empleado;

/*11*/
SELECT nombre, abs(presupuesto-gastos) AS beneficios FROM departamento;

/*12*/
SELECT nombre, presupuesto FROM departamento
ORDER BY presupuesto ASC;

/*13*/
SELECT nombre FROM departamento
ORDER BY nombre ASC;

/*14*/
SELECT nombre FROM departamento
ORDER BY nombre DESC;

/*15*/
SELECT nombre, apellido1, apellido2 FROM empleado
ORDER BY apellido1, apellido2, nombre;

/*16*/
SELECT nombre, presupuesto FROM departamento
ORDER BY presupuesto DESC
LIMIT 3;

/*17*/
SELECT nombre, presupuesto FROM departamento
ORDER BY presupuesto ASC
LIMIT 3;

/*18*/
SELECT nombre, gastos FROM departamento
ORDER BY gastos DESC
LIMIT 3;

/*19*/
SELECT nombre, gastos FROM departamento
ORDER BY gastos ASC
LIMIT 3;

/*20*/
SELECT * FROM empleado
LIMIT 2, 5;

/*21*/
SELECT nombre, presupuesto FROM departamento
WHERE presupuesto >=150000;

/*22*/
SELECT nombre, gastos FROM departamento
WHERE gastos < 5000;

/*23*/
SELECT nombre, presupuesto FROM departamento
WHERE presupuesto >= 100000 and presupuesto <= 200000;

/*24*/
SELECT nombre, presupuesto FROM departamento
WHERE presupuesto < 100000 OR presupuesto > 200000;

/*25*/
SELECT nombre, presupuesto FROM departamento
WHERE presupuesto BETWEEN 100000 and 200000;

/*26*/
SELECT nombre, presupuesto FROM departamento
WHERE NOT presupuesto BETWEEN 100000 and 200000;

/*27*/
SELECT nombre, gastos presupuesto FROM departamento
WHERE gastos > presupuesto;

/*28*/
SELECT nombre, gastos presupuesto FROM departamento
WHERE gastos < presupuesto;

/*29*/
SELECT nombre, gastos presupuesto FROM departamento
WHERE gastos = presupuesto;

/*30*/
SELECT * FROM empleado
WHERE apellido2 IS NULL;

/*31*/
SELECT * FROM empleado
WHERE apellido2 IS NOT NULL;

/*32*/
SELECT * FROM empleado
WHERE apellido2 LIKE "lopez";

/*33*/
SELECT * FROM empleado
WHERE apellido2 LIKE "diaz" OR apellido2 LIKE "moreno";

/*34*/
SELECT * FROM empleado
WHERE apellido2 IN  ("diaz","moreno");

/*35*/
SELECT nombre, apellido1, apellido2, nif FROM empleado
WHERE codigo_departamento = 3;

/*36*/
SELECT nombre, apellido1, apellido2, nif FROM empleado
WHERE codigo_departamento IN (2, 4, 5);