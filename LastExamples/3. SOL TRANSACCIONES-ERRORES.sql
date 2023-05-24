-- ---------------------------TRANSACCIONES ERRORES--------------------------------------
/*1.	Crea una base de datos llamada test5 que contenga una tabla llamada alumno. La tabla debe tener cuatro columnas:
●	id: entero sin signo (clave primaria).
●	nombre: cadena de 50 caracteres.
●	apellido1: cadena de 50 caracteres.
●	apellido2: cadena de 50 caracteres.
Una vez creada la base de datos y la tabla deberá crear un procedimiento llamado insertar_alumno con las siguientes características. El procedimiento recibe cuatro parámetros de entrada (id, nombre, apellido1, apellido2) y los insertará en la tabla alumno. El procedimiento devolverá como salida un parámetro llamado error que tendrá un valor igual a 0 si la operación se ha podido realizar con éxito y un valor igual a 1 en caso contrario.
Deberá manejar los errores que puedan ocurrir cuando se intenta insertar una fila que contiene una clave primaria repetida.
*/
-- Crear la base de datos
CREATE DATABASE test5;

USE test5;

CREATE TABLE alumno (
  id INT UNSIGNED PRIMARY KEY,
  nombre VARCHAR(50),
  apellido1 VARCHAR(50),
  apellido2 VARCHAR(50)
);

DROP PROCEDURE IF EXISTS insertar_alumno;
DELIMITER //
CREATE PROCEDURE insertar_alumno(IN v_id INT UNSIGNED,IN v_nombre VARCHAR(50),IN v_apellido1 VARCHAR(50), IN v_apellido2 VARCHAR(50),OUT v_error INT)

BEGIN
  DECLARE CONTINUE HANDLER FOR 1062 SET v_error = 1;
  SET v_error = 0;
  INSERT INTO alumno (id, nombre, apellido1, apellido2)
  VALUES (v_id, v_nombre, v_apellido1, v_apellido2);
END //
DELIMITER ;

CALL insertar_alumno(1, 'PEPE', 'PEREZ', 'GORRIÓN', @error);
SELECT @error;
CALL insertar_alumno(1, 'MARÍA', 'FLORES', 'JAEN', @error);


/*2.	Crea una base de datos llamada cine que contenga dos tablas con las siguientes columnas.
Tabla cuentas:
●	id_cuenta: entero sin signo (clave primaria).
●	saldo: real sin signo.
Tabla entradas:
●	id_butaca: entero sin signo (clave primaria).
●	nif: cadena de 9 caracteres.
Una vez creada la base de datos y las tablas deberá crear un procedimiento llamado comprar_entrada con las siguientes características. El procedimiento recibe 3 parámetros de entrada (nif, id_cuenta, id_butaca) y devolverá como salida un parámetro llamado error que tendrá un valor igual a 0 si la compra de la entrada se ha podido realizar con éxito y un valor igual a 1 en caso contrario.
El procedimiento de compra realiza los siguientes pasos:
●	Inicia una transacción.
●	Actualiza la columna saldo de la tabla cuentas cobrando 5 euros a la cuenta con el id_cuenta adecuado.
●	Inserta una una fila en la tabla entradas indicando la butaca (id_butaca) que acaba de comprar el usuario (nif).
●	Comprueba si ha ocurrido algún error en las operaciones anteriores. Si no ocurre ningún error entonces aplica un COMMIT a la transacción y si ha ocurrido algún error aplica un ROLLBACK.
Deberá manejar los siguientes errores que puedan ocurrir durante el proceso.
●	ERROR 1264 (Out of range value)
●	ERROR 1062 (Duplicate entry for PRIMARY KEY)*/


CREATE  DATABASE IF NOT EXISTS cine1  CHARSET utf8mb4 ;
USE cine1;
CREATE TABLE cuentas (
  id_cuenta INT UNSIGNED PRIMARY KEY,
  saldo DECIMAL(10, 2) UNSIGNED
);

CREATE TABLE entradas (
  id_butaca INT UNSIGNED PRIMARY KEY,
  nif VARCHAR(9)
);

DROP procedure if exists comprar_entrada;
DELIMITER //
CREATE PROCEDURE comprar_entrada(IN v_nif VARCHAR(9),IN v_id_cuenta INT UNSIGNED,IN v_id_butaca INT UNSIGNED,OUT v_error INT
)
BEGIN
  DECLARE EXIT HANDLER FOR 1264,1062 -- tb se puede poner sqlexception, cualquier error excepto NOT FOUND
  BEGIN
    ROLLBACK;
    SET v_error = 1;
  END;

  START TRANSACTION;

  SET v_error = 0;

  -- Actualizar el saldo de la cuenta
  UPDATE cuentas   SET saldo = saldo - 5   WHERE id_cuenta = v_id_cuenta;

  -- Insertar una fila en la tabla entradas
  INSERT INTO entradas (id_butaca, nif)   VALUES (v_id_butaca, v_nif);

  IF v_error = 0 THEN
    COMMIT;
  ELSE
    ROLLBACK;
  END IF;
END //
DELIMITER ;

INSERT INTO cuentas VALUES (1,50),(2,30),(3,0);
INSERT INTO entradas VALUES (1,'123456789'),(2,'234567890'),(3,'356874126');
CALL comprar_entrada('123456789', 1, 4, @error);
SELECT @error;
CALL comprar_entrada('234567890', 1, 1, @error);-- pruebo entrada duplicada de butaca
CALL comprar_entrada('356874126', 3, 5, @error);-- pruebo fuera de rango
