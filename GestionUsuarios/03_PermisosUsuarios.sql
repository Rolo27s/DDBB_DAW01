-- Ejercicios sobre permisos y usuarios
-- 1. Muestra utilizando la herramienta cliente 'mysql' el listado de usuarios-hosts del servidor Mysql
SELECT User, Host FROM mysql.user;

-- 2. Crea un usuario utilizando ‘CREATE USER’ con nombre 'userWork' y password '1234'. Haz que sólo se pueda conectar desde la red '10.10.1.X'
CREATE USER 'userWork'@'10.10.1.%' IDENTIFIED BY '1234';

-- 3. Crea un usuario utilizando ‘INSERT’ utilizando la herramienta PhpMyadmin con nombre 'userMyadmin' y password '5678'. Haz que se pueda conectar desde cualquier IP.
/* En el enunciado se comenta una herramienta de PhpMyAdmin. He estado buscando documentacion sobre INSERT INTO y parece ser que es posible pero desaconsejado
	En cualquier caso encontre soluciones del tipo: INSERT INTO mysql.user (User, Host, Password) VALUES ('usuario', 'host', PASSWORD('contraseña'));
	Pero me daban un error que no se interpretar */
CREATE USER 'userMyadmin'@'%' IDENTIFIED BY '5678';


-- 4. Comprueba la lista de usuarios creados y los permisos que tienen.
SELECT * from user;

-- 5. Crea un usuario anónimo (es decir, que no tenga password) de nombre 'anonino' directamente en la tabla 'user' y que tenga acceso desde cualquier IP.
/*INSERT INTO mysql.user ('Host', 'User', 'Select_priv',
'ssl_cipher','x509_issuer','x509_subject') VALUES ('%', 'anonimo', 'Y', '','','');*/


-- 6. Intenta conectar con dicho usuario (no deberías poder).


-- 7. ¿ Qué necesitas hacer para que los nuevos permisos tengan efecto? Hazlo utilizando la orden SQL correspondiente.
/* Comprueba que una vez ejecutada la orden anterior ya puedes conectarte.
Una vez conectado, comprueba cual es tu usuario. */


-- 8. Intenta realizar un 'select' sobre una tabla cualquiera. ¿ Cual es el resultado? ¿ Por qué?


-- 9. Modifica el usuario anterior y haz que tenga permiso de selección sobre todas las tablas de todas las bases de datos.
-- Aplica los permisos sin reiniciar el servidor utilizando la herramienta cliente 'mysqladmin' y comprueba que funciona.


-- 10. Ejecuta la orden SQL que muestre los permisos que tiene concedido el usuario 'anónimo'.


-- 11. Crea un usuario de nombre 'accesotabla' y password 'accesotabla' que tenga acceso desde cualquier ip.
-- Comprueba que no pueda seleccionar la tabla 'empleado' de la base de datos 'jardineria'.
CREATE USER 'accesotabla'@'%' IDENTIFIED BY 'accesotabla';

-- Una vez creado el usuario, logeamos con el y hacemos estas sentencias
USE jardineria;
SELECT * FROM empleado;
-- Salta un error de que no tenemos permisos de acceso... volvemos a root para seguir trabajando

-- 12. Dale permiso de selección sobre la tabla 'empleado' de la base de datos 'jardineria'.
GRANT SELECT ON jardineria.empleado TO 'accesotabla'@'%';


-- 13. Comprueba que puedes seleccionar la tabla. ¿ No puedes? ¿ Qué falta por hacer? Hazlo y comprueba que ya puedes seleccionar.
SHOW GRANTS FOR 'accesotabla'@'%';
-- Al mostrar los permisos de accesotabla ya se ve que si tenemos el SELECT en jardineria.empleado disponible.

-- 14. Crea un usuario 'tengopermisos' y otórgale permisos para que pueda crear usuarios.
CREATE USER 'tengopermisos'@'localhost' IDENTIFIED BY '1234';
GRANT CREATE USER ON *.* TO 'tengopermisos'@'localhost' WITH GRANT OPTION;
SELECT * from user where user = 'tengopermisos';

-- 15. Conectado como 'tengopermisos' crea un nuevo usuario 'user1'.
CREATE USER 'user1'@'localhost';

-- 16. Conectado como 'root', otórgale permisos al usuario 'user1' para que pueda crear tablespaces.
GRANT CREATE TABLESPACE ON *.* TO 'user1'@'localhost';

-- 17. Conectado como 'root', muestra los permisos que tiene el usuario 'user1'.
SHOW GRANTS FOR 'user1'@'localhost';

-- 18. Conectado como 'user1' muestra los permisos que posee y comprueba que son los mismos a los de la orden anterior.
SHOW GRANTS FOR 'user1'@'localhost';
-- No puedo ver los permisos de user1 desde user1 porque no tengo permisos de nada de momento.

-- 19. Conectado como 'root' crea un usuario de nombre 'creartablas' que tenga permisos para crear, borrar y modificar tablas de una base de datos creada previamente.
CREATE USER 'creartablas'@'localhost' IDENTIFIED BY '888';
CREATE DATABASE IF NOT EXISTS pruebaPermisos character set utf8mb4;
GRANT CREATE, ALTER, DROP, SELECT, INSERT, UPDATE, DELETE ON pruebaPermisos.* TO 'creartablas'@'localhost';
SHOW GRANTS FOR 'creartablas'@'localhost';

-- 20. Conectado como 'creartablas' crea un tabla sencilla de al menos dos columnas.
USE pruebapermisos;
CREATE TABLE personas (
  id INT PRIMARY KEY AUTO_INCREMENT,
  nombre VARCHAR(50)
);


-- 21. Conectado como 'root' crea un usuario de nombre 'accesoglobal' que pueda realizar operaciones de selección y inserción sobre todas las tablas de todas las bases de datos.
CREATE USER 'accesoglobal'@'%' IDENTIFIED BY 'password';
GRANT SELECT, INSERT ON *.* TO 'accesoglobal'@'%';


-- 22. Conectado como 'accesoglobal' añade una fila a la tabla creada anteriormente. Intenta borrar la fila creada. ¿ Puedes?
INSERT INTO personas (nombre) VALUES ('Juan');
DELETE FROM personas WHERE id = 1;
-- No puedo borrar el registro desde accesoglobal porque no tengo acceso global, solo tengo acceso de select e insert.

select * from personas;

-- 23. Conectado como 'root' crea un usuario de nombre 'accesolocal' que pueda seleccionar todas las tablas de la base de datos anterior.
CREATE USER 'accesolocal'@'localhost' IDENTIFIED BY 'EstoyEnLocalHost';
GRANT SELECT ON *.* TO 'accesolocal'@'localhost';

-- 24. Conéctate como 'accesolocal' y comprueba que puedes selecciona la fila añadida anteriormente.
select * from personas;
-- Si puedo porque tengo permisos de select

-- 25. Conectado como 'root' crea un usuario de nombre 'accesolimitado' que pueda realizar operaciones de inserción, actualización y selección sobre la primera columna de la tabla creada previamente.
-- La primera columna de mi tabla es un id primary key auto incremental, asi que nunca se podría editar directamente. Cambio a la segunda columna (nombre)
CREATE USER 'accesolimitado'@'localhost' IDENTIFIED BY 'EstoyEnLocalHostPeroLimitado';
GRANT INSERT, UPDATE, SELECT ON pruebapermisos.personas TO 'accesolimitado'@'localhost';
-- Repasar! No se como concretar un campo dentro de una tabla. Intente la sintaxis pruebapermisos.personas.nombre y pruebapermisos.personas (nombre), pero no son váidas.

-- 26. Conéctate como 'accesolimitado' y comprueba que tienes los permisos ejecutando las órdenes SQL SELECT, UPDATE e INSERT. Comprueba que permisos tienes.
SHOW GRANTS FOR 'accesolimitado'@'localhost';

-- 27. Conectado como root crea un usuario de nombre 'creador' que tenga permisos para crear usuarios.
CREATE USER 'creador'@'%';
GRANT CREATE USER ON *.* TO 'creador'@'%' WITH GRANT OPTION;

-- 28. Conectado como 'creador' crea un nuevo usuario de nombre 'prueba1'.
CREATE USER 'prueba1'@'%';

-- 29. Conectado como root haz que tenga permisos de selección y borrado a nivel global y todos los permisos sobre una base de datos de ejemplo creada previamente (por ejemplo tienda). Dichos permisos podrán ser gestionados por el usuario.
GRANT SELECT, DELETE ON *.* TO 'prueba1'@'%' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON tienda.* TO 'prueba1'@'%' WITH GRANT OPTION;

-- 30. Conectado como 'root' crea un usario de nombre 'prueba2' que tenga permiso para actualizar una tabla de una base de datos creada previamente (por ejemplo tienda). Podrá gestionar dicho permiso.
CREATE USER 'prueba2'@'%';
GRANT UPDATE ON tienda.* TO 'prueba2'@'%' WITH GRANT OPTION;

-- 31. Conectado como 'creador' crea un usuario 'prueba3' y 'prueba4'
CREATE USER 'prueba3'@'%';
CREATE USER 'prueba4'@'%';

-- 32. Conectado como 'prueba1' otorga permiso de selección, actualización de una columna de una tabla (creada previamente en la base de datos de ejemplo) y ejecución de procedimientos al usuario 'prueba3' en la base de datos de ejemplo. 
-- ¿ Puedes hacerlo? ¿ Por qué?
-- No puedo hacerlo porque el usuario prueba1 solo tiene permisos globales de seleccionar y borrar. Es cierto que tiene todos los permisos en la base de datos de tienda, pero no es el caso.

-- 33. Quita todos los permisos al usuario 'prueba3'. ¿ Puedes hacerlo conectado como 'creador'? ¿ Por qué?
-- No. El creador solo puede crear nuevos usuarios

-- 34. Quita los permisos 'específicos' otorgados a cada uno de los usuarios anteriores, comprobando con la orden SQL SHOW GRANTS que realmente fueron eliminados.
REVOKE ALL PRIVILEGES ON *.* FROM 'prueba1'@'%';
REVOKE ALL PRIVILEGES ON *.* FROM 'prueba2'@'%';
REVOKE ALL PRIVILEGES ON *.* FROM 'prueba3'@'%';
REVOKE ALL PRIVILEGES ON *.* FROM 'prueba4'@'%';

SHOW GRANTS FOR 'prueba1'@'%';
SHOW GRANTS FOR 'prueba2'@'%';
SHOW GRANTS FOR 'prueba3'@'%';
SHOW GRANTS FOR 'prueba4'@'%';