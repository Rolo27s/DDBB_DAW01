-- Ejercicios DCL en MySQL
/* 1. Localiza la tabla de usuarios de tu sistema MySql. Realiza una vista del contenido de dicha tabla
con “select user, host from user;” */
USE mysql;
SELECT user, host from user;

/* 2. Crea una bbdd en tu sistema que se llame ‘prueba’. Comprueba que se ha creado tu base de datos
con la instrucción “show databases;” */
CREATE DATABASE prueba;
SHOW DATABASES;

/* 3. Crea un usuario con CREATE USER, que se llame ‘Jose’ y la contraseña sea ‘patata’. Este usuario solo se podrá conectar desde la máquina local a la bbdd ‘prueba’. 
Muestra en la tabla user que se ha creado este usuario. Intenta encontrar la columna que muestra sus privilegios. (“select * from user;”) */
CREATE USER 'Jose'@'localhost' IDENTIFIED BY 'patata';
SELECT user, host from user WHERE User = 'Jose';
-- SELECT User, Host FROM mysql.user WHERE User = 'Jose'; Si hago referencia a mysql me facilita seguir agregando usuarios por la interfaz
select * from user;
SHOW GRANTS FOR 'Jose'@'localhost';

/* 4. Con GRANT crea un usuario que se llame ‘Antonio’ cuya contraseña sea ‘frita’, sólo tendrá
permisos de consulta y actualización ( select y update) de datos sobre todas las tablas de la base de
datos ‘prueba’.Muestra en la tabla user que se ha creado este usuario. Intenta encontrar la columna
que muestra sus privilegios.(“select * from user;”) */

-- No se si se esta pidiendo esto, pero de ser asi, no se puede crear un usuario con GRANT y devolvería un error porque en este momento no existe el usuario Antonio
GRANT SELECT, UPDATE ON prueba.* TO 'Antonio'@'localhost' IDENTIFIED BY 'frita';

-- Si queremos crear a Antonio y darle esos permisos sería asi:
CREATE USER 'Antonio'@'localhost' IDENTIFIED BY 'frita';
GRANT SELECT, UPDATE ON prueba.* TO 'Antonio'@'localhost';
SHOW GRANTS FOR 'Antonio'@'localhost';
select * from user;
SELECT * FROM mysql.db WHERE db = 'prueba' AND User = 'Antonio';

-- Se puede hacer boton derecho en la base de datos prueba. Schema inspector/Grant y se ve perfectamente los permisos de los diferentes usuarios en esa base de datos en concreto

/* 5. Crea un usario que se llame ‘Ana’ y la contraseña sea ‘huevo’, se podrá conectar desde cualquier
host y tendrá permiso de consulta (select) de datos sobre todas las tablas de la base de datos
‘prueba’.Muestra en la tabla user que se ha creado este usuario. Intenta encontrar la columna que
muestra sus privilegios.(“select * from user;”) */
CREATE USER 'Ana'@'%' IDENTIFIED BY 'huevo';
GRANT SELECT ON prueba.* TO 'Ana'@'%';
SHOW GRANTS FOR 'Ana'@'%';
select * from user;
SELECT * FROM mysql.db WHERE db = 'prueba' AND User = 'Ana';

/* 6. Quítale al usuario Antonio el permiso de actualización. Muestra en la tabla user las modificaciones. */
REVOKE UPDATE ON prueba.* FROM 'Antonio'@'localhost';
SELECT * FROM mysql.db WHERE db = 'prueba' AND User = 'Antonio';

/* 7. Otorga a Ana el privilegio de update sobre todas las tablas de la base de datos ‘prueba’. Muestra
en la tabla user las modificaciones. */
GRANT UPDATE ON prueba.* TO 'Ana'@'%';
SELECT * FROM mysql.db WHERE db = 'prueba' AND user='Ana';

/* 8. Quita a Antonio y a Ana el permiso de consulta. Muestra en la tabla user las modificaciones. */
REVOKE SELECT ON prueba.* FROM Antonio, Ana;
SELECT * FROM mysql.db WHERE db = 'prueba' AND User IN ('Antonio', 'Ana');

/* 9. Otorga a Antonio y a Ana todos los privilegios sorbre todas las tablas de la base de datos
‘prueba’. Muestra en la tabla user las modificaciones. */
GRANT ALL PRIVILEGES ON prueba.* TO 'Antonio'@'localhost';
GRANT ALL PRIVILEGES ON prueba.* TO 'Ana'@'%';
SELECT * FROM mysql.db WHERE db = 'prueba' AND User IN ('Antonio', 'Ana');

/* 10. Elimina el usuario Antonio. Muestra en la tabla user las modificaciones. */
DROP USER 'Antonio'@'localhost';
SELECT * FROM mysql.db WHERE db = 'prueba' AND User IN ('Antonio', 'Ana');

/* 11. Limita a Ana para que solo se pueda conectar desde el pc con la ip 167.87.3.19. Muestra en la
tabla user las modificaciones. */
DROP USER 'Ana'@'%';
CREATE USER 'Ana'@'167.87.3.19' IDENTIFIED BY 'huevo';
GRANT ALL PRIVILEGES ON prueba.* TO 'Ana'@'167.87.3.19';
SELECT * FROM mysql.db WHERE db = 'prueba' AND User = 'Ana';

/* 12. Cambia la contraseña de jose a ‘frito’. Muestra en la tabla user las modificaciones. */
ALTER USER 'Jose'@'localhost' IDENTIFIED BY 'frito';

/* 13. Borra los usuarios Jose y Ana. Muestra en la tabla user las modificaciones. */
DROP USER 'Jose'@'localhost';
DROP USER 'Ana'@'167.87.3.19';
SELECT user, host from user;

/* 14. Borra la base de datos ‘prueba’. Comprueba con “show databases” que ya no está la base de
datos. */
DROP DATABASE prueba;
SHOW DATABASES;

/* (Para cada ejercicio hay que mandar en una captura la sentencia a ejecutar, su ejecución
satisfactoria y las modificaciones que indica el enunciado [muestra en la tabla ...])*/

