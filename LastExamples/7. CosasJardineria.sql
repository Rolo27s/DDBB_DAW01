-- Pruebas de Procedimientos, funciones, cursores, triggers y errores en Jardineria
-- Esta función calcula el precio total de un pedido basado en los productos solicitados:
DELIMITER //

CREATE FUNCTION calcular_precio_total(pedido_id INT)
RETURNS DECIMAL(15, 2) DETERMINISTIC
BEGIN
    DECLARE total DECIMAL(15, 2);
    
    SELECT SUM(dp.precio_unidad * dp.cantidad) INTO total
    FROM detalle_pedido dp
    JOIN pedido p ON dp.codigo_pedido = p.codigo_pedido
    WHERE dp.codigo_pedido = pedido_id;
    
    RETURN total;
END //

DELIMITER ;

SELECT calcular_precio_total(2) AS precio_total_pedido;

DELIMITER //




-- Procedimiento almacenado que toma como entrada la categoría de productos (gama) y devuelve los valores mínimos, 
-- máximos y promedio de precios para esa categoría de productos en la tabla "producto" de la base de datos de jardinería:
CREATE PROCEDURE obtener_estadisticas_producto(IN gama_producto VARCHAR(50), 
OUT min_precio DECIMAL(15, 2), OUT max_precio DECIMAL(15, 2), OUT avg_precio DECIMAL(15, 2))
BEGIN
    SELECT MIN(precio_venta) INTO min_precio
    FROM producto
    WHERE gama = gama_producto;
    
    SELECT MAX(precio_venta) INTO max_precio
    FROM producto
    WHERE gama = gama_producto;
    
    SELECT AVG(precio_venta) INTO avg_precio
    FROM producto
    WHERE gama = gama_producto;
END //

DELIMITER ;

CALL obtener_estadisticas_producto('Frutales', @min_precio, @max_precio, @avg_precio);

SELECT @min_precio AS minimo_precio, @max_precio AS maximo_precio, @avg_precio AS promedio_precio;

-- Misma solucion, pero encapsula a la anterior
DELIMITER //

CREATE PROCEDURE obtener_estadisticas_jardineria(IN gama_producto VARCHAR(50))
BEGIN
    DECLARE min_precio DECIMAL(15, 2);
    DECLARE max_precio DECIMAL(15, 2);
    DECLARE avg_precio DECIMAL(15, 2);
    
    CALL obtener_estadisticas_producto(gama_producto, min_precio, max_precio, avg_precio);
    
    SELECT min_precio AS minimo_precio, max_precio AS maximo_precio, avg_precio AS promedio_precio;
END //

DELIMITER ;

CALL obtener_estadisticas_jardineria('Frutales');



-- CURSOR
DELIMITER //

CREATE PROCEDURE procesar_productos()
BEGIN
    DECLARE done INT DEFAULT FALSE;
    DECLARE codigo_producto VARCHAR(15);
    DECLARE nombre_producto VARCHAR(70);
    DECLARE gama_producto VARCHAR(50);
    
    DECLARE cur CURSOR FOR SELECT codigo_producto, nombre, gama FROM producto;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;
    
    OPEN cur;
    
    read_loop: LOOP
        FETCH cur INTO codigo_producto, nombre_producto, gama_producto;
        
        IF done THEN
            LEAVE read_loop;
        END IF;
        
        -- Realiza las operaciones o lógica deseada con los datos del producto
        -- Ejemplo:
        -- INSERT INTO otra_tabla (codigo_producto, nombre_producto, gama_producto) VALUES (codigo_producto, nombre_producto, gama_producto);
        
    END LOOP;
    
    CLOSE cur;
    
    -- Realiza cualquier otra operación necesaria después de procesar los productos
    
END //

DELIMITER ;



-- Trigger
-- crear un trigger que se active después de insertar un nuevo registro en la tabla "producto" y que actualice automáticamente 
-- el campo "cantidad_total" en la tabla "gama_producto" con la suma de las cantidades de productos en esa gama.
DELIMITER //

CREATE TRIGGER actualizar_cantidad_total
AFTER INSERT ON producto
FOR EACH ROW
BEGIN
    UPDATE gama_producto
    SET cantidad_total = (
        SELECT SUM(cantidad_en_stock)
        FROM producto
        WHERE gama = NEW.gama
    )
    WHERE gama = NEW.gama;
END //

DELIMITER ;



-- Ejemplo de control de excepciones
DELIMITER //

CREATE PROCEDURE ejemplo_control_excepciones()
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        -- Manejar la excepción
        GET DIAGNOSTICS CONDITION 1 @sqlstate = RETURNED_SQLSTATE, @errno = MYSQL_ERRNO, @text = MESSAGE_TEXT;

        -- Mostrar información del error
        SELECT CONCAT('Error: ', @errno) AS Error, @text AS Message;
        
        -- Puedes realizar otras acciones como registrar el error en una tabla de registro de errores

        -- Signalizar la excepción para que sea capturada en la aplicación
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = @text;
    END;

    -- Aquí va el código de tu procedimiento
    -- Puedes generar una excepción a propósito para probar el control de excepciones
    -- Ejemplo: SELECT 1 / 0;

END //

DELIMITER ;
