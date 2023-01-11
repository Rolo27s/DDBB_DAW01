use prueba;
desc ejemplo;
INSERT INTO ejemplo (edad, edad2) VALUES (22, 45);
/* Para ver todos los datos que hay en mi tabla usamos "SELECT * FROM ejemplo;" */
SELECT * FROM ejemplo;
INSERT INTO ejemplo (edad, edad2) VALUES (20, 45);

CREATE TABLE IF NOT EXISTS ejemplo2(
id INT,
dni VARCHAR(9) UNIQUE,
nombre VARCHAR(25) NOT NULL,
edad INT,
idejemplo INT,
FOREIGN KEY (idejemplo) REFERENCES ejemplo1(id) ON UPDATE CASCADE ON DELETE CASCADE,
/* La nomenclatura de las constraint suele ser 2 char mayus de que elemento es, 3 char del nombre de la tabla y 3 char del campo de referencia*/
CONSTRAINT PK_ej2_id2 PRIMARY KEY (id),
CONSTRAINT CK_ej2_edad CHECK (edad BETWEEN 20 AND 50));

/* Para renombrar tablas */
RENAME TABLE ejemplo TO ejemplo1;

/* Para borrar una tabla */
DROP TABLE ejemplo2;

/* Para editar tablas (ALTER es alterar) */
ALTER TABLE ejemplo2 ADD apellidos VARCHAR(25) DEFAULT 'Pérez' NOT NULL AFTER nombre;

/* Para ver la tabla ejemplo2 */
DESC ejemplo2;

/* Modificar el nombre de ejemplo2. Además añadiremos que el nombre comienze con la letra a o A (comtempla las dos opciones porque no es key sensitive)*/
ALTER TABLE ejemplo2 MODIFY nombre VARCHAR(20) CHECK (nombre LIKE 'a%');

/* Añadimos info a ejemplo2 */
INSERT INTO ejemplo2 VALUES (25, '32456512A', 'Juan', 'Pitalúa', 32, 1);

/* Si quisieramos añadir todo menos el apellido y dejarlo por defecto */
INSERT INTO ejemplo2 (id, dni, nombre, edad, idejemplo) VALUES (25, '32456512A', 'AJuan', 32, 1);

SELECT * FROM ejemplo2;