-- 1 1.	Escribe un procedimiento que no tenga ningún parámetro de entrada ni de salida y que muestre el texto ¡Hola mundo!.
DELIMITER //
CREATE PROCEDURE hola_mundo()
BEGIN
    SELECT '¡Hola mundo!';
END //
DELIMITER ;
CALL hola_mundo();
-- 2 Escribe un procedimiento que reciba un número real de entrada y muestre un mensaje indicando si el número es positivo, negativo o cero
DELIMITER //
DROP PROCEDURE IF EXISTS verificar_numero //
CREATE PROCEDURE verificar_numero(IN numero REAL)
BEGIN
    IF numero > 0 THEN
        SELECT 'El número es positivo';
    ELSEIF numero < 0 THEN
        SELECT 'El número es negativo';
    ELSE
        SELECT 'El número es cero';
    END IF;
END //

DELIMITER ;
CALL verificar_numero(23.45);
-- 3 Modifique el procedimiento diseñado en el ejercicio anterior para que tenga un parámetro de entrada, con el valor un número real, y un parámetro de salida, con una cadena de caracteres indicando si el número es positivo, negativo o cero.
DELIMITER //
DROP PROCEDURE IF EXISTS verificar_numero //
CREATE PROCEDURE verificar_numero(IN numero REAL, OUT resultado VARCHAR(50))
BEGIN
    IF numero > 0 THEN
        SET resultado = 'El número es positivo';
    ELSEIF numero < 0 THEN
        SET resultado = 'El número es negativo';
    ELSE
        SET resultado = 'El número es cero';
    END IF;
END //

DELIMITER ;
CALL verificar_numero(8.3, @resultado );
SELECT @resultado;

-- 4 Escribe un procedimiento que reciba un número real de entrada, que representa el valor de la nota de un alumno, y muestre un mensaje indicando qué nota ha obtenido teniendo en cuenta las siguientes condiciones:
-- 	[0,5) = Insuficiente
--  [5,6) = Aprobado
-- 	[6, 7) = Bien
-- 	[7, 9) = Notable
-- 	[9, 10] = Sobresaliente
-- 	En cualquier otro caso la nota no será válida.
DROP PROCEDURE IF EXISTS verificar_numero;
DELIMITER //
CREATE PROCEDURE verificar_nota(IN nota REAL)
BEGIN
    IF nota >= 0 AND nota < 5 THEN
        SELECT 'Insuficiente';
    ELSEIF nota >= 5 AND nota < 6 THEN
        SELECT 'Aprobado';
    ELSEIF nota >= 6 AND nota < 7 THEN
        SELECT 'Bien';
    ELSEIF nota >= 7 AND nota < 9 THEN
        SELECT 'Notable';
    ELSEIF nota >= 9 AND nota <= 10 THEN
        SELECT 'Sobresaliente';
    ELSE
        SELECT 'Nota no válida';
    END IF;
END //

DELIMITER ;
CALL verificar_nota(8.3);
-- 5 Modifique el procedimiento diseñado en el ejercicio anterior para que tenga un parámetro de entrada, con el valor de la nota en formato numérico y un parámetro de salida, con una cadena de texto indicando la nota correspondiente.
DROP PROCEDURE IF EXISTS verificar_numero;
DELIMITER //
CREATE PROCEDURE verificar_nota(IN nota REAL, OUT resultado VARCHAR(20))
BEGIN
    IF nota >= 0 AND nota < 5 THEN
        SET resultado = 'Insuficiente';
    ELSEIF nota >= 5 AND nota < 6 THEN
        SET resultado = 'Aprobado';
    ELSEIF nota >= 6 AND nota < 7 THEN
        SET resultado = 'Bien';
    ELSEIF nota >= 7 AND nota < 9 THEN
        SET resultado = 'Notable';
    ELSEIF nota >= 9 AND nota <= 10 THEN
        SET resultado = 'Sobresaliente';
    ELSE
        SET resultado = 'Nota no válida';
    END IF;
END //

DELIMITER ;
CALL verificar_nota(8.3, @resultado );
-- 6 6.	Resuelva el procedimiento diseñado en el ejercicio anterior haciendo uso de la estructura de control CASE.
DROP PROCEDURE IF EXISTS verificar_nota;
DELIMITER //
CREATE PROCEDURE verificar_nota(IN nota REAL, OUT resultado VARCHAR(20))
BEGIN
    CASE 
        WHEN nota >= 0 AND nota < 5 THEN SET resultado = 'Insuficiente';
        WHEN nota >= 5 AND nota < 6 THEN SET resultado = 'Aprobado';
        WHEN nota >= 6 AND nota < 7 THEN SET resultado = 'Bien';
        WHEN nota >= 7 AND nota < 9 THEN SET resultado = 'Notable';
        WHEN nota >= 9 AND nota <= 10 THEN SET resultado = 'Sobresaliente';
        ELSE SET resultado = 'Nota no válida';
    END CASE;
END //

DELIMITER ;
CALL verificar_nota(8.3, @resultado );
SELECT @resultado;
-- 7 Escribe un procedimiento que reciba como parámetro de entrada un valor numérico que represente un día de la semana y que devuelva una cadena de caracteres con el nombre del día de la semana correspondiente. Por ejemplo, para el valor de entrada 1 debería devolver la cadena lunes
DROP PROCEDURE IF EXISTS nombre_dia;
DELIMITER //
CREATE PROCEDURE nombre_dia(IN dia_semana INT, OUT nombre_dia_semana VARCHAR(20))
BEGIN
    CASE dia_semana
        WHEN 1 THEN SET nombre_dia_semana = 'Lunes';
        WHEN 2 THEN SET nombre_dia_semana = 'Martes';
        WHEN 3 THEN SET nombre_dia_semana = 'Miércoles';
        WHEN 4 THEN SET nombre_dia_semana = 'Jueves';
        WHEN 5 THEN SET nombre_dia_semana = 'Viernes';
        WHEN 6 THEN SET nombre_dia_semana = 'Sábado';
        WHEN 7 THEN SET nombre_dia_semana = 'Domingo';
        ELSE SET nombre_dia_semana = 'Día no válido';
    END CASE;
END //

DELIMITER ;
CALL nombre_dia(3, @nombre_dia_semana);
SELECT @nombre_dia_semana;
