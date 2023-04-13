-- generalidades
select * from ingresos;
select * from medico;
select * from paciente;

SELECT * FROM ingresos i
JOIN paciente p ON i.numhistorial = p.numhistorial
JOIN medico m ON i.codid = m.codmed;

-- CONSULTAS DE CLINICA
-- 1)	Personas alérgicas.
SELECT i.numingreso, p.nombre, p.apellidos, i.Observaciones, i.alergico
FROM ingresos i
JOIN paciente p ON i.numhistorial = p.numhistorial
WHERE i.alergico = 1;

-- 2)	Listado de los pacientes de cada médico.
SELECT DISTINCT p.nombre as nombre_paciente, p.apellidos as apellidos_paciente, m.nombre as nombre_medico FROM ingresos i
JOIN paciente p ON i.numhistorial = p.numhistorial
JOIN medico m ON i.codid = m.codmed;

-- 3)	¿Qué médicos son adjuntos y a qué pacientes han tratado?
SELECT DISTINCT m.nombre as nombre_medico, p.nombre as nombre_paciente FROM ingresos i
JOIN paciente p ON i.numhistorial = p.numhistorial
JOIN medico m ON i.codid = m.codmed
where m.cargo = "adjunto";

-- 4)	¿Qué pacientes tienen tratamientos con coste entre 7.000 y 10.000 y cuántos tratamientos son para cada paciente?
SELECT p.nombre, p.apellidos, i.costetratamiento FROM ingresos i
JOIN paciente p ON i.numhistorial = p.numhistorial
JOIN medico m ON i.codid = m.codmed
where i.costetratamiento between 7000 and 10000;

-- 5)	¿Qué pacientes son mujeres y padecen de asma?
SELECT p.nombre, p.apellidos FROM ingresos i
JOIN paciente p ON i.numhistorial = p.numhistorial
JOIN medico m ON i.codid = m.codmed
where p.Sexo = 'M' and i.diagnostico like "%asma%";

-- 6)	Qué pacientes han sido tratados por el mismo médico que Sergio Pérez Sanabria
SELECT DISTINCT p.nombre, p.apellidos FROM ingresos i
JOIN paciente p ON i.numhistorial = p.numhistorial
JOIN medico m ON i.codid = m.codmed
where codid = (select distinct codid from ingresos where numhistorial = (select numhistorial from paciente where nombre = "Sergio" and apellidos = "Pérez Sanabria"));

-- desgrane de subconsultas
-- numhistorial del señor
select numhistorial from paciente where nombre = "Sergio" and apellidos = "Pérez Sanabria";

-- codid (del medico) que tiene vinculado ese numhistorial
select distinct codid from ingresos where numhistorial = (select numhistorial from paciente where nombre = "Sergio" and apellidos = "Pérez Sanabria");

-- 7)	Listado de los médicos, y sus pacientes, que han tratado a un paciente que se ha ingresado una sola vez
select * from ingresos GROUP BY DNI;

-- En esta consulta tengo el numhistorial de los pacientes que han ingresado una sola vez
select numhistorial from ingresos group by numhistorial having count(numhistorial) = 1;

-- Respuesta final de la consulta 7
SELECT m.nombre nombre_medico, m.apellidos apellidos_medico, p.nombre nombre_paciente, p.apellidos apellidos_paciente FROM ingresos i
JOIN paciente p ON i.numhistorial = p.numhistorial
JOIN medico m ON i.codid = m.codmed
where i.numhistorial IN (select numhistorial from ingresos group by numhistorial having count(numhistorial) = 1);

-- 8)	Qué médicos no han tratado ningún ingreso
select m.codmed, m.nombre, m.apellidos from medico m
left join ingresos i on m.codmed = i.codid
where i.numhistorial is null;

-- 9)	¿Qué enfermedades tienen los hombres?
SELECT p.nombre, i.diagnostico FROM ingresos i
JOIN paciente p ON i.numhistorial = p.numhistorial
where p.Sexo = 'H';

-- 10)	¿Quién es el médico de Enrique Morales Miguel?
SELECT DISTINCT m.nombre, m.apellidos FROM ingresos i
JOIN paciente p ON i.numhistorial = p.numhistorial
JOIN medico m ON i.codid = m.codmed
where codid = (select distinct codid from ingresos where numhistorial = (select numhistorial from paciente where nombre = "Enrique" and apellidos = "Morales Miguel"));

-- 11)	¿Qué pacientes viven en Madrid capital?
select * from paciente where poblacion = 'Madrid';

-- 12)	¿nombre y apellido de los pediatras, así como de los pacientes que han asistido, de la misma planta que el paciente de la cama 45?

-- el pediatra
select m.nombre, m.apellidos, m.codmed from medico m where cargo like "%pediatr%";

-- planta del paciente de la cama 45. Es la planta 2.
select i.numplanta from ingresos i where numcama = 45;

-- pacientes de la planta 2
select p.nombre, p.apellidos from ingresos i
JOIN paciente p ON i.numhistorial = p.numhistorial
WHERE i.numplanta = (select i.numplanta from ingresos i where numcama = 45);

-- Respuesta final:
select p.nombre, p.apellidos from ingresos i
JOIN paciente p ON i.numhistorial = p.numhistorial
WHERE i.numplanta = (select i.numplanta from ingresos i where numcama = 45) AND codid = (select m.codmed from medico m where cargo like "%pediatr%");
-- Ningun paciente ha pasado por pediatría de momento, no solo de la planta 2, sino de ninguna planta.

-- 13)	¿Quiénes están ingresados en las plantas 1, 2 y 7?
select p.nombre, p.apellidos from ingresos i
JOIN paciente p ON i.numhistorial = p.numhistorial
WHERE i.numplanta IN (1, 2, 7);

-- 14)	De las personas alérgicas,¿quiénes lo son a la Penicilina o al Polen o a la Penicilina y el Polvo?
SELECT i.numingreso, p.nombre, p.apellidos, i.Observaciones, i.alergico
FROM ingresos i
JOIN paciente p ON i.numhistorial = p.numhistorial
WHERE i.Observaciones like "%penicil%" OR i.Observaciones like "%polen%" OR i.Observaciones like "%polvo%";

-- 15)	¿Qué médicos se han contratado en 1990 y tienen pacientes alérgicos que están en las camas de la primera planta y nombres de éstos pacientes?
SELECT m.nombre nombre_medico, m.apellidos apellidos_medico, p.nombre nombre_paciente_planta1, p.apellidos apellidos_paciente_planta1 FROM ingresos i
JOIN paciente p ON i.numhistorial = p.numhistorial
JOIN medico m ON i.codid = m.codmed
where year(m.fechacontrata) = '1990' AND i.alergico = 1 AND i.numplanta = 1;

-- Para no repetir nombre de medicos se puede usar union
SELECT DISTINCT m.nombre, m.apellidos FROM ingresos i
JOIN paciente p ON i.numhistorial = p.numhistorial
JOIN medico m ON i.codid = m.codmed
where year(m.fechacontrata) = '1990' AND i.alergico = 1 AND i.numplanta = 1
UNION
SELECT DISTINCT p.nombre, p.apellidos FROM ingresos i
JOIN paciente p ON i.numhistorial = p.numhistorial
JOIN medico m ON i.codid = m.codmed
where year(m.fechacontrata) = '1990' AND i.alergico = 1 AND i.numplanta = 1;

-- 16)	Total del coste de tratamiento de los hombres y mujeres cuyo coste de tratamiento sea mayor que el de Olga Prats Hernández.

-- coste de tratamiento de Olga. Son 9k.
select costetratamiento from ingresos where numhistorial = (select numhistorial from paciente where nombre = 'Olga' AND apellidos = 'Prats Hernández');

-- Respueta final:
select sum(costetratamiento) from ingresos where costetratamiento > (select costetratamiento from ingresos where numhistorial = (select numhistorial from paciente where nombre = 'Olga' AND apellidos = 'Prats Hernández'));

-- 17)	¿Quién está en la cama 152?
SELECT p.nombre, p.apellidos FROM ingresos i
JOIN paciente p ON i.numhistorial = p.numhistorial
WHERE i.numcama = 152;

-- 18)	¿A quién ha atendido Carmen Esteban Muñoz?

-- Codigo de Carmencita
Select codmed from medico where nombre = "Carmen" and apellidos = "Esteban Muñoz";

-- numhistorial vinculado con ese codmed
select numhistorial from ingresos where codid = (Select codmed from medico where nombre = "Carmen" and apellidos = "Esteban Muñoz");

-- nombre de ese numhistorial y respuesta final:
select nombre, apellidos from paciente where numhistorial = (select numhistorial from ingresos where codid = (Select codmed from medico where nombre = "Carmen" and apellidos = "Esteban Muñoz"));

-- 19)	¿Qué médicos son adjuntos o tienen el mismo cargo que el que casi siempre llega tarde?

-- medicos adjuntos
select nombre, apellidos from medico where cargo = 'adjunto';

-- El que casi siempre llega tarde es el Santi, supervisor.
select nombre, apellidos, cargo from medico where observaciones like '%tarde%';

-- Los medicos que son supervisores
select nombre, apellidos from medico where cargo = (select cargo from medico where observaciones like '%tarde%');

-- Respuesta final:
select nombre, apellidos from medico where cargo = 'adjunto' OR cargo = (select cargo from medico where observaciones like '%tarde%');

-- 20)	Lista la edad de cada paciente
select nombre, apellidos, YEAR(CURDATE()) - YEAR(fechanac) AS edad from paciente;

-- 21)	¿A quiénes han atendido los pediatras? REPETIDA en 12)
select p.nombre, p.apellidos from ingresos i
JOIN paciente p ON i.numhistorial = p.numhistorial
WHERE codid = (select m.codmed from medico m where cargo like "%pediatr%");
-- Ningun paciente ha pasado por pediatría de momento, no solo de la planta 2, sino de ninguna planta.

-- 22)	¿A qué médico se le deben dos pagas?
select nombre, apellidos from medico where observaciones like "%dos pagas%" OR observaciones like "%2 pagas%";

-- 23)	Quiénes fueron ingresados en el mismo mes y año que Alberto Puch Monza.

-- numhistorial del colega
select numhistorial from paciente where nombre = 'Alberto' and apellidos = 'Puch Monza';

-- mes y año de ingreso del colega
select year(fechaingreso) año, month(fechaingreso) mes from ingresos where numhistorial = (select numhistorial from paciente where nombre = 'Alberto' and apellidos = 'Puch Monza');

-- respuesta final:
SELECT p.nombre, p.apellidos FROM ingresos i
JOIN paciente p ON i.numhistorial = p.numhistorial
where year(i.fechaingreso) = (select year(fechaingreso) año from ingresos where numhistorial = (select numhistorial from paciente where nombre = 'Alberto' and apellidos = 'Puch Monza'))
AND month(fechaingreso) = (select month(fechaingreso) mes from ingresos where numhistorial = (select numhistorial from paciente where nombre = 'Alberto' and apellidos = 'Puch Monza'));

-- 24)	¿Qué pacientes tienen apendicitis, asma o cataratas?
SELECT p.nombre, p.apellidos, i.diagnostico FROM ingresos i
JOIN paciente p ON i.numhistorial = p.numhistorial
WHERE i.diagnostico IN( "apendicitis", "asma", "cataratas");

-- 25)	¿Qué médicos fueron contratados en el mismo mes que Juan Perea Rodríguez? Muy parecida a la 23). Entiendo que cuando se dice el mismo mes, es literalmente el mismo mes, por tanto, tengo tambien en cuenta el año
SELECT m.nombre, m.apellidos FROM medico m
where year(fechacontrata) = (select year(fechacontrata) año from medico where fechacontrata = (select fechacontrata from medico where nombre = 'Juan' and apellidos = 'Perea Rodríguez'))
AND month(fechacontrata) = (select month(fechacontrata) mes from medico where fechacontrata = (select fechacontrata from medico where nombre = 'Juan' and apellidos = 'Perea Rodríguez'));

-- Si por lo que sea, no se quisiera tener en cuenta el año sería asi:
SELECT m.nombre, m.apellidos FROM medico m
where month(fechacontrata) = (select month(fechacontrata) mes from medico where fechacontrata = (select fechacontrata from medico where nombre = 'Juan' and apellidos = 'Perea Rodríguez'));

-- 26)	¿Qué pacientes de la planta 3ª se ingresaron en 1998 y son de Madrid capital?
SELECT p.nombre, p.apellidos FROM ingresos i
JOIN paciente p ON i.numhistorial = p.numhistorial
where i.numplanta = 3 AND year(fechaingreso) = '1998' AND p.poblacion = 'Madrid';

-- 27)	Nombre de los pacientes que sean mujeres y de la planta 7 o 2?
SELECT p.nombre, p.apellidos FROM ingresos i
JOIN paciente p ON i.numhistorial = p.numhistorial
where i.numplanta IN (2, 7) AND p.Sexo = 'M';

-- 28)	Listado por nº de planta  indicando el paciente, el médico y la fecha de ingreso.
SELECT i.numplanta, p.nombre nombre_paciente, p.apellidos apellidos_paciente, m.nombre nombre_medico, m.apellidos apellidos_medico, i.fechaingreso FROM ingresos i
JOIN paciente p ON i.numhistorial = p.numhistorial
JOIN medico m ON i.codid = m.codmed
ORDER BY 1;

-- 29)	Todos los médicos cuyo cargo sea distinto al de Juana y Fernanda.

-- a ver que cargo tienen estas dos señoras. Son jefe de planta, jefa de planta y jefe de seccion
select cargo from medico where nombre = "Juana" OR nombre = "Fernanda";

-- respuesta final:
select nombre, apellidos, cargo from medico where cargo <> ALL (select cargo from medico where nombre = "Juana" OR nombre = "Fernanda");
-- como curiosidad aparece María Cuétara Fontaneda, que suele desayunar galletas y es Jefa de Sección. El punto es que no es jefE de sección, entonces es un cargo diferente.

-- 30)	Todos los médicos que tengan el campo de observación vacío. Entiendo que tambien se incluyen los nulos.
select * from medico where observaciones is null or observaciones like "";

-- 31)	Listado de los médicos cuyo cargo sea jefe de sección, la especialidad, nombre médicos y su nº de colegiado y su fecha de contratación.
select nombre, apellidos, especialidad, numcolegiado, fechacontrata from medico where cargo like "jefe de seccion";

-- 32)	Todos los pacientes que no sean de la capital Madrid.
select nombre, apellidos, poblacion from paciente where poblacion != "Madrid";

-- 33)	Que nos busque el paciente más mayor y nos diga su edad. Parecida a la 20)
select nombre, apellidos, YEAR(CURDATE()) - YEAR(fechanac) AS edad from paciente
ORDER BY 3
LIMIT 1;

-- 34)	Que nos busque el paciente más joven y nos diga su edad.
select nombre, apellidos, YEAR(CURDATE()) - YEAR(fechanac) AS edad from paciente
ORDER BY 3 desc
LIMIT 1;

-- 35)	Paciente cuyo nº de seguridad social empiece y termine por 8.
select numss, nombre, apellidos from paciente where numss like "8%" AND numss like "%8";

-- 36)	Pacientes cuyo nombre empiece por “J” y cuyo primer apellido empiece por “R” y su segundo apellido empiece por “M”.
select nombre, apellidos from paciente where nombre like "J%" AND apellidos like "R%" AND apellidos like "% M%";

-- 37)	Pacientes cuyo nº de teléfono termine en 3.
select distinct nombre, apellidos, telefono from paciente where telefono like "%3";

-- 38)	Listado de médicos que tengan algo en observación.
select codmed,nombre, apellidos, observaciones from medico where observaciones is not null and observaciones not like "" and observaciones not like " ";

-- 39)	Los pacientes cuyo nº de historial termine en F y que fueron ingresados en el año 1997.
SELECT p.nombre, p.apellidos, p.numhistorial, year(i.fechaingreso) as año_de_ingreso FROM ingresos i
JOIN paciente p ON i.numhistorial = p.numhistorial
where year(i.fechaingreso) = '1997';

-- 40)	Los pacientes que tengan alguna amputación.
SELECT p.nombre, p.apellidos, p.numhistorial, i.diagnostico FROM ingresos i
JOIN paciente p ON i.numhistorial = p.numhistorial
where i.diagnostico like "%amputacion%";

-- 41)	Obtener un listado de médicos por especialidad. REVISAR.
select nombre, apellidos, especialidad from medico
order by 3;

-- 42)	Obtener la lista de ingresos(numero, fecha y diagnóstico) del paciente 'José Eduardo Romerales Pinto'
SELECT p.nombre, p.apellidos, i.fechaingreso, i.diagnostico FROM ingresos i
JOIN paciente p ON i.numhistorial = p.numhistorial
WHERE p.nombre = "José Eduardo" AND p.apellidos = "Romerales Pinto"
ORDER BY 3;
-- Este hombre esta listisimo el pobre

-- 43)	Obtener el número total de ingresos que hay en la base de datos para los adjuntos
SELECT count(*) FROM ingresos i
LEFT JOIN medico m ON i.codid = m.codmed
WHERE m.cargo like "adjunto";

-- 44)	nombre de los pacientes y los médicos que lo han tratado, para los pacientes ingresados en 1998
SELECT p.nombre nombre_paciente, m.nombre nombre_medico FROM ingresos i
JOIN paciente p ON i.numhistorial = p.numhistorial
JOIN medico m ON i.codid = m.codmed
WHERE year(fechaingreso) = '1998';

-- 45)	Obtener el coste total de tratamiento del paciente 'José Eduardo Romerales Pinto'
SELECT p.nombre nombre_paciente, sum(i.costetratamiento) FROM ingresos i
JOIN paciente p ON i.numhistorial = p.numhistorial
WHERE p.nombre = "José Eduardo" AND p.apellidos = "Romerales Pinto"
GROUP BY p.nombre;

-- 46)	qué médicos han sido contratados a partir del año 2000
select nombre, apellidos, fechacontrata from medico
where year(fechacontrata) >= '2000'
ORDER BY 3;

-- 47)	Obtener la lista de pacientes que han sido tratados por más de un médico en distintos ingresos.
-- Tiene que salir 3*2: Ivan, Jaime y José.
SELECT m.nombre AS nombre_medico, m.apellidos AS apellidos_medico, p.nombre AS nombre_paciente, p.apellidos AS apellidos_paciente
FROM ingresos i
JOIN paciente p ON i.numhistorial = p.numhistorial
JOIN medico m ON i.codid = m.codmed
WHERE EXISTS (
  SELECT 1
  FROM ingresos i2
  WHERE i2.numhistorial = i.numhistorial AND i2.codid <> i.codid
)
ORDER BY 3;

-- 48)	Obtener la lista de médicos cuyo número de colegiado está duplicado:
SELECT nombre, numcolegiado
FROM medico
GROUP BY nombre, numcolegiado
HAVING COUNT(*) > 1;

-- 49)	Obtener la lista de médicos y pacientes que comparten el mismo nombre
SELECT nombre_coincidente
FROM (
  SELECT nombre AS nombre_coincidente
  FROM medico
  UNION ALL
  SELECT nombre AS nombre_coincidente
  FROM paciente
) AS nombres
GROUP BY nombre_coincidente
HAVING COUNT(*) > 1;

-- 50)	Obtener la lista de ingresos realizados por médicos que han sido contratados en los últimos 5 años

-- codmed de los medicos contratados en los ultimos 5 años
select codmed from medico where (YEAR(CURDATE()) - YEAR(fechacontrata)) <= 5;

-- ingresos con esos codigos y solucion del 50)
 SELECT * FROM ingresos i
JOIN medico m ON i.codid = m.codmed
WHERE codid = ANY (select codmed from medico where (YEAR(CURDATE()) - YEAR(fechacontrata)) <= 5);

-- 51)	Obtener la lista de pacientes que tienen más de un ingreso en el hospital, junto con la fecha del primer y último ingreso:
SELECT p.nombre AS nombre_paciente, p.apellidos AS apellidos_paciente, MIN(i.fechaingreso) AS primer_ingreso, MAX(i.fechaingreso) AS ultimo_ingreso
FROM ingresos i
JOIN paciente p ON i.numhistorial = p.numhistorial
WHERE i.numhistorial IN (
  SELECT numhistorial
  FROM ingresos
  GROUP BY numhistorial
  HAVING COUNT(*) > 1
)
GROUP BY p.nombre, p.apellidos;

-- 52)	Obtener la lista de pacientes que han sido tratados por los médicos que tienen especialidad pediatría. Repetida en 12) y 21)
select p.nombre, p.apellidos from ingresos i
JOIN paciente p ON i.numhistorial = p.numhistorial
WHERE codid = (select m.codmed from medico m where cargo like "%pediatr%");
-- Ningun paciente ha pasado por pediatría de momento, no solo de la planta 2, sino de ninguna planta.
