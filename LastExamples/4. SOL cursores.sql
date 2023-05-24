/*Escribe las sentencias SQL necesarias para crear una base de datos llamada test, una tabla llamada alumnos y 4 sentencias de inserción para inicializar la tabla. La tabla alumnos está formada por las siguientes columnas:
●	id (entero sin signo y clave primaria)
●	nombre (cadena de caracteres)
●	apellido1 (cadena de caracteres)
●	apellido2 (cadena de caracteres
●	fecha_nacimiento (fecha)
Una vez creada la tabla se decide añadir una nueva columna a la tabla llamada edad que será un valor calculado a partir de la columna fecha_nacimiento. Escriba la sentencia SQL necesaria para modificar la tabla y añadir la nueva columna.
Escriba una función llamada calcular_edad que reciba una fecha y devuelva el número de años que han pasado desde la fecha actual hasta la fecha pasada como parámetro:
●	Función: calcular_edad
●	Entrada: Fecha
●	Salida: Número de años (entero)
Ahora escriba un procedimiento que permita calcular la edad de todos los alumnos que ya existen en la tabla. Para esto será necesario crear un procedimiento llamado actualizar_columna_edad que calcule la edad de cada alumno y actualice la tabla. Este procedimiento hará uso de la función calcular_edad que hemos creado en el paso anterior.
*/
DROP DATABASE IF  EXISTS test;
CREATE DATABASE IF NOT EXISTS test;

USE test;

CREATE TABLE IF NOT EXISTS alumnos (
  id INT UNSIGNED PRIMARY KEY,
  nombre VARCHAR(50),
  apellido1 VARCHAR(50),
  apellido2 VARCHAR(50),
  fecha_nacimiento DATE
);

INSERT INTO alumnos VALUES
  (1, 'Juan', 'Pérez', 'García', '1990-05-15'),
  (2, 'María', 'Gómez', 'Fernández', '1992-08-23'),
  (3, 'Luis', 'Sánchez', 'González', '1995-02-10'),
  (4, 'Ana', 'Jiménez', 'López', '1997-11-07');


ALTER TABLE  alumnos ADD edad INT UNSIGNED;

DELIMITER //
DROP FUNCTION IF EXISTS calcular_edad //
CREATE FUNCTION calcular_edad (fecha DATE)
RETURNS INT DETERMINISTIC
BEGIN
    DECLARE edad INT;
    DECLARE fecha_actual DATE DEFAULT curdate();
    IF (fecha IS NULL OR fecha > fecha_actual) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error: La fecha no es válida';
    END IF;-- error lanzado por el usuario, se sale del procedimiento o función
    SET edad = truncate(datediff(fecha_actual,fecha)/365.25,0);
    RETURN edad;
END //
DELIMITER ;

DELIMITER //

CREATE PROCEDURE actualizar_edad()
BEGIN
    DECLARE fin_cursor INT DEFAULT FALSE;
    DECLARE id_leida INT;
    DECLARE fecha_leida DATE;
    DECLARE cur CURSOR FOR SELECT id, fecha_nacimiento FROM alumnos;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET fin_cursor = TRUE;
    
    START TRANSACTION;
    OPEN cur;
    read_loop: LOOP
        FETCH cur INTO id_leida, fecha_leida;
        IF fin_cursor THEN
            LEAVE read_loop;
        END IF;
        BEGIN
            DECLARE EXIT HANDLER FOR SQLEXCEPTION, SQLWARNING
            BEGIN
                ROLLBACK;
                SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Error en el procedimiento';
            END;
            UPDATE alumnos SET edad = calcular_edad(fecha_leida) WHERE id = id_leida;
        END;
    END LOOP;
    CLOSE cur;
    COMMIT;
END//

DELIMITER ;
CALL actualizar_edad();
SELECT * from alumnos;
