-- EXAMEN BD 24-05-2023 FRANCISCO JOSE RODRIGUEZ LOPEZ
/* 1. (2 ptos1. (2 ptos) Haz un procedimiento que borre el pago más antiguo de la tabla
pago. Si la foma de pago es PayPal que lo borre definitivamente, si es cualquier otra que lo
deshaga. */

DROP PROCEDURE IF EXISTS eliminar_pago_antiguo;
DELIMITER //

START TRANSACTION;
CREATE PROCEDURE eliminar_pago_antiguo()

BEGIN
    DECLARE id_p VARCHAR(50);
    DECLARE forma_p VARCHAR(50);
    DECLARE fecha_p DATE;
    
    SELECT id_transaccion, forma_pago, fecha_pago INTO id_p, forma_p, fecha_p
    FROM pago
    ORDER BY fecha_pago ASC
    LIMIT 1;
    
    -- Si es Paypal lo guardo
    IF forma_p = 'PayPal' THEN
        DELETE FROM pago WHERE id_transaccion = id_p;
        COMMIT;
   -- Si no vuelvo     
   ELSE 
		ROLLBACK;
    END IF;

END //

DELIMITER ;

CALL eliminar_pago_antiguo();



/* 2. (2 ptos) Escriba una función llamada cantidad_total_de_productos_vendidos que
reciba como parámetro de entrada el código de un producto y devuelva la cantidad total de
productos que se han vendido con ese código. */

DROP FUNCTION IF EXISTS cantidad_total_de_productos_vendidos;
DELIMITER //

CREATE FUNCTION cantidad_total_de_productos_vendidos(v_codigo_producto VARCHAR(50)) RETURNS INT READS SQL DATA
BEGIN
    DECLARE total INT;
    
    -- Calcular la cantidad total de productos vendidos para el código de producto dado
    SELECT SUM(cantidad) INTO total
    FROM detalle_pedido
    WHERE codigo_producto = v_codigo_producto;
    
    -- Retornar la cantidad total de productos vendidos
    RETURN total;
END //

DELIMITER ;

SELECT cantidad_total_de_productos_vendidos('OR-247') AS total_vendido;

/* 3. (3 ptos) Crea una tabla que se llame productos_vendidos que tenga las siguientes
columnas:
● id (entero sin signo, auto incremento y clave primaria)
● codigo_producto (cadena de caracteres)
● cantidad_total (entero)
*/

CREATE TABLE productos_vendidos (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  codigo_producto VARCHAR(50),
  cantidad_total decimal(15,2)
);

/*
Escriba un procedimiento llamado estadísticas_productos_vendidos que para cada uno
de los productos de la tabla producto calcule la cantidad total de unidades que se han
vendido y almacene esta información en la tabla productos_vendidos.
El procedimiento tendrá que realizar las siguientes acciones:
● Borrar el contenido de la tabla productos_vendidos.
● Recorrer cada uno de los productos de la tabla producto. Será necesario usar un
cursor.
● Calcular la cantidad total de productos vendidos. En este paso será necesario utilizar
la función cantidad_total_de_productos_vendidos desarrollada en el ejercicio 2.
● Insertar en la tabla productos_vendidos los valores del código de producto y la
cantidad total de unidades que se han vendido para ese producto en concreto.
● De los que no se haya vendido nada deben aparecer como 0, no NULL */

DROP PROCEDURE IF EXISTS estadísticas_productos_vendidos;

DELIMITER //

CREATE PROCEDURE estadísticas_productos_vendidos()
BEGIN
  DECLARE fin INT DEFAULT FALSE;
  DECLARE v_cod_prod VARCHAR(50);
  DECLARE total_vendido decimal(15,2);
  
  DECLARE cur CURSOR FOR SELECT codigo_producto FROM producto;
  DECLARE CONTINUE HANDLER FOR NOT FOUND SET fin = TRUE;
  
  DELETE FROM productos_vendidos;

  OPEN cur;
  
  Mi_loop: LOOP
    FETCH cur INTO v_cod_prod;
    
    IF fin THEN
      LEAVE Mi_loop;
    END IF;
    
    SET total_vendido = cantidad_total_de_productos_vendidos(v_cod_prod);
        
    INSERT INTO productos_vendidos (codigo_producto, cantidad_total)
    VALUES (v_cod_prod, IFNULL(total_vendido, 0));
  END LOOP;
  
  CLOSE cur;

END //

DELIMITER ;

CALL estadísticas_productos_vendidos();

/* 4. (3 ptos) Crea una tabla que se llame notificaciones que tenga las siguientes
columnas:
● id (entero sin signo, autoincremento y clave primaria)
● fecha_hora: marca de tiempo con el instante del pago (fecha y hora )
● total: el valor del pago (real )
● codigo_cliente: código del cliente que realiza el pago (entero )*/

CREATE TABLE notificaciones (
  id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  fecha_hora TIMESTAMP,
  total DECIMAL(10, 2),
  codigo_cliente INT
);

/*Escriba un trigger que nos permita llevar un control de los pagos de PayPal que van
realizando los clientes. Los detalles de implementación son los siguientes:
● Nombre: trigger_notificar_pago_PayPal
● Se ejecuta sobre la tabla pago.
● Se ejecuta después de hacer la inserción de un pago.
EXAMEN BD 1º DAW PROGRAMACION BD 24/05/2023
● Cada vez que un cliente realice un pago con Paypal ( es decir, se hace una inserción
en la tabla pago y la forma de pago es de “Paypal”) el trigger deberá insertar un
nuevo registro en una tabla llamada notificaciones.
Escriba algunas sentencias SQL para comprobar que el trigger funciona correctamente. */

DROP TRIGGER IF EXISTS trigger_notificar_pago_PayPal;

DELIMITER //

CREATE TRIGGER trigger_notificar_pago_PayPal AFTER INSERT ON pago FOR EACH ROW
BEGIN
  IF NEW.forma_pago = 'Paypal' THEN
    INSERT INTO notificaciones (fecha_hora, total, codigo_cliente)
    VALUES (NOW(), NEW.total, NEW.codigo_cliente);
  END IF;
END //

DELIMITER ;

-- Algunos nuevos registros
INSERT INTO pago VALUES (14, 'PayPal', 'ak-std-300002', '2018-12-10', '2004.00');
INSERT INTO pago VALUES (3, 'PayPal', 'ak-std-001002', '2021-02-10', '1034.00');
INSERT INTO pago VALUES (3, 'PayPal', 'ak-std-020003', '2021-02-11', '1434.00');

-- Aqui ya veo lo que guarda el trigger
SELECT * FROM notificaciones;