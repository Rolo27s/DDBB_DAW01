/* Entendiendo la base de datos tabla a tabla */
SELECT * FROM persona;
SELECT * FROM alumno_se_matricula_asignatura;
SELECT * FROM asignatura;
SELECT * FROM curso_escolar;
SELECT * FROM grado;
SELECT * FROM departamento;
SELECT * FROM profesor;

-- 1. Devuelve un listado con los datos de todas las alumnas que se han matriculado alguna vez en el Grado en Ingeniería Informática (Plan 2015).
SELECT * FROM persona, grado WHERE persona.sexo LIKE 'M' AND grado.nombre LIKE 'Grado en Ingeniería Informática (Plan 2015)';

-- 2. Devuelve un listado con todas las asignaturas ofertadas en el Grado en Ingeniería Informática (Plan 2015).
SELECT * FROM asignatura WHERE id_grado = 4;

-- 3. Devuelve un listado de los profesores junto con el nombre del departamento al que están vinculados. 
-- El listado debe devolver cuatro columnas, primer apellido, segundo apellido, nombre y nombre del departamento. 
-- El resultado estará ordenado alfabéticamente de menor a mayor por los apellidos y el nombre.
SELECT persona.apellido1, persona.apellido2, persona.nombre, departamento.nombre AS nombre_departamento
FROM persona, profesor, departamento
WHERE persona.id = profesor.id_profesor AND profesor.id_departamento = departamento.id
AND persona.tipo LIKE 'profesor'
ORDER BY persona.apellido1, persona.apellido2, persona.nombre;

-- 4. Devuelve un listado con el nombre de las asignaturas, año de inicio y año de fin del curso escolar del alumno con nif 26902806M.
SELECT asignatura.nombre, curso_escolar.anyo_inicio, curso_escolar.anyo_fin 
FROM persona, asignatura, curso_escolar, alumno_se_matricula_asignatura
WHERE persona.id = alumno_se_matricula_asignatura.id_alumno 
AND alumno_se_matricula_asignatura.id_curso_escolar = curso_escolar.id 
AND alumno_se_matricula_asignatura.id_asignatura = asignatura.id
AND persona.nif LIKE '26902806M';

-- 5. Devuelve un listado con el nombre de todos los departamentos que tienen profesores que imparten alguna asignatura en el Grado en Ingeniería Informática (Plan 2015).
SELECT DISTINCT departamento.nombre FROM departamento, asignatura, profesor
WHERE asignatura.id_profesor = profesor.id_profesor AND profesor.id_departamento = departamento.id
AND asignatura.id_grado = 4;

-- 6. Devuelve un listado con todos los alumnos que se han matriculado en alguna asignatura durante el curso escolar 2018/2019.
SELECT DISTINCT persona.nombre, persona.apellido1, persona.apellido2 
FROM persona, asignatura, curso_escolar, alumno_se_matricula_asignatura
WHERE persona.id = alumno_se_matricula_asignatura.id_alumno 
AND alumno_se_matricula_asignatura.id_curso_escolar = curso_escolar.id 
AND alumno_se_matricula_asignatura.id_asignatura = asignatura.id
AND curso_escolar.id = 5;

-- Resuelva todas las consultas utilizando las cláusulas LEFT JOIN y RIGHT JOIN.

-- 1. Devuelve un listado con los nombres de todos los profesores y los departamentos que tienen vinculados. 
-- El listado también debe mostrar aquellos profesores que no tienen ningún departamento asociado. 
-- El listado debe devolver cuatro columnas, nombre del departamento, primer apellido, segundo apellido y nombre del profesor. 
-- El resultado estará ordenado alfabéticamente de menor a mayor por el nombre del departamento, apellidos y el nombre.
-- LEFT JOIN
SELECT persona.apellido1, persona.apellido2, persona.nombre, departamento.nombre
FROM persona
LEFT JOIN profesor ON persona.id = profesor.id_profesor
LEFT JOIN departamento ON profesor.id_departamento = departamento.id
WHERE persona.tipo LIKE 'profesor'
ORDER BY persona.apellido1, persona.apellido2, persona.nombre;

-- RIGHT JOIN
SELECT persona.apellido1, persona.apellido2, persona.nombre, departamento.nombre
FROM departamento
RIGHT JOIN profesor ON departamento.id = profesor.id_departamento
RIGHT JOIN persona ON profesor.id_profesor = persona.id
WHERE persona.tipo LIKE 'profesor'
ORDER BY persona.apellido1, persona.apellido2, persona.nombre;

-- 2. Devuelve un listado con los profesores que no están asociados a un departamento.
-- LEFT JOIN
SELECT persona.apellido1, persona.apellido2, persona.nombre, departamento.nombre
FROM persona
LEFT JOIN profesor ON persona.id = profesor.id_profesor
LEFT JOIN departamento ON profesor.id_departamento = departamento.id
WHERE persona.tipo LIKE 'profesor' AND profesor.id_departamento IS NULL
ORDER BY persona.apellido1, persona.apellido2, persona.nombre;

-- RIGHT JOIN
SELECT persona.apellido1, persona.apellido2, persona.nombre, departamento.nombre
FROM departamento
RIGHT JOIN profesor ON departamento.id = profesor.id_departamento
RIGHT JOIN persona ON profesor.id_profesor = persona.id
WHERE persona.tipo LIKE 'profesor' AND profesor.id_departamento IS NULL
ORDER BY persona.apellido1, persona.apellido2, persona.nombre;

-- 3. Devuelve un listado con los departamentos que no tienen profesores asociados.
-- LEFT JOIN
SELECT DISTINCT departamento.nombre
FROM departamento
LEFT JOIN profesor ON departamento.id = profesor.id_departamento
WHERE profesor.id_departamento IS NULL;

-- RIGHT JOIN
SELECT DISTINCT departamento.nombre
FROM profesor
RIGHT JOIN departamento ON departamento.id = profesor.id_departamento
WHERE profesor.id_departamento IS NULL;

-- 4. Devuelve un listado con los profesores que no imparten ninguna asignatura.
-- LEFT JOIN
SELECT persona.apellido1, persona.apellido2, persona.nombre
FROM persona
LEFT JOIN profesor ON persona.id = profesor.id_profesor
LEFT JOIN asignatura ON profesor.id_profesor = asignatura.id_profesor
WHERE persona.tipo LIKE 'profesor' AND asignatura.id_profesor IS NULL;

-- RIGHT JOIN
SELECT persona.apellido1, persona.apellido2, persona.nombre
FROM asignatura
RIGHT JOIN profesor ON asignatura.id_profesor = profesor.id_profesor
RIGHT JOIN persona ON profesor.id_profesor = persona.id
WHERE persona.tipo LIKE 'profesor' AND asignatura.id_profesor IS NULL;

-- 5. Devuelve un listado con las asignaturas que no tienen un profesor asignado.
-- LEFT JOIN
SELECT nombre 
FROM asignatura 
LEFT JOIN profesor ON asignatura.id_profesor = profesor.id_profesor 
WHERE profesor.id_profesor IS NULL;

-- RIGHT JOIN
SELECT nombre 
FROM profesor 
RIGHT JOIN asignatura ON profesor.id_profesor = asignatura.id_profesor 
WHERE asignatura.id_profesor IS NULL;
	-- 62/83, es decir un 75% de las asignaturas no tienen profesores asignados

-- 6. Devuelve un listado con todos los departamentos que no han impartido asignaturas en ningún curso escolar.
-- LEFT JOIN
SELECT DISTINCT d.*
FROM departamento d
LEFT JOIN profesor p ON d.id = p.id_departamento
LEFT JOIN asignatura a ON p.id_profesor = a.id_profesor
WHERE a.id_profesor IS NULL;

-- RIGHT JOIN
SELECT DISTINCT d.*
FROM profesor p
RIGHT JOIN departamento d ON p.id_departamento = d.id
LEFT JOIN asignatura a ON p.id_profesor = a.id_profesor
WHERE a.id_profesor IS NULL;