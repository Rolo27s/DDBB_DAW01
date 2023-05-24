-- BD JARDINERIA
-- 1. Escribe un procedimiento que reciba el nombre de un país como parámetro de entrada y realice una consulta sobre la tabla cliente para obtener todos los clientes que existen en la tabla de ese país.
DELIMITER //
DROP PROCEDURE ObtenerClientesPorPais //
CREATE PROCEDURE ObtenerClientesPorPais(IN paisb varchar(50))
	BEGIN
		SELECT * FROM cliente WHERE pais = paisb;
	END //
DELIMITER ;
set @p='usa';
CALL ObtenerClientesPorPais(@p);
CALL ObtenerClientesPorPais('Spain');

-- 2. Escribe un procedimiento que reciba como parámetro de entrada una forma de pago, que será una cadena de caracteres (Ejemplo: PayPal, Transferencia, etc). Y devuelva como salida el pago de máximo valor realizado para esa forma de pago. Deberá hacer uso de la tabla pago de la base de datos jardineria.
DELIMITER //
DROP PROCEDURE maxpago //
CREATE PROCEDURE maxpago(IN tipopago varchar(50))
	BEGIN
		SELECT max(total) maximo_pago FROM pago WHERE forma_pago = tipopago;
	END //
DELIMITER ;

CALL maxpago('Paypal');

-- 3. Escribe un procedimiento que reciba como parámetro de entrada una forma de pago, que será una cadena de caracteres (Ejemplo: PayPal, Transferencia, etc). Y devuelva como salida los siguientes valores teniendo en cuenta la forma de pago seleccionada como parámetro de entrada:
-- 	el pago de máximo valor,
-- 	el pago de mínimo valor,
-- 	el valor medio de los pagos realizados,
-- 	la suma de todos los pagos,
-- 	el número de pagos realizados para esa forma de pago.
-- Deberá hacer uso de la tabla pago de la base de datos jardineria.

DELIMITER //
DROP PROCEDURE IF EXISTS pagos //
CREATE PROCEDURE pagos(IN tipopago varchar(50))
	BEGIN
		SELECT max(total) maximo_pago,min(total) minimo_pago,avg(total) media_pago,sum(total) suma_pago,count(total) num_de_pagos  FROM pago WHERE forma_pago = tipopago;
        
	END //
DELIMITER ;

CALL pagos('Paypal');

-- 4. Crea una base de datos llamada procedimientos que contenga una tabla llamada cuadrados. La tabla cuadrados debe tener dos columnas de tipo INT UNSIGNED, una columna llamada número y otra columna llamada cuadrado.
-- Una vez creada la base de datos y la tabla deberá crear un procedimiento llamado calcular_cuadrados con las siguientes características. El procedimiento recibe un parámetro de entrada llamado tope de tipo INT UNSIGNED y calculará el valor de los cuadrados de los primeros números naturales hasta el valor introducido como parámetro. El valor de los números y de sus cuadrados deberán ser almacenados en la tabla cuadrados que hemos creado previamente.
-- Tenga en cuenta que el procedimiento deberá eliminar el contenido actual de la tabla antes de insertar los nuevos valores de los cuadrados que va a calcular.
-- Utilice un bucle WHILE para resolver el procedimiento.

CREATE DATABASE procedimientos;
USE procedimientos;
CREATE TABLE cuadrados (
  numero INT UNSIGNED,
  cuadrado INT UNSIGNED
);
DELIMITER //
CREATE PROCEDURE calcular_cuadrados (IN tope INT UNSIGNED)
BEGIN
  DECLARE i INT UNSIGNED;
  DECLARE cuadrado INT UNSIGNED;
  DELETE FROM cuadrados;

  SET i = 1;

  WHILE i <= tope DO
    SET cuadrado = i * i;
    INSERT INTO cuadrados (numero, cuadrado) VALUES (i, cuadrado);
    SET i = i + 1;
  END WHILE;
END//
DELIMITER ;
CALL calcular_cuadrados(10);
SELECT * FROM cuadrados;
-- 5. Utilice un bucle REPEAT para resolver el procedimiento del ejercicio anterior.
DELIMITER //
DROP PROCEDURE calcular_cuadrados//
CREATE PROCEDURE calcular_cuadrados (IN tope INT UNSIGNED)
BEGIN
  DECLARE i INT UNSIGNED;
  DECLARE cuadrado INT UNSIGNED;
  DELETE FROM cuadrados;

  SET i = 1;

 REPEAT
    SET cuadrado = i * i;
    INSERT INTO cuadrados (numero, cuadrado) VALUES (i, cuadrado);
    SET i = i + 1;
  UNTIL i > tope 
  END REPEAT;
END//
delimiter ;
CALL calcular_cuadrados(10);
SELECT * FROM cuadrados;
-- 6. Utilice un bucle LOOP para resolver el procedimiento del ejercicio anterior.
DELIMITER //
DROP PROCEDURE IF EXISTS calcular_cuadrados//
CREATE PROCEDURE calcular_cuadrados (IN tope INT UNSIGNED)
BEGIN
  DECLARE i INT UNSIGNED;
  DECLARE cuadrado INT UNSIGNED;
  DELETE FROM cuadrados;

  SET i = 1;

  bucle:LOOP
    SET cuadrado = i * i;
    INSERT INTO cuadrados (numero, cuadrado) VALUES (i, cuadrado);
    SET i = i + 1;
    IF i > tope THEN
      LEAVE bucle;
    END IF;
  END LOOP;
END//
delimiter ;
CALL calcular_cuadrados(5);
SELECT * FROM cuadrados;

-- 7. Crea una base de datos llamada procedimientos que contenga una tabla llamada ejercicio. La tabla debe tener una única columna llamada número y el tipo de dato de esta columna debe ser INT UNSIGNED.
-- Una vez creada la base de datos y la tabla deberá crear un procedimiento llamado calcular_números con las siguientes características. El procedimiento recibe un parámetro de entrada llamado valor_inicial de tipo INT UNSIGNED y deberá almacenar en la tabla ejercicio toda la secuencia de números desde el valor pasado como entrada hasta el 1.
-- Tenga en cuenta que el procedimiento deberá eliminar el contenido actual de las tablas antes de insertar los nuevos valores.
-- Utilice un bucle WHILE para resolver el procedimiento.
CREATE TABLE ejercicio (
  numero INT UNSIGNED
);
DELIMITER //
DROP PROCEDURE IF EXISTS calcular_numeros//
CREATE PROCEDURE calcular_numeros(IN valor_inicial INT UNSIGNED)
BEGIN
 DECLARE num INT UNSIGNED;
  DELETE FROM ejercicio;
 
  SET num = valor_inicial;
  WHILE num >= 1 DO
    INSERT INTO ejercicio (numero) VALUES (num);
    SET num = num - 1;
  END WHILE;
END//
DELIMITER ;

CALL calcular_numeros(10);
SELECT * FROM ejercicio;

-- 8. Utilice un bucle REPEAT para resolver el procedimiento del ejercicio anterior.
DELIMITER //
DROP PROCEDURE IF EXISTS calcular_numeros//
CREATE PROCEDURE calcular_numeros(IN valor_inicial INT UNSIGNED)
BEGIN
 DECLARE num INT UNSIGNED;
  DELETE FROM ejercicio;
 
  SET num = valor_inicial;
  REPEAT
    INSERT INTO ejercicio (numero) VALUES (num);
    SET num = num - 1;
  UNTIL num=0
  end repeat;

END//
DELIMITER ;

CALL calcular_numeros(5);
SELECT * FROM ejercicio;
-- 9. Utilice un bucle LOOP para resolver el procedimiento del ejercicio anterior.
DELIMITER //
DROP PROCEDURE IF EXISTS calcular_numeros//
CREATE PROCEDURE calcular_numeros(IN valor_inicial INT UNSIGNED)
BEGIN
 DECLARE num INT UNSIGNED;
  DELETE FROM ejercicio;
 
  SET num = valor_inicial;
  bucle:LOOP
    INSERT INTO ejercicio (numero) VALUES (num);
    SET num = num - 1;
	IF num = 0 THEN
      LEAVE bucle;
    END IF;
  END LOOP;

END//
DELIMITER ;

CALL calcular_numeros(5);
SELECT * FROM ejercicio;
-- 10. Realice lo mismo pero metiendo el resultado en un solo campo separados los valores con un espacio en blanco.
CREATE TABLE ejerciciobis (
  secuencia VARCHAR(200)
);
DELIMITER //
DROP PROCEDURE IF EXISTS calcular_numeros//
CREATE PROCEDURE calcular_numeros(IN valor_inicial INT UNSIGNED)
BEGIN
 DECLARE num INT UNSIGNED;
 DECLARE secu VARCHAR(200);
 set secu='';
  DELETE FROM ejerciciobis;
 
  SET num = valor_inicial;
  WHILE num >= 1 DO
    set  secu=concat_ws(' ',secu,num);
    SET num = num - 1;
  END WHILE;
  INSERT INTO ejerciciobis (secuencia) VALUES (secu);
END//
DELIMITER ;

CALL calcular_numeros(25);
SELECT * FROM ejerciciobis;
