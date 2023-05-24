-- -------------------------------TRIGGERS----------------------------------------------
/*1. Crea una base de datos llamada test que contenga una tabla llamada alumnos con las siguientes columnas.
Tabla alumnos:
●	id (entero sin signo)
●	nombre (cadena de caracteres)
●	apellido1 (cadena de caracteres)
●	apellido2 (cadena de caracteres)
●	email (cadena de caracteres)
Escriba un procedimiento llamado crear_email que dados los parámetros de entrada: nombre, apellido1, apellido2 y dominio, cree una dirección de email y la devuelva como salida.
●	Procedimiento: crear_email
●	Entrada:
○	nombre (cadena de caracteres)
○	apellido1 (cadena de caracteres)
○	apellido2 (cadena de caracteres)
○	dominio (cadena de caracteres)
●	Salida:
○	email (cadena de caracteres)
devuelva una dirección de correo electrónico con el siguiente formato:
●	El primer carácter del parámetro nombre.
●	Los tres primeros caracteres del parámetro apellido1.
●	Los tres primeros caracteres del parámetro apellido2.
●	El carácter @.
●	El dominio pasado como parámetro.
Una vez creada la tabla escriba un trigger con las siguientes características:
●	Trigger: trigger_crear_email_before_insert
○	Se ejecuta sobre la tabla alumnos.
○	Se ejecuta antes de una operación de inserción.
○	Si el nuevo valor del email que se quiere insertar es NULL, entonces se le creará automáticamente una dirección de email y se insertará en la tabla.
○	Si el nuevo valor del email no es NULL se guardará en la tabla el valor del email.
Nota: Para crear la nueva dirección de email se deberá hacer uso del procedimiento crear_email.*/

-- Crear la base de datos
CREATE DATABASE test6;
USE test6;
CREATE TABLE alumnos (
  id INT UNSIGNED PRIMARY KEY,
  nombre VARCHAR(50),
  apellido1 VARCHAR(50),
  apellido2 VARCHAR(50),
  email VARCHAR(100)
);

-- Crear el procedimiento crear_email
DELIMITER //
CREATE PROCEDURE crear_email(IN v_nombre VARCHAR(50),IN v_apellido1 VARCHAR(50),
IN v_apellido2 VARCHAR(50),IN v_dominio VARCHAR(50),OUT v_email VARCHAR(100)
)
BEGIN
  SET v_email = CONCAT(LEFT(v_nombre, 1),LEFT(v_apellido1, 3),LEFT(v_apellido2, 3),'@',    v_dominio);
END //
DELIMITER ;

-- Crear el trigger
DELIMITER //
CREATE TRIGGER crear_email_b_i BEFORE INSERT ON alumnos FOR EACH ROW
BEGIN
  IF NEW.email IS NULL THEN
    CALL crear_email(NEW.nombre, NEW.apellido1, NEW.apellido2, 'iesgbrenan.com', NEW.email);
  END IF;
END //
DELIMITER ;


INSERT INTO alumnos (id, nombre, apellido1, apellido2)
VALUES (1, 'PEPE', 'PEREZ', 'GORRIÓN');
INSERT INTO alumnos (id, nombre, apellido1, apellido2)
VALUES (2, 'MARÍA', 'FLORES', 'JAEN');
INSERT INTO alumnos
VALUES (3, 'QUE', 'PESADILLA', 'CUANDO', 'vamosaacabar@toston.com');

