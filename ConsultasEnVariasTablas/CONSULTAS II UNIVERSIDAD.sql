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
SELECT persona.apellido1, persona.apellido2, persona.nombre, departamento.nombre 
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
SELECT persona.apellido1, persona.apellido2, persona.nombre, departamento.nombre
FROM persona
LEFT JOIN profesor ON persona.id = profesor.id_profesor
LEFT JOIN departamento ON profesor.id_departamento = departamento.id
WHERE persona.tipo LIKE 'profesor'
ORDER BY persona.apellido1, persona.apellido2, persona.nombre;
	-- Se uso como tabla principal → persona

-- 2. Devuelve un listado con los profesores que no están asociados a un departamento.
SELECT persona.apellido1, persona.apellido2, persona.nombre, departamento.nombre
FROM persona
LEFT JOIN profesor ON persona.id = profesor.id_profesor
LEFT JOIN departamento ON profesor.id_departamento = departamento.id
WHERE persona.tipo LIKE 'profesor' AND profesor.id_departamento IS NULL;
	-- En esta consulta no se devolvera nada porque en este caso todos los profesores estan asociados a un departamento.

-- 3. Devuelve un listado con los departamentos que no tienen profesores asociados.
/* REPASAR. NO FUNCIONA. DEBERIA MOSTRAR 7, 8 y 9, ES DECIR, FILOLOGÍA, DERECHO Y BIOLOGÍA Y GEOLOGÍA */
SELECT DISTINCT departamento.nombre
FROM departamento
RIGHT JOIN profesor ON departamento.id = profesor.id_departamento
RIGHT JOIN persona ON persona.id = profesor.id_profesor
WHERE departamento.id != profesor.id_departamento;

-- 4. Devuelve un listado con los profesores que no imparten ninguna asignatura.
SELECT persona.apellido1, persona.apellido2, persona.nombre
FROM persona
LEFT JOIN profesor ON persona.id = profesor.id_profesor
LEFT JOIN asignatura ON profesor.id_profesor = asignatura.id_profesor
WHERE persona.tipo LIKE 'profesor' AND asignatura.id_profesor IS NULL;
	-- Wow, solo imparten clases dos profesores con una plantilla de 12... algo hay raro.

-- 5. Devuelve un listado con las asignaturas que no tienen un profesor asignado.
SELECT nombre FROM asignatura WHERE id_profesor IS NULL;
	-- 62/83, es decir un 75% de las asignaturas no tienen profesores asignados

-- 6. Devuelve un listado con todos los departamentos que no han impartido asignaturas en ningún curso escolar.
/* REPASAR. NO FUNCIONA. HE HECHO TODOS LOS VINCULOS CON JOIN, PERO NO SE COMO PONERLE AL WHERE LA CONDICION CORRECTA */
SELECT departamento.nombre
FROM departamento
RIGHT JOIN profesor ON departamento.id = profesor.id_departamento
RIGHT JOIN asignatura ON asignatura.id_profesor = profesor.id_profesor
RIGHT JOIN alumno_se_matricula_asignatura ON alumno_se_matricula_asignatura.id_asignatura = asignatura.id
RIGHT JOIN curso_escolar ON curso_escolar.id = alumno_se_matricula_asignatura.id_curso_escolar
WHERE asignatura.id IS NULL;