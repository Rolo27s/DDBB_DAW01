-- 1.	Escribe una función que reciba un número entero de entrada y devuelva TRUE si el número es par o FALSE en caso contrario.
DELIMITER //
DROP FUNCTION IF EXISTS es_par //
CREATE FUNCTION es_par(num INT)
RETURNS BOOLEAN DETERMINISTIC
BEGIN
    IF num % 2 = 0 THEN
        RETURN TRUE;
    ELSE
        RETURN FALSE;
    END IF;
END//
CREATE FUNCTION es_par(num INT)
RETURNS VARCHAR(25) DETERMINISTIC
BEGIN
    IF num % 2 = 0 THEN
        RETURN 'ES PAR';
    ELSE
        RETURN 'ES IMPAR';
    END IF;
END//
DELIMITER ;
SELECT es_par(3);
-- 2.	Escribe una función que reciba como parámetro de entrada un valor numérico que represente un día de la semana y que devuelva una cadena de caracteres con el nombre del día de la semana correspondiente. Por ejemplo, para el valor de entrada 1 debería devolver la cadena lunes.
DELIMITER //
DROP FUNCTION IF EXISTS nombre_dia_semana //
CREATE FUNCTION nombre_dia_semana(dia_semana INT)
RETURNS VARCHAR(50) DETERMINISTIC
BEGIN
    DECLARE dia VARCHAR(50);
    CASE dia_semana
        WHEN 1 THEN SET dia = 'lunes';
        WHEN 2 THEN SET dia = 'martes';
        WHEN 3 THEN SET dia = 'miércoles';
        WHEN 4 THEN SET dia = 'jueves';
        WHEN 5 THEN SET dia = 'viernes';
        WHEN 6 THEN SET dia = 'sábado';
        WHEN 7 THEN SET dia = 'domingo';
        ELSE SET dia = 'día no válido';
    END CASE;
    RETURN dia;
END //
DELIMITER ;
SELECT nombre_dia_semana(8);

-- 3.	Escribe una función que reciba tres números reales como parámetros de entrada y devuelva el mayor de los tres.
DELIMITER //
DROP FUNCTION  IF EXISTS mayor //
CREATE FUNCTION mayor(num1 FLOAT, num2 FLOAT, num3 FLOAT)
RETURNS FLOAT DETERMINISTIC
BEGIN
    DECLARE mayor_num FLOAT;
    IF num1 >= num2 AND num1 >= num3 THEN
        SET mayor_num = num1;
    ELSEIF num2 >= num1 AND num2 >= num3 THEN
        SET mayor_num = num2;
    ELSE
        SET mayor_num = num3;
    END IF;
    RETURN mayor_num;
END//
DELIMITER ;
SELECT mayor(5,12,12.01);
-- 4.	Escribe una función que devuelva el valor del área de un círculo a partir del valor del radio que se recibirá como parámetro de entrada.
-- Para realizar esta función puedes hacer uso de las siguientes funciones que nos proporciona MySQL:
-- 	PI
-- 	POW
-- 	TRUNCATE
DELIMITER //
DROP FUNCTION IF EXISTS area_circulo //
CREATE FUNCTION area_circulo(radio FLOAT)
RETURNS FLOAT DETERMINISTIC
BEGIN
    DECLARE area FLOAT;
    SET area = PI() * POW(radio, 2);
    SET area = TRUNCATE(area, 2);
    RETURN area;
END //
DELIMITER ;
SELECT area_circulo(2.3);
-- 5.	Escribe una función que devuelva como salida el número de años que han transcurrido entre dos fechas que se reciben como parámetros de entrada. Por ejemplo, si pasamos como parámetros de entrada las fechas 2018-01-01 y 2008-01-01 la función tiene que devolver que han pasado 10 años.
-- Para realizar esta función puedes hacer uso de las siguientes funciones que nos proporciona MySQL:
-- 	DATEDIFF
-- 	TRUNCATE
DELIMITER //
DROP FUNCTION IF EXISTS  años_transcurridos//
CREATE FUNCTION años_transcurridos(fecha_inicio DATE, fecha_fin DATE)
RETURNS INT DETERMINISTIC
BEGIN
    DECLARE años INT;
    SET años = DATEDIFF(fecha_fin, fecha_inicio) / 365;
    SET años = TRUNCATE(años, 0);
    RETURN años;
END //
DELIMITER ;
SELECT años_transcurridos('1995-5-3','2023-5-15');
