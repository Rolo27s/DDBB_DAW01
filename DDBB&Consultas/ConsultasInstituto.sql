/* 1. Devuelve los datos del alumno cuyo id es igual a 1: */
SELECT *
FROM instituto
WHERE id = 1;

/* 2. Devuelve los datos del alumno cuyo teléfono es igual a 692735409: */
SELECT *
FROM instituto
WHERE telefono = 692735409;


/* 3. Devuelve un listado de todos los alumnos que son repetidores: */
SELECT *
FROM instituto
WHERE repetidor = 'Si';

/* 4. Devuelve un listado de todos los alumnos que no son repetidores: */
SELECT *
FROM instituto
WHERE repetidor = 'No';

/* 5. Devuelve el listado de los alumnos que han nacido antes del 1 de enero de 1993: */
SELECT *
FROM instituto
WHERE fecha_nacimiento < '1993-01-01';

/* 6. Devuelve el listado de los alumnos que han nacido después del 1 de enero de 1994: */
SELECT *
FROM instituto
WHERE fecha_nacimiento > '1994-01-01';

/* 7.  Devuelve el listado de los alumnos que han nacido después del 1 de enero de 1994 y no son repetidores: */
SELECT *
FROM instituto
WHERE fecha_nacimiento > '1994-01-01'
AND repetidor = 'No';

/* 8. Devuelve el listado de todos los alumnos que nacieron en 1998: */
SELECT *
FROM instituto
WHERE YEAR(fecha_nacimiento) = 1998;

/* 9. Devuelve el listado de todos los alumnos que no nacieron en 1998: */
SELECT *
FROM instituto
WHERE YEAR(fecha_nacimiento) != 1998;

/* OPERADOR BETWEEN */
/* 1. Devuelve los datos de los alumnos que hayan nacido entre el 1 de enero de 1998 y el 31 de mayo de 1998: */
SELECT *
FROM instituto
WHERE fecha_nacimiento BETWEEN '1998-01-01' AND '1998-05-31';

/* Ejercicios con Operadores y funciones */
/* 1. Devuelve un listado con dos columnas, donde aparezca en la primera columna
el nombre de los alumnos y en la segunda, el nombre con todos los caracteres
invertidos.
*/
 SELECT nombre, REVERSE(nombre) AS nombre_invertido
FROM alumnos;

/* 2. Devuelve un listado con dos columnas, donde aparezca en la primera columna
el nombre y los apellidos de los alumnos y en la segunda, el nombre y los
apellidos con todos los caracteres invertidos.
*/
SELECT CONCAT(nombre, ' ', apellido) AS nombre_completo,
       REVERSE(CONCAT(nombre, ' ', apellido)) AS nombre_completo_invertido
FROM alumnos;

/* 3. Devuelve un listado con dos columnas, donde aparezca en la primera columna
el nombre y los apellidos de los alumnos en mayúscula y en la segunda, el
nombre y los apellidos con todos los caracteres invertidos en minúscula */
SELECT UPPER(CONCAT(nombre, ' ', apellido)) AS nombre_completo_mayuscula,
       LOWER(REVERSE(CONCAT(nombre, ' ', apellido))) AS nombre_completo_invertido_minuscula
FROM alumnos;

/* 4. Devuelve un listado con dos columnas, donde aparezca en la primera columna
el nombre y los apellidos de los alumnos y en la segunda, el número de
caracteres que tiene en total el nombre y los apellidos */
SELECT CONCAT(nombre, ' ', apellido) AS nombre_completo,
       LENGTH(CONCAT(nombre, ' ', apellido)) AS longitud_nombre_completo
FROM alumnos;

/* 5. Devuelve un listado con dos columnas, donde aparezca en la primera columna
el nombre y los dos apellidos de los alumnos. En la segunda columna se
mostrará una dirección de correo electrónico que vamos a calcular para cada
alumno. La dirección de correo estará formada por el nombre y el primer
apellido, separados por el carácter . y seguidos por el dominio @iescelia.org.
Tenga en cuenta que la dirección de correo electrónico debe estar en
minúscula. Utilice un alias apropiado para cada columna. */
SELECT CONCAT(nombre, ' ', apellido1, ' ', apellido2) AS nombre_completo,
       LOWER(CONCAT(nombre, '.', SUBSTRING(apellido1, 1, 1), '@iescelia.org')) AS correo_electronico
FROM alumnos;

/* 6. Devuelve un listado con tres columnas, donde aparezca en la primera columna
el nombre y los dos apellidos de los alumnos. En la segunda columna se
mostrará una dirección de correo electrónico que vamos a calcular para cada
alumno. La dirección de correo estará formada por el nombre y el primer
apellido, separados por el carácter . y seguidos por el dominio @iescelia.org.
Tenga en cuenta que la dirección de correo electrónico debe estar en
minúscula. La tercera columna será una contraseña que vamos a generar
formada por los caracteres invertidos del segundo apellido, seguidos de los
cuatro caracteres del año de la fecha de nacimiento. Utilice un alias apropiado
para cada columna. */
SELECT CONCAT(nombre, ' ', apellido1, ' ', apellido2) AS nombre_completo,
       LOWER(CONCAT(nombre, '.', SUBSTRING(apellido1, 1, 1), '@iescelia.org')) AS correo_electronico,
       CONCAT(REVERSE(apellido2), SUBSTRING(fecha_nacimiento, 1, 4)) AS contrasena
FROM alumnos;

/* Funciones de fecha y hora */
/* 1. Devuelva un listado con cuatro columnas, donde aparezca en la primera
columna la fecha de nacimiento completa de los alumnos, en la segunda
columna el día, en la tercera el mes y en la cuarta el año. Utilice las funciones
DAY, MONTH y YEAR. */
SELECT fecha_nacimiento AS fecha_completa,
       DAY(fecha_nacimiento) AS dia,
       MONTH(fecha_nacimiento) AS mes,
       YEAR(fecha_nacimiento) AS anio
FROM alumnos;

/* 2a. Devuelva un listado con tres columnas, donde aparezca en la primera columna
la fecha de nacimiento de los alumnos, en la segunda el nombre del día de la
semana de la fecha de nacimiento y en la tercera el nombre del mes de la fecha
de nacimiento. Utilice las funciones DAYNAME y MONTHNAME */
SELECT fecha_nacimiento, 
       DAYNAME(fecha_nacimiento) AS dia_semana, 
       MONTHNAME(fecha_nacimiento) AS nombre_mes
FROM alumnos;

/* 2b. Devuelva un listado con tres columnas, donde aparezca en la primera columna
la fecha de nacimiento de los alumnos, en la segunda el nombre del día de la
semana de la fecha de nacimiento y en la tercera el nombre del mes de la fecha
de nacimiento. Utilice la funcion DATE_FORMAT */
/*
	%W: devuelve el nombre del día de la semana
	%M: devuelve el nombre del mes.
*/
SELECT fecha_nacimiento, 
       DATE_FORMAT(fecha_nacimiento, '%W') AS dia_semana, 
       DATE_FORMAT(fecha_nacimiento, '%M') AS nombre_mes
FROM alumnos;

/* 3. Devuelva un listado con dos columnas, donde aparezca en la primera columna
la fecha de nacimiento de los alumnos y en la segunda columna el número de
días que han pasado desde la fecha actual hasta la fecha de nacimiento. Utilice
las funciones DATEDIFF y NOW. Consulte la documentación oficial de MySQL
para DATEDIFF */
SELECT birthdate, DATEDIFF(NOW(), birthdate) AS days_since_birth
FROM students;

/* 4. Devuelva un listado con dos columnas, donde aparezca en la primera columna
la fecha de nacimiento de los alumnos y en la segunda columna la edad de
cada alumno/a. 
Calcule la edad siguiento estos puntos:
* Calcule el numero de dias conociendo el dia actual y la fecha de nacimiento de los alumnos. Utilice las funciones DATEDIFF y NOW.
* Divida entre 365.25 el numero de dias obtenido en el punto anterior.
* Trunca las cifras decimales del numero obtenido en el punto anterior.
*/
SELECT birthdate, TRUNCATE(DATEDIFF(NOW(), birthdate) / 365.25, 0) AS age
FROM students;