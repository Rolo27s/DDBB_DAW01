-- EJERCICIOS DE PROCEDIMIENTOS 2 
-- Procedimientos con sentencias SQL
/*1. Escribe un procedimiento que reciba el nombre de un país como parámetro de entrada y realice una consulta sobre la tabla cliente para obtener todos los clientes que existen en la tabla de ese país.*/
DELIMITER //

CREATE PROCEDURE PaisCliente (IN pais VARCHAR(50))
BEGIN
    SELECT * FROM cliente WHERE pais = paisBuscado;
END //

DELIMITER ;


/*2. Escribe un procedimiento que reciba como parámetro de entrada una forma de pago, que será una cadena de caracteres 
(Ejemplo: PayPal, Transferencia, etc). Y devuelva como salida el pago de máximo valor realizado para esa forma de pago. 
Deberá hacer uso de la tabla pago de la base de datos jardineria.*/
DELIMITER //

CREATE PROCEDURE ObtenerMaxPagoPorFormaPago(IN fp VARCHAR(50), OUT max_pago DECIMAL(10, 2))
BEGIN
    SELECT MAX(total) INTO max_pago
    FROM pago
    WHERE forma_pago = fp;
END //

DELIMITER ;

CALL ObtenerMaxPagoPorFormaPago ('PayPal', @pagoMax);
SELECT @pagoMax;

/*3. Escribe un procedimiento que reciba como parámetro de entrada una forma de pago, que será una cadena de caracteres 
(Ejemplo: PayPal, Transferencia, etc). Y devuelva como salida los siguientes valores teniendo en cuenta la forma de pago seleccionada como parámetro de entrada:
    • el pago de máximo valor,
    • el pago de mínimo valor,
    • el valor medio de los pagos realizados,
    • la suma de todos los pagos,
    • el número de pagos realizados para esa forma de pago.
Deberá hacer uso de la tabla pago de la base de datos jardineria.*/
DELIMITER //

CREATE PROCEDURE ObtenerInfoPagosPorFormaPago(IN fp VARCHAR(50), 
												OUT max_pago DECIMAL(10, 2), 
												OUT min_pago DECIMAL(10, 2), 
                                                OUT promedio_pago DECIMAL(10, 2), 
                                                OUT suma_pagos DECIMAL(10, 2), 
                                                OUT cantidad_pagos INT)
BEGIN
    SELECT MAX(total) INTO max_pago
    FROM pago
    WHERE forma_pago = fp;
    
    SELECT MIN(total) INTO min_pago
    FROM pago
    WHERE forma_pago = fp;
    
    SELECT AVG(total) INTO promedio_pago
    FROM pago
    WHERE forma_pago = fp;
    
    SELECT SUM(total) INTO suma_pagos
    FROM pago
    WHERE forma_pago = fp;
    
    SELECT COUNT(*) INTO cantidad_pagos
    FROM pago
    WHERE forma_pago = fp;
END //

DELIMITER ;

CALL ObtenerInfoPagosPorFormaPago ('PayPal', @infoPagoMax, @infoPagoMin, @infoPagoAvg, @infoPagoSum, @infoPagoCount);
SELECT @infoPagoMax AS max_pago, @infoPagoMin AS min_pago, @infoPagoAvg AS promedio_pago, @infoPagoSum AS suma_pagos, @infoPagoCount AS cantidad_pagos;

-- Vista que muestra la misma info que el procedimiento
CREATE VIEW detallesPago AS 
SELECT 
	MAX(total) AS pagoMax,
    MIN(total) AS pagoMin,
    AVG(total) AS pagoAvg,
    SUM(total) AS pagoSum,
    COUNT(total) AS pagoCou
FROM pago
WHERE forma_pago = 'PayPal';

/*4. Crea una base de datos llamada procedimientos que contenga una tabla llamada cuadrados. La tabla cuadrados debe tener dos columnas de tipo INT UNSIGNED, una columna llamada número y otra columna llamada cuadrado.
Una vez creada la base de datos y la tabla deberá crear un procedimiento llamado calcular_cuadrados con las siguientes características. 
El procedimiento recibe un parámetro de entrada llamado tope de tipo INT UNSIGNED y calculará el valor de los cuadrados de los primeros números naturales hasta el valor introducido como parámetro. 
El valor de los números y de sus cuadrados deberán ser almacenados en la tabla cuadrados que hemos creado previamente.
Tenga en cuenta que el procedimiento deberá eliminar el contenido actual de la tabla antes de insertar los nuevos valores de los cuadrados que va a calcular.
Utilice un bucle WHILE para resolver el procedimiento.*/
CREATE DATABASE procedimientos CHARSET utf8mb4;
USE procedimientos;

CREATE TABLE cuadrados (
    numero INT UNSIGNED,
    cuadrado INT UNSIGNED
);

DELIMITER //

CREATE PROCEDURE calcular_cuadrados(IN tope INT UNSIGNED)
BEGIN
    -- Variables para almacenar el número y su cuadrado
    DECLARE contador INT UNSIGNED DEFAULT 1;
    DECLARE cuadrado_actual INT UNSIGNED;
    
	-- Eliminar contenido actual de la tabla cuadrados
    TRUNCATE TABLE cuadrados;
    
    -- Bucle WHILE para calcular los cuadrados y almacenarlos en la tabla
    WHILE contador <= tope DO
        SET cuadrado_actual = contador * contador;
        
        -- Insertar el número y su cuadrado en la tabla cuadrados
        INSERT INTO cuadrados(numero, cuadrado) VALUES (contador, cuadrado_actual);
        
        SET contador = contador + 1;
    END WHILE;
END //

DELIMITER ;

CALL calcular_cuadrados(10);

/*5. Utilice un bucle REPEAT para resolver el procedimiento del ejercicio anterior.*/
DELIMITER //

CREATE PROCEDURE calcular_cuadrados_conRepeat(IN tope INT UNSIGNED)
BEGIN
    -- Variables para almacenar el número y su cuadrado
    DECLARE contador INT UNSIGNED DEFAULT 1;
    DECLARE cuadrado_actual INT UNSIGNED;
    
	-- Eliminar contenido actual de la tabla cuadrados
    TRUNCATE TABLE cuadrados;
    
    -- Bucle REPEAT para calcular los cuadrados y almacenarlos en la tabla
    REPEAT
        SET cuadrado_actual = contador * contador;
        
        -- Insertar el número y su cuadrado en la tabla cuadrados
        INSERT INTO cuadrados(numero, cuadrado) VALUES (contador, cuadrado_actual);
        
        SET contador = contador + 1;
    UNTIL contador > tope END REPEAT;
END //

DELIMITER ;

CALL calcular_cuadrados_conRepeat(10);


/*6. Utilice un bucle LOOP para resolver el procedimiento del ejercicio anterior.*/
DELIMITER //

CREATE PROCEDURE calcular_cuadrados_conLoop(IN tope INT UNSIGNED)
BEGIN
    -- Variables para almacenar el número y su cuadrado
    DECLARE contador INT UNSIGNED DEFAULT 1;
    DECLARE cuadrado_actual INT UNSIGNED;
    
    -- Eliminar contenido actual de la tabla cuadrados
    TRUNCATE TABLE cuadrados;
    
    -- Bucle LOOP para calcular los cuadrados y almacenarlos en la tabla
    loop_label: LOOP
        SET cuadrado_actual = contador * contador;
        
        -- Insertar el número y su cuadrado en la tabla cuadrados
        INSERT INTO cuadrados(numero, cuadrado) VALUES (contador, cuadrado_actual);
        
        SET contador = contador + 1;
        
        IF contador > tope THEN
            LEAVE loop_label;
        END IF;
    END LOOP loop_label;
END //

DELIMITER ;

CALL calcular_cuadrados_conLoop(10);


/*7. Crea una base de datos llamada procedimientos que contenga una tabla llamada ejercicio. La tabla debe tener una única columna llamada número y el tipo de dato de esta columna debe ser INT UNSIGNED.
Una vez creada la base de datos y la tabla deberá crear un procedimiento llamado calcular_números con las siguientes características. 
El procedimiento recibe un parámetro de entrada llamado valor_inicial de tipo INT UNSIGNED y deberá almacenar en la tabla ejercicio toda la secuencia de números desde el valor pasado como entrada hasta el 1.
Tenga en cuenta que el procedimiento deberá eliminar el contenido actual de las tablas antes de insertar los nuevos valores.
Utilice un bucle WHILE para resolver el procedimiento.*/
DROP DATABASE IF EXISTS procedimientos;
CREATE DATABASE procedimientos CHARSET utf8mb4;
USE procedimientos;
CREATE TABLE ejercicio (
    numero INT UNSIGNED
);

DELIMITER //

CREATE PROCEDURE calcular_números(IN valor_inicial INT UNSIGNED)
BEGIN
    -- Variable para almacenar el número actual
    DECLARE numero_actual INT UNSIGNED;
    
	-- Eliminar contenido actual de la tabla ejercicio
	DELETE FROM ejercicio;
    
    SET numero_actual = valor_inicial;
    
    -- Bucle WHILE para generar la secuencia de números
    WHILE numero_actual >= 1 DO
        -- Insertar el número en la tabla ejercicio
        INSERT INTO ejercicio(numero) VALUES (numero_actual);
        
        SET numero_actual = numero_actual - 1;
    END WHILE;
END //

DELIMITER ;

CALL calcular_números(21);

/*8. Utilice un bucle REPEAT para resolver el procedimiento del ejercicio anterior.*/
DELIMITER //

CREATE PROCEDURE calcular_números_conRepeat(IN valor_inicial INT UNSIGNED)
BEGIN
    -- Variable para almacenar el número actual
    DECLARE numero_actual INT UNSIGNED;
    
	-- Eliminar contenido actual de la tabla ejercicio
    DELETE FROM ejercicio;
    
    SET numero_actual = valor_inicial;
    
    -- Bucle REPEAT para generar la secuencia de números
    REPEAT
        -- Insertar el número en la tabla ejercicio
        INSERT INTO ejercicio(numero) VALUES (numero_actual);
        
        SET numero_actual = numero_actual - 1;
    UNTIL numero_actual < 1 END REPEAT;
END //

DELIMITER ;

CALL calcular_números_conRepeat(14);

/*9. Utilice un bucle LOOP para resolver el procedimiento del ejercicio anterior.*/
DELIMITER //

CREATE PROCEDURE calcular_números_conLoop(IN valor_inicial INT UNSIGNED)
BEGIN
    -- Variable para almacenar el número actual
    DECLARE numero_actual INT UNSIGNED;
    
	-- Eliminar contenido actual de la tabla ejercicio
    DELETE FROM ejercicio;
    
    SET numero_actual = valor_inicial;
    
    -- Bucle LOOP para generar la secuencia de números
    loop_label: LOOP
        -- Insertar el número en la tabla ejercicio
        INSERT INTO ejercicio(numero) VALUES (numero_actual);
        
        SET numero_actual = numero_actual - 1;
        
        IF numero_actual < 1 THEN
            LEAVE loop_label;
        END IF;
    END LOOP loop_label;
END //

DELIMITER ;

CALL calcular_números_conLoop(17);
