-- EJERCICIOS DE PROCEDIMIENTOS
-- Procedimientos sin sentencias SQL
    /*1. Escribe un procedimiento que no tenga ningún parámetro de entrada ni de salida y que muestre el texto ¡Hola mundo!.*/
    DELIMITER //
    CREATE PROCEDURE hola_mundo()
    BEGIN
		SELECT '!Hola mundo!';
	END //
    DELIMITER ;
    CALL hola_mundo();
    
    /*2. Escribe un procedimiento que reciba un número real de entrada y muestre un mensaje indicando si el número es positivo, negativo o cero.*/
    DELIMITER //
    CREATE PROCEDURE num (in n real)
    BEGIN
		IF (n < 0) THEN SELECT 'negativo';
        ELSEIF (n = 0) THEN SELECT 'cero';
        ELSE SELECT 'positivo';
        END IF;
	END //
    DELIMITER ;
    CALL num(23.45);
    
    /*3. Modifique el procedimiento diseñado en el ejercicio anterior para que tenga un parámetro de entrada, con el valor un número real, 
    y un parámetro de salida, con una cadena de caracteres indicando si el número es positivo, negativo o cero.*/
    DELIMITER //
    CREATE PROCEDURE numSalida (in n real, out nS varchar(100))
    BEGIN
		IF (n < 0) THEN SET nS = 'negativo';
        ELSEIF (n = 0) THEN SET nS = 'cero';
        ELSE SET nS = 'positivo';
        END IF;
	END //
    DELIMITER ;
    
    CALL numSalida(23.45, @nS);
    SELECT @nS;
    
    /*4. Escribe un procedimiento que reciba un número real de entrada, que representa el valor de la nota de un alumno, 
    y muestre un mensaje indicando qué nota ha obtenido teniendo en cuenta las siguientes condiciones:
    • [0,5) = Insuficiente
    • [5,6) = Aprobado
    • [6, 7) = Bien
    • [7, 9) = Notable
    • [9, 10] = Sobresaliente
    • En cualquier otro caso la nota no será válida.*/
    DELIMITER //
    CREATE PROCEDURE n (in nota real)
    BEGIN
		IF (nota >= 0 AND nota < 5) THEN SELECT 'Insuficiente';
        ELSEIF (nota >= 5 AND nota < 6) THEN SELECT 'Aprobado';
        ELSEIF (nota >= 6 AND nota < 7) THEN SELECT 'Bien';
        ELSEIF (nota >= 7 AND nota < 9) THEN SELECT 'Notable';
        ELSEIF (nota >= 9 AND nota <= 10) THEN SELECT 'Sobresaliente';
        ELSE SELECT 'Nota no valida';
        END IF;
	END //
    DELIMITER ;
    CALL n(48);
    
    /*5. Modifique el procedimiento diseñado en el ejercicio anterior para que tenga un parámetro de entrada, 
    con el valor de la nota en formato numérico y un parámetro de salida, con una cadena de texto indicando la nota correspondiente.*/
    DELIMITER //
    CREATE PROCEDURE nTextoS (in nota real, out nS varchar(100))
    BEGIN
		IF (nota >= 0 AND nota < 5) THEN SET ns = 'Insuficiente';
        ELSEIF (nota >= 5 AND nota < 6) THEN SET ns = 'Aprobado';
        ELSEIF (nota >= 6 AND nota < 7) THEN SET ns = 'Bien';
        ELSEIF (nota >= 7 AND nota < 9) THEN SET ns = 'Notable';
        ELSEIF (nota >= 9 AND nota <= 10) THEN SET ns = 'Sobresaliente';
        ELSE SET ns = 'Nota no valida';
        END IF;
	END //
    DELIMITER ;
    
    CALL nTextoS(4, @nS);
	SELECT @nS;
    
    /*6. Resuelva el procedimiento diseñado en el ejercicio anterior haciendo uso de la estructura de control CASE.*/
    DELIMITER //
    CREATE PROCEDURE nSwitch (in nota real, out ns varchar(100))
    BEGIN
		CASE
			WHEN (nota >= 0 AND nota < 5) THEN SET ns = 'Insuficiente';
            WHEN (nota >= 5 AND nota < 6) THEN SET ns = 'Aprobado';
            WHEN (nota >= 6 AND nota < 7) THEN SET ns = 'Bien';
			WHEN (nota >= 7 AND nota < 9) THEN SET ns = 'Notable';
			WHEN (nota >= 9 AND nota <= 10) THEN SET ns = 'Sobresaliente';
            ELSE SET ns = 'Nota no valida';
        END CASE;
    END
    // DELIMITER ;
    
    CALL nSwitch(4, @nS);
	SELECT @nS;
    
    /*7. Escribe un procedimiento que reciba como parámetro de entrada un valor numérico que represente un día de la semana 
    y que devuelva una cadena de caracteres con el nombre del día de la semana correspondiente. 
    Por ejemplo, para el valor de entrada 1 debería devolver la cadena lunes.*/
    DELIMITER //
    CREATE PROCEDURE LtoS (in numD int, out dia varchar(100))
    BEGIN
		-- DECLARE numDiaToText ENUM ('LUNES', 'MARTES', 'MIERCOLES', 'JUEVES', 'VIERNES','SABADO', 'DOMINGO');
        CASE
			WHEN numD = 1 THEN SET dia = 'LUNES';
            WHEN numD = 2 THEN SET dia = 'MARTES';
            WHEN numD = 3 THEN SET dia = 'MIERCOLES';
            WHEN numD = 4 THEN SET dia = 'JUEVES';
            WHEN numD = 5 THEN SET dia = 'VIERNES';
            WHEN numD = 6 THEN SET dia = 'SABADO';
            WHEN numD = 7 THEN SET dia = 'DOMINGO';
            ELSE SET dia = 'Dia no valido';
		END CASE;
    END
    // DELIMITER ;
    
	CALL LtoS(1, @dia);
	SELECT @dia;