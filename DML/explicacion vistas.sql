DROP DATABASE IF EXISTS vistas;
CREATE DATABASE vistas CHARSET 'utf8mb4';
USE vistas;
drop table if exists empleados;
drop table if exists secciones;

 create table secciones(
  codigo int auto_increment primary key,
  nombre varchar(30),
  sueldo decimal(5,2)
 );

 create table empleados(
  legajo int primary key auto_increment,
  documento char(8),
  sexo char(1),
  apellido varchar(40),
  nombre varchar(30),
  domicilio varchar(30),
  seccion int not null,
  cantidadhijos int,
  estadocivil char(10),
  fechaingreso date
 );

 insert into secciones(nombre,sueldo) values('Administracion', 300);
 insert into secciones(nombre,sueldo) values('Contaduría', 400);
 insert into secciones(nombre,sueldo) values('Sistemas', 500);

 insert into empleados (documento,sexo,apellido,nombre,domicilio,seccion,cantidadhijos,estadocivil,fechaingreso)
   values ('22222222','f','Lopez','Ana','Colon 123',1,2,'casado','1990-10-10');
 insert into empleados (documento,sexo,apellido,nombre,domicilio,seccion,cantidadhijos,estadocivil,fechaingreso)   
   values('23333333','m','Lopez','Luis','Sucre 235',1,0,'soltero','1990-02-10');
 insert into empleados (documento,sexo,apellido,nombre,domicilio,seccion,cantidadhijos,estadocivil,fechaingreso)
   values('24444444','m','Garcia','Marcos','Sarmiento 1234',2,3,'divorciado','1998-07-12');
 insert into empleados (documento,sexo,apellido,nombre,domicilio,seccion,cantidadhijos,estadocivil,fechaingreso)
   values('25555555','m','Gomez','Pablo','Bulnes 321',3,2,'casado','1998-10-09');
 insert into empleados (documento,sexo,apellido,nombre,domicilio,seccion,cantidadhijos,estadocivil,fechaingreso)
   values('26666666','f','Perez','Laura','Peru 1254',3,3,'casado','2000-05-09');
 
 drop view if exists vista_empleados;

 create  view vista_empleados as
   select concat(apellido,' ',e.nombre) as nombre, 
         sexo,
         s.nombre as seccion,
         cantidadhijos
     from empleados as e
     join secciones as s on codigo=seccion;

 select * from vista_empleados;
 select nombre, seccion, cantidadhijos from vista_empleados;


 select seccion, count(*) as cantidad
   from vista_empleados
   group by seccion;

 

 create or REPLACE view vista_empleados_ingreso(fecingreso,cantidad) as
   select  extract(year from fechaingreso) as fecingreso,
           count(*) as cantidad
     from empleados
     group by fecingreso;

 select * from vista_empleados_ingreso;
 
 -- vista sobre otra vista
 create view vista_empleados_con_hijos as
   select nombre,
          sexo,
          seccion,
          cantidadhijos
     from vista_empleados
     where cantidadhijos>0;
     
select * from vista_empleados_con_hijos;

-- renombrar una vista
RENAME TABLE vista_empleados_ingreso TO Año_ingreso_empleados;

-- listado de vistas
SHOW FULL TABLES;
SHOW FULL TABLES WHERE Table_type='VIEW';

-- sentencia que creó la vista
SHOW CREATE VIEW Año_ingreso_empleados;

-- borrar una vista
DROP VIEW Año_ingreso_empleados;

-- VISTAS ACTUALIZABLE
DROP DATABASE IF EXISTS vistas2;
CREATE DATABASE vistas2 CHARSET 'utf8mb4';
USE vistas2;	
drop table if exists alumnos;
 drop table if exists profesores;
 
 create table alumnos(
  documento char(8),
  nombre varchar(30),
  nota decimal(4,2),
  codigoprofesor int,
  primary key(documento)
 );

 create table profesores (
   codigo int auto_increment,
   nombre varchar(30),
   primary key(codigo)
 );



 insert into alumnos values('30111111','Ana Algarbe', 5.1, 1);
 insert into alumnos values('30222222','Bernardo Bustamante', 3.2, 1);
 insert into alumnos values('30333333','Carolina Conte',4.5, 1);
 insert into alumnos values('30444444','Diana Dominguez',9.7, 1);
 insert into alumnos values('30555555','Fabian Fuentes',8.5, 2);
 insert into alumnos values('30666666','Gaston Gonzalez',9.70, 2);

 insert into profesores(nombre) values ('Maria Luque');
 insert into profesores(nombre) values ('Jorje Dante'); 

 drop view if exists vista_nota_alumnos_aprobados;

 -- Creamos una vista con los datos de todos los alumnos que tienen
 -- una nota mayor o igual a 7, junto con el nombre del profesor que
 -- lo calificó
 create view vista_nota_alumnos_aprobados as
   select documento,
          a.nombre as nombrealumno,
          p.nombre as nombreprofesor,
          nota,
          codigoprofesor
     from alumnos as a
     join profesores as p on a.codigoprofesor=p.codigo
     where nota>=7;

select * from vista_nota_alumnos_aprobados;

-- Mediante la vista insertamos un nuevo alumno calificado por el profesor
-- con código 1
insert into vista_nota_alumnos_aprobados(documento, nombrealumno, nota, codigoprofesor)
  values('99999999','Rodriguez Pablo', 10, 1);
   
select * from vista_nota_alumnos_aprobados;  

-- si consultamos la tabla base: alumnos tenemos una nueva fila con el alumno
-- insertado
select * from alumnos;

-- modificamos la nota de un alumno aprobado mediante la vista
update vista_nota_alumnos_aprobados set nota=10 
  where documento='30444444';
  
select * from alumnos;
select * from vista_nota_alumnos_aprobados;  

-- insertamos un nuevo profesor 
 insert into profesores(nombre) values ('Pepe Malvado'); 
	SELECT * from profesores;
-- Creamos una vista con todos los datos
CREATE OR REPLACE VIEW vista_con_todo AS
	SELECT  a.documento, a.nombre, a.nota, a.codigoprofesor,p.nombre nomprof FROM alumnos a
    join profesores p ON a.codigoprofesor=p.codigo;

SELECT * FROM profesores;
SELECT * FROM vista_con_todo;
-- vamos a añadir un alumno para Pepe
insert into vista_con_todo(documento, nombre, nota, codigoprofesor, nomprof)
  values('77777777','Lucas Opaco', 2, 3, 'Pepe Malvado');
-- vemos que no nos lo permite porque estamos usando 2 tablas
insert into vista_con_todo(documento, nombre, nota, codigoprofesor)
  values('77777777','Lucas Opaco', 2, 3); -- esta sí(una sola tabla base)
SELECT * FROM vista_con_todo;

-- INCONSISTENCIA
-- Si efectuamos un insert mediante la vista vista_nota_alumnos_aprobados e insertamos un alumno con una nota inferior a 7, dicha fila se inserta en la tabla base pero no se visualiza en la vista:

insert vista_nota_alumnos_aprobados(documento, nombrealumno, nota, codigoprofesor)
  values('88888886','Laura Robles', 3, 3);

-- se cargó en la tabla 'alumnos'
select * from alumnos;  

-- no se visualiza en la vista
select * from vista_nota_alumnos_aprobados;  


-- Para evitar este tipo de inconsistencias se ha creado la cláusula 'with check option'. Si agregamos ésta cláusula cuando creamos la vista luego no se harán inserciones, borrados o actualizaciones cuando los cambios no se visualizan en la vista.
-- para evitar ésto utilizamos la cláusula WITH CHECK OPTION
create or replace view vista_nota_alumnos_aprobados as
   select documento,
          a.nombre as nombrealumno,
          p.nombre as nombreprofesor,
          nota,
          codigoprofesor
     from alumnos as a
     join profesores as p on a.codigoprofesor=p.codigo
     where nota>=7
     WITH CHECK OPTION;
     
-- Se produce un error al tratar de insertar un alumno con nota menor a 7 ya que este alumno no aparecerá en la vista
update vista_nota_alumnos_aprobados set nota=1 
   where documento='30444444';
   
insert vista_nota_alumnos_aprobados(documento, nombrealumno, nota, codigoprofesor)
  values('73777777','Raquel Iluminada', 3, 1);
  
insert vista_nota_alumnos_aprobados(documento, nombrealumno, nota, codigoprofesor)
  values('73777777','Raquel Iluminada', 8, 1);

 select * from vista_nota_alumnos_aprobados; 