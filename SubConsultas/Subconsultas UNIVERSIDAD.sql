-- SUBCONSULTAS UNIVERSIDAD
-- 1. Devuelve todos los datos del alumno más joven.
select * from persona p where tipo='alumno' AND year(fecha_nacimiento) = (select min(year(fecha_nacimiento)) from persona where tipo='alumno');

-- 2. Devuelve un listado con los profesores que no están asociados a un departamento.
select * from persona p where tipo='profesor' AND not exists (select pro.id_profesor from profesor pro where pro.id_profesor=p.id);
-- Todos los profesores estan asociados a algun departamento, por eso no sale ningun registro en esta consulta actualmente.

-- 3. Devuelve un listado con los departamentos que no tienen profesores asociados. ¿Por que no sale nada? Deberia salir 7, 8 y 9, que no tienen profesores asociados. REVISAR.
select d.* from departamento d, profesor p where p.id_departamento = d.id AND d.id NOT IN (select p.id_departamento from profesor);

	select distinct d.* from departamento d, profesor p where p.id_departamento=d.id;
    
-- 4. Devuelve un listado con los profesores que tienen un departamento asociado y que no imparten ninguna asignatura. NO LA ENTIENDO. REVISAR.
select p.* from persona p, profesor where tipo='profesor' and profesor.id_departamento = all (select id_departamento from profesor where id_departamento is not null) ;

-- 5. Devuelve un listado con las asignaturas que no tienen un profesor asignado.
select * from asignatura where id_profesor is null;

-- 6. Devuelve un listado con todos los departamentos que no han impartido asignaturas en ningún curso escolar.
-- En alumno_se_matricula_asignatura, se ve que los id_curso_escolar usados son el 1 y el 5 solo. El 2, 3 y 4 no se usan.

-- Las asignaturas con id del 1 al 10 fueron impartidas. Las demas no.
select distinct id_asignatura from alumno_se_matricula_asignatura;

-- Veo en la tabla asignaturas, cuales son las que no se dieron y que profesor las impartiría si se dieran.
select * from asignatura where id NOT IN (select distinct id_asignatura from alumno_se_matricula_asignatura);

-- Veo en la tabla asignaturas, cuales son las que si se dieron y el profesor.
select * from asignatura where id IN (select distinct id_asignatura from alumno_se_matricula_asignatura);

-- Parece un poco lioso trabajar con las dos consultas anteriores y estoy viendo que en la tabla asignatura, se pretende referenciar a los registros con null en el campo id_profesor.
-- Al no poder usar los null como referencia, escogeré el camino contrario y luego usare not exists
select distinct id_profesor from asignatura where id_profesor is not null;

-- Aqui veríamos los departamentos que imparten asignaturas
select distinct id_departamento from profesor where id_profesor IN (select distinct id_profesor from asignatura where id_profesor is not null);

-- Por tanto, todos los demás departamentos no impartieron asignaturas y será la solucion final:
select * from departamento where id <> (select distinct id_departamento from profesor where id_profesor IN (select distinct id_profesor from asignatura where id_profesor is not null));