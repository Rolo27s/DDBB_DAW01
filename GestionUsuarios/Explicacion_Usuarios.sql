-- EXPLICACION DE CREACION Y GESTION DE USUARIOS DE MYSQL
SHOW DATABASES;
-- Aqui estan todos los datos de los usuarios. Contraseñas, privilegios...
USE mysql;
SHOW TABLES;
SELECT * FROM USER;
-- Ver los campos user y host suele ser suficiente
SELECT user, host from user;

/*1.Crea una nueva base de datos si no existe llamada BD01juegos*/
CREATE DATABASE if not exists bd01juegos;
USE bd01juegos;

 /*2.crea un usuario llamado alumno en la máquina local  --(como root)*/
 -- Esta sentencia muestra los permisos con los cuales se ha creado el usuario
 SHOW CREATE USER 'root'@'localhost';
 -- Es lo mismo en este caso porque current_user es root
 SHOW CREATE USER current_user();
 
 -- Para crear usuario sería esta sentencia. Nombre: alumno, Desde donde: localhost (o direccion IP, o %), IDENTIFIED es la contraseña
 CREATE USER if not exists 'alumno'@'localhost'
 IDENTIFIED BY '1234';
 
 
/*3. concede los privilegios de crear modificar y eliminar tablas --(como root)*/
GRANT CREATE, DROP, ALTER on bd01juegos.* TO
'alumno'@'localhost';

 /*4. nos auténticamos con el nuevo usuario y creamos una tabla llamada personal con los campos idpersona PK autoincremental, nombre, apellidos, fecha nacimiento. Además crea un índice con los campos apellidos, nombre ( ascendente) --( como alumno)*/
 -- En la cuenta del usuario alumno, ejecuto esta sentencia:
 USE bd01juegos;
 CREATE TABLE personal (
	idpersona INT AUTO_INCREMENT PRIMARY KEY,
    nombre varchar(10) NOT NULL,
    apellidos varchar(30) NOT NULL,
    fechanacimiento date,
    INDEX (apellidos asc, nombre asc)
	);
 
/*5. Creamos una nueva tabla juego con los campos idjuego int PK,  nombre, descripción, fecha de compra, Idcomprador, que la estableceremos como FOREIGN KEY*/
-- Tambien ejecutamos esta sentencia desde el usuario alumnos.
-- Vemos que 'alumno' necesita mas privilegios
GRANT SELECT, REFERENCES on bd01juegos.* TO 'alumno'@'localhost';

/*6. Para crear la tabla anterior hay que añadir el privilegio reference sobre el usuario alumno --como root*/
-- le damos permisos de crear usuario en todas las bases de datos y todas las tablas con opciones de gestion
GRANT CREATE USER ON *.* TO 'alumno'@'localhost' WITH GRANT OPTION;

/* 7. cómo alumno ahora si podemos, pero debemos refrescar la sesión para que los cambios se ejecuten*/

 /*8. crear un nuevo usuario llamado alumno2@localhost con el usuario alumno@localhost
 --como alumno no va a funcionar porque no tiene los permisos adecuados*/

 
 /*9. otorgar desde root  los privilegios de create user y modificar los que tenía, with Grant option --cómo root */
 
 
/*10. Ahora si podemos crear usuarios, pero para poder otorgar los permisos que ya teníamos tenemos que poner with grant option 
Como alumno otorgamos algunos de sus permisos*/

 /*11. --cómo root tb le puedo dar permiso a alumno2 p.ej delete*/
 GRANT DELETE on bd01juegos.* TO 'alumno2'@'localhost';
 
 -- veo los permisos de alumno
 show grants for 'alumno'@'localhost';
 
/*12. eliminar permisos como root*/
REVOKE DROP on bd01juegos.* from 'alumno'@'localhost';

/*==============================================================*/
 /*realizamos lo siguiente como root*/
/*==============================================================*/
 
/*13. cambiamos la clave de alumno y cuando entre de nuevo pide cambiarla*/
ALTER USER 'alumno'@'localhost' IDENTIFIED BY '1234' PASSWORD EXPIRE;

-- Esto sería un cambio std de pwd a 0000
ALTER USER 'alumno'@'localhost' IDENTIFIED BY '0000';

 /*14.cambiamos el nombre al usuario de alumno por dawuser*/
 RENAME USER 'alumno'@'localhost' to 'dawuser'@'localhost';
 
/*15. Eliminamos el usuario alumno2*/
DROP user 'alumno2'@'localhost';

/* 16. poner todos los permisos de la base de datos bd01juegos al usuario dawser*/
SHOW GRANTS FOR 'dawuser'@'localhost';
-- le damos todos los privilegios a dawuser
GRANT ALL ON bd01juegos.* TO 'dawuser'@'localhost';