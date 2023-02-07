/*Universidad*/

/*1*/
SELECT apellido1, apellido2, nombre FROM persona
WHERE tipo LIKE "alumno"
ORDER BY apellido1, apellido2, nombre;

/*2*/
SELECT apellido1, apellido2, nombre FROM persona
WHERE telefono IS NULL AND tipo LIKE "alumno";

/*3*/
SELECT * FROM persona
WHERE fecha_nacimiento >= '1999-01-01' AND fecha_nacimiento <= '1999-12-31' AND tipo LIKE "alumno";

/*4*/
SELECT * FROM persona
WHERE telefono IS NULL AND nif LIKE "%K" AND tipo LIKE "profesor";

/*5*/
SELECT * FROM asignatura
WHERE cuatrimestre = 1 AND curso = 3 AND id_grado = 7;

/*Universidad*/
/*1*/
SELECT * FROM pedido
ORDER BY fecha DESC;

/*2*/
SELECT * FROM pedido
ORDER BY total DESC
limit 3;

/*3*/
SELECT DISTINCT id_cliente FROM pedido;

/*4*/
SELECT * FROM pedido
WHERE fecha >= "2017-01-01" AND fecha >= "2017-12-31" AND total > 500;

/*5*/
SELECT nombre, apellido1, apellido2 FROM comercial
WHERE comisión >= 0.05 AND comisión <= 0.11;

/*6*/
SELECT comisión FROM comercial
ORDER BY comisión DESC
limit 1;

/*7*/
SELECT id, nombre, apellido1 FROM cliente
WHERE apellido2 IS NOT NULL
ORDER BY apellido1, nombre;

/*8*/
SELECT nombre FROM cliente
WHERE nombre LIKE "a%n" OR nombre LIKE "p%" 
ORDER BY nombre;

/*9*/
SELECT nombre FROM cliente
WHERE nombre NOT LIKE "a%"
ORDER BY nombre;

/*10*/
SELECT nombre FROM comercial
WHERE nombre LIKE "%el" OR nombre LIKE "%o"
ORDER BY nombre;