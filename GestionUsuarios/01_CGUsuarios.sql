-- Ejercicios de Creación y Gestión de Usuarios
/* 1. Escribe la sentencia para crear dos usuarios, “miusuario1” y
“miusuario2”, el primero con una contraseña (igual a su nombre de
usuario) y el otro sin contraseña. Muestra todos los usuarios que tienes
en tu sistema. */
CREATE USER 'miusuario1'@'localhost' IDENTIFIED BY 'miusuario1';
CREATE USER 'miusuario2'@'localhost' IDENTIFIED BY '';

SELECT user, host from user;

/* 2. Escribe las sentencias necesarias para darle al usuario “miusuario1”
todos los permisos cuando accede desde el localhost y también cuando
accede desde cualquier otro equipo. Desde ambos tendrá autorización
sobre todos los elementos de la base de datos, pero solo podrá otorgar
permisos desde el servidor o localhost. */
GRANT ALL PRIVILEGES ON *.* TO 'miusuario1'@'localhost';
GRANT ALL PRIVILEGES ON *.* TO 'miusuario1'@'localhost' WITH GRANT OPTION;


/* 3. Renombra al usuario “miusuario2” con el nombre “solojardineria”.
Asígnale una contraseña (la que quieras) a “solojardineria”. */
RENAME USER 'miusuario2'@'localhost' TO 'solojardineria'@'localhost';
ALTER USER 'solojardineria'@'localhost' IDENTIFIED BY 'la_que_quieras';

/* 4. Escribe la sentencia para dar a “solojardineria” permisos para acceder
desde cualquier puesto y que solo pueda realizar consultas,
inserciones, modificaciones y borrados sobre la base de datos
“jardinería”. Comprueba que efectivamente no puede realizar dichas
operaciones en otra BBDD que no sea “jardinería”. */
GRANT SELECT, INSERT, UPDATE, DELETE ON jardinería.* TO 'solojardineria'@'localhost';

-- comprobacion
USE mySQL;
SELECT * FROM USER WHERE user = "solojardineria";
-- Si me conecto al server con el usuario solojardineria, efectivamente no puedo gestionar otras bases de datos. Error command denied.

/* 5. Crea un nuevo usuario con contraseña llamado “solotablas” que pueda
acceder desde cualquier sitio. A este usuario solo se le permite (con
todos los privilegios) acceder a la tabla “persona” de la BBDD
“universidad”. Escribe la sentencia que muestre los permisos del usuario
“solotablas”. */
CREATE USER 'solotablas'@'%';
GRANT ALL PRIVILEGES ON universidad.persona TO 'solotablas'@'%';
SHOW GRANTS FOR 'solotablas'@'%';

/* 6. Elimina solo el permiso de lectura (SELECT) del usuario “solotablas”,
muestra los permisos que tiene asignado ahora dicho usuario y
comprueba que ahora no puede consultar la tabla “persona” pero sigue
manteniendo cualquiera de los otros permisos intactos. */
REVOKE SELECT ON universidad.persona FROM solotablas;
SHOW GRANTS FOR solotablas;

-- Si hacemos esta consulta desde el usuario "solotablas" nos saldría un error.
SELECT * FROM universidad.persona;

/* 7. Elimina cada uno de los usuarios que has creado en los ejercicios
anteriores. */
DROP USER 'miusuario1'@'localhost';
DROP USER 'solojardineria'@'localhost';
DROP USER 'solotablas'@'%';

SELECT user, host from user;