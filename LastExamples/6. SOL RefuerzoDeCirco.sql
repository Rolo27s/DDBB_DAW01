-- ---------------REFUERZO BD CIRCO------------------------------------------------------
-- Ejercicio 1: Crea un procedimiento de nombre artistas_getAnimalesPorNif que devuelva los animales que cuida un artista. Llevará como parámetro el nif de artista.
DROP PROCEDURE IF EXISTS artistas_getAnimalesPorNif;
DELIMITER $$

CREATE PROCEDURE artistas_getAnimalesPorNif(p_nif char(9))
COMMENT 'Devuelva los animales que cuida un artista. Llevará como parámetro el nif de artista.'
BEGIN
	SELECT distinct ANIMALES.*
    FROM ANIMALES INNER JOIN ANIMALES_ARTISTAS
					ON (ANIMALES.nombre = ANIMALES_ARTISTAS.nombre_animal)
	WHERE ANIMALES_ARTISTAS.nif_artista = p_nif
    ORDER BY nombre;            
END$$
DELIMITER ;
CALL artistas_getAnimalesPorNif('11111111A');
CALL artistas_getAnimalesPorNif('22222222B');

SET @nifBuscar='44444444D';
CALL artistas_getAnimalesPorNif(@nifBuscar);

-- Ejercicio 2
-- Crea un procedimiento de nombre pistas_getAforo al que se le pase el nombre de una pista y devuelve en forma de parámetro de salida su aforo.
DROP PROCEDURE IF EXISTS pistas_getAforo;
DELIMITER $$
CREATE PROCEDURE pistas_getAforo(p_nombre varchar(50), OUT p_aforo smallint)
    COMMENT 'Devuelve en p_aforo el aforo de la pista indicada por p_nombre'
BEGIN

    SELECT aforo
    INTO p_aforo
    FROM PISTAS
    WHERE nombre = p_nombre;

END$$
DELIMITER ;

CALL pistas_getAforo('LATERAL1',@aforo);	
SELECT @aforo;

-- Ejercicio 3
-- Crea un procedimiento de nombre animales_getNombreAforo al que se le pase el nombre de un animal y devuelva, empleando un parámetro de salida y haciendo uso del procedimiento creado en el ejercicio 2, de una cadena con el formato: NombreAnimal:peso:pista:aforo
-- Pista: Emplea la función CONCAT

DROP PROCEDURE IF EXISTS animales_getNombreAforo;
DELIMITER $$
CREATE PROCEDURE animales_getNombreAforo(p_nombre varchar(50), OUT p_cadena varchar(150))		
    COMMENT 'Devuelve en p_cadena una cadena con el formato: NombreAnimal:peso:pista:aforo en base al nombre del animal p_nombre'
BEGIN
    DECLARE v_peso float;		
    DECLARE v_aforo smallint;
    DECLARE v_nombrePista varchar(50);
    
    SELECT nombre_pista,peso
    INTO v_nombrePista,v_peso
    FROM ANIMALES
    WHERE nombre = p_nombre;
    
    CALL pistas_getAforo(v_nombrePista,v_aforo);		-- El método devuelve en v_aforo el aforo de la pista
    
    SET p_cadena = CONCAT(p_nombre,':',v_peso,':',v_nombrePista,':',v_aforo);

END$$
DELIMITER ;

CALL animales_getNombreAforo('Leo',@datos);	
SELECT @datos;

-- Ejercicio 4

-- Crea un procedimiento de nombre pistas_addAforo al que se le envíe como parámetros el nombre de la pista y una cantidad que representa el incremento del aforo.
-- El procedimiento debe devolver en el mismo parámetro el nuevo aforo de la pista.

DROP PROCEDURE IF EXISTS pistas_addAforo;
DELIMITER $$
CREATE PROCEDURE pistas_addAforo(p_nombre varchar(50),INOUT p_incAforo smallint)		
    COMMENT 'Devuelve en p_incAforo el nuevo aforo incrementado en la pista p_nombre'
BEGIN
	UPDATE PISTAS
    SET aforo = aforo + p_incAforo
    WHERE nombre = p_nombre;
    
    SELECT aforo
    INTO p_incAforo
    FROM PISTAS
    WHERE nombre = p_nombre;

END$$
DELIMITER ;

SET @dato = 50;	-- Incremento de aforo
CALL pistas_addAforo('LATERAL1',@dato);	
SELECT @dato;

-- Ejercicio 5
-- Crea una función de nombre animales_getEstadoPorAnhos que devuelva la cadena:

/*Si tipo = León
anhos < 2: 'JOVEN'
anhos >=2 y <=5: 'MADURO'
anhos > 5: 'VIEJO'
Cualquier otro tipo:
anhos < 1: 'JOVEN'
anhos >=1 y <=3: 'MADURO'
anhos > 3: 'VIEJO'*/
-- Llama a la función para mostrar el estado por años de cada uno de los animales del CIRCO.

DROP FUNCTION IF EXISTS animales_getEstadoPorAnhos;
DELIMITER $$
CREATE FUNCTION animales_getEstadoPorAnhos (p_tipo varchar(9), p_anhos tinyint)	-- El tipo se corresponde con el de la tabla
RETURNS CHAR(6)	DETERMINISTIC NO SQL
    COMMENT 'Devuelve una cadena indicativa de la edad en función de la edad y tipo de animal'
BEGIN
	DECLARE v_cadena char(6) default '';

	IF (p_tipo='León') THEN
		CASE 
			WHEN p_anhos < 2 THEN SET v_cadena = 'JOVEN';
			WHEN p_anhos >= 2 AND p_anhos <= 5 THEN SET v_cadena = 'MADURO';
			WHEN p_anhos > 5 THEN SET v_cadena = 'VIEJO';
		END CASE;
    ELSE
		CASE
			WHEN p_anhos < 1 THEN SET v_cadena = 'JOVEN';
			WHEN p_anhos >= 1 AND p_anhos <= 3 THEN SET v_cadena = 'MADURO';
			WHEN p_anhos > 3 THEN SET v_cadena = 'VIEJO';
		END CASE;
    END IF;

	RETURN v_cadena;
END $$
DELIMITER ;
-- Ejemplo de uso:

SELECT *,animales_getEstadoPorAnhos(tipo,anhos) as estado
FROM ANIMALES
ORDER BY nombre;

-- Ejercicio 6
-- Crea una función de nombre pistas_getDiferenciaAforo al que se le pase el nuevo aforo de una pista y devuelva la diferencia entre el aforo nuevo y el aforo anterior.

/*Si la diferencia < 100 debe devolver la cadena 'PEQUEÑA menor que 100'
Si la diferencia está entre 100 y 500 debe devolver la cadena 'REGULAR entre 100 y 500'
Si la diferencia > 500 debe devolver la cadena 'ABISMAL mayor que 500'
Por ejemplo: PISTA1, 150 => Si la pista tiene actualmente un aforo de 100, debe devolver 150-100 = 50 => PEQUEÑA menor que 100
Si la pista no existe debe devolver null.

Muestra los datos de todas las pistas junto la diferencia del aforo empleando la función anterior y enviando un aforo de 600.
*/

DROP FUNCTION IF EXISTS pistas_getDiferenciaAforo;

DELIMITER $$
CREATE FUNCTION pistas_getDiferenciaAforo (p_nombrePista varchar(50), p_aforo smallint)	-- El tipo se corresponde con el de la tabla
RETURNS varchar(100) READS SQL DATA 
    COMMENT 'Devuelve la diferencia entre el nuevo aforo y el antiguo'
BEGIN
    DECLARE v_aforoAntiguo smallint default -1;
    DECLARE v_cadena varchar(100);
    DECLARE v_diferenciaAforo smallint default 0;

    SELECT aforo
    INTO v_aforoAntiguo
    FROM PISTAS
    WHERE nombre = p_nombrePista;
    
    IF (v_aforoAntiguo=-1) THEN	-- La pista no existe
        RETURN v_cadena;
    END IF;
    
    SET v_diferenciaAforo = p_aforo-v_aforoAntiguo;
    CASE 
        WHEN v_diferenciaAforo < 100 THEN 
            SET v_cadena = 'PEQUEÑA menor que 100';
        WHEN v_diferenciaAforo >= 100 AND v_diferenciaAforo <= 500  THEN 
            SET v_cadena = 'REGULAR entre 100 y 500';
        WHEN v_diferenciaAforo > 500 THEN 
        SET v_cadena = 'ABISMAL mayor que 500';
    END CASE;
    
   RETURN v_cadena;

END $$
DELIMITER ;
-- Ejemplo de uso:

SELECT *,pistas_getDiferenciaAforo(nombre,600) as estado
FROM PISTAS
ORDER BY nombre;

-- EJERCICIO 7 Mediante un trigger haz que no se pueda añadir un nuevo animal si el tipo es 'León' y el número de años es mayor que 20.

-- En caso de no cumplirse la condición lanzará una excepción.
DROP TRIGGER IF EXISTS animales_checkAdd_INSERT;
DELIMITER $$
CREATE TRIGGER animales_checkAdd_INSERT BEFORE INSERT ON ANIMALES FOR EACH ROW
BEGIN
	IF (NEW.tipo='León' AND NEW.anhos>20) THEN
		SIGNAL SQLSTATE '45000' SET message_text='El tipo león no puede tener más de 20 años';
    END IF;
END $$
DELIMITER ;

-- Comprobarlo.
INSERT INTO `CIRCO`.`ANIMALES` (`nombre`,`tipo`,`anhos`,`peso`,`estatura`,`nombre_atraccion`,`nombre_pista`)
VALUES ('El comehombres','León',25,120,1.2,'El gran felino','LATERAL1');

-- EJERCICIO 8 TRIGGER
/*/Haz todo lo necesario para que el campo ganancias de la tabla ATRACCIONES se actualice cuando se añadan, borren o modifiquen datos en la tabla ATRACCION_DIA.

Solución: EL proceso para crear un trigger como comenté antes es:
Identificar la tabla sobre la que vamos a crear el trigger => ATRACCIONES
Identificar la operación sobre la que se va a crear el trigger => INSERT, UPDATE, DELETE
Identificar si queremos que el trigger se ejecuta antes o después: Queremos actualizar el campo ganancias una vez se ha actualizado la fila ATRACCION_DIA por lo tanto el trigger tiene que ser AFTER.
Para acceder a los datos que estamos queriendo AÑADIR, debemos de hacer uso de la tabla NEW.
Para acceder a los datos que estamos queriendo BORRAR, debemos de hacer uso de la tabla OLD.
Para acceder a los datos que estamos queriendo MODIFICAR, debemos de hacer uso de la tabla OLD para acceder a los viejos y NEW para acceder a los nuevos.*/

USE CIRCO;
DROP TRIGGER IF EXISTS atracciones_actualizarGananciasTotales_INSERT;
DELIMITER $$
CREATE TRIGGER atracciones_actualizarGananciasTotales_INSERT AFTER INSERT ON ATRACCION_DIA FOR EACH ROW
BEGIN
    DECLARE v_fecha date;

    SELECT IFNULL(fecha_inicio,CURDATE())
    INTO v_fecha
    FROM ATRACCIONES
    WHERE nombre = NEW.nombre_atraccion;
    
    UPDATE ATRACCIONES
    SET ganancias = IFNULL(ganancias,0) + NEW.ganancias,
        fecha_inicio = v_fecha
    WHERE nombre = NEW.nombre_atraccion;
    
END $$
DELIMITER ;
USE CIRCO;
DROP TRIGGER IF EXISTS atracciones_actualizarGananciasTotales_UPDATE;
DELIMITER $$
CREATE TRIGGER atracciones_actualizarGananciasTotales_UPDATE AFTER UPDATE ON ATRACCION_DIA FOR EACH ROW
BEGIN
    UPDATE ATRACCIONES
    SET ganancias = ganancias + NEW.ganancias - OLD.ganancias
    WHERE nombre = OLD.nombre_atraccion;
    
END $$
DELIMITER ;
USE CIRCO;
DROP TRIGGER IF EXISTS atracciones_actualizarGananciasTotales_DELETE;
DELIMITER $$
CREATE TRIGGER atracciones_actualizarGananciasTotales_DELETE AFTER DELETE ON ATRACCION_DIA FOR EACH ROW
BEGIN
    UPDATE ATRACCIONES
    SET ganancias = ganancias - OLD.ganancias
    WHERE nombre = OLD.nombre_atraccion;
    
END $$
DELIMITER ;


INSERT INTO `CIRCO`.`ATRACCION_DIA` (`nombre_atraccion`, `fecha`, `num_espectadores`, `ganancias`) VALUES ('El orangután', '2020-03-02', '500', '30000.00');
INSERT INTO `CIRCO`.`ATRACCION_DIA` (`nombre_atraccion`, `fecha`, `num_espectadores`, `ganancias`) VALUES ('El orangután', '2020-03-05', '100', '10000.00');
UPDATE `CIRCO`.`ATRACCION_DIA` SET `ganancias` = '35000.00' WHERE (`nombre_atraccion` = 'El orangután') and (`fecha` = '2020-03-02');
DELETE FROM `CIRCO`.`ATRACCION_DIA` WHERE (`nombre_atraccion` = 'El orangután') and (`fecha` = '2020-03-05');

-- EJERCICIO 9
/*Modifica la tabla ATRACCIONES y añade una nueva columna de nombre contador, de tipo numérico y valor por defecto de cero, que lleve cuenta de cuantas veces se ha celebrado la atracción y que se actualice con cualquier operación. Crea los triggers necesarios.

Nota: Los datos ya añadidos tendrán como valor null. Realiza una operación de UPDATE para ponerlos a su valor correcto.
Sentencia SQL para actualizar la columna contador en las filas ya existentes:
Solución: EL proceso para crear un trigger como comenté antes es:
Identificar la tabla sobre la que vamos a crear el trigger => ATRACCION_DIA (es la tabla que guarda los días en los que se celebran atracciones)
Identificar la operación sobre la que se va a crear el trigger => INSERT, DELETE (UPDATE no es necesario ya que no va a variar el número de atracciones)
Identificar si queremos que el trigger se ejecuta antes o después: Queremos actualizar el campo contador una vez se ha añadido o borrado la fila ATRACCION_DIA por lo tanto el trigger tiene que ser AFTER.
Para acceder a los datos que estamos queriendo AÑADIR, debemos de hacer uso de la tabla NEW.
Para acceder a los datos que estamos queriendo BORRAR, debemos de hacer uso de la tabla OLD.*/

USE CIRCO;
DROP TRIGGER IF EXISTS atracciones_numAtracc_DELETE;
DELIMITER $$
CREATE TRIGGER atracciones_numAtracc_DELETE AFTER DELETE ON ATRACCION_DIA FOR EACH ROW
BEGIN
    UPDATE ATRACCIONES
    SET contador = contador - 1
    WHERE nombre = OLD.nombre_atraccion;
    
END $$
DELIMITER ;
USE CIRCO;
DROP TRIGGER IF EXISTS atracciones_numAtracc_INSERT;
DELIMITER $$
CREATE TRIGGER atracciones_numAtracc_INSERT AFTER INSERT ON ATRACCION_DIA FOR EACH ROW
BEGIN
    UPDATE ATRACCIONES
    SET contador = contador + 1
    WHERE nombre = NEW.nombre_atraccion;
    
END $$
DELIMITER ;


INSERT INTO `CIRCO`.`ATRACCION_DIA` (`nombre_atraccion`, `fecha`, `num_espectadores`, `ganancias`) VALUES ('La gigante', '2020-04-01', '120', '11232');   -- La gigante tendrá una atracción en contador
INSERT INTO `CIRCO`.`ATRACCION_DIA` (`nombre_atraccion`, `fecha`, `num_espectadores`, `ganancias`) VALUES ('La gigante', '2020-04-02', '220', '21232.00'); -- La gigante pasa a tener dos en contador
DELETE FROM `CIRCO`.`ATRACCION_DIA` WHERE (`nombre_atraccion` = 'La gigante') and (`fecha` = '2020-04-01');    -- La gigante pasa a tener uno en contador


-- EJERCICIO 10
/*Crea un procedimiento de nombre atracciones_checkGanancias en el que queremos comprobar si las ganancias totales de cada atracción coinciden con la suma de las ganancias de los días en los que se celebró. El procedimiento debe devolver una cadena con el formato: atraccion1:gananciatotal:gananciasumada, atraccion2:gananciatotal:gananciasumada con las atracciones que no cumplen que la suma sea igual...*/

USE CIRCO;
DROP PROCEDURE IF EXISTS atracciones_checkGanancias;

DELIMITER $$
CREATE PROCEDURE atracciones_checkGanancias()
COMMENT 'Devuelve las atracciones cuya suma total de ganancias no coincide con la suma de las ganancias diarias.'
BEGIN
    -- Declaración de variables
    DECLARE v_final INTEGER DEFAULT 0;
    DECLARE v_atraccion varchar(50);
    DECLARE v_ganTotales int;
    DECLARE v_ganTotalesPorDia int;
    DECLARE v_cadenaSalida varchar(1000) default '';	-- Cuidado con el valor (null) por defecto para concatenar.
    
    -- Declaración del cursor
    DECLARE c_checkGanancias CURSOR FOR 
        SELECT nombre, ganancias
        FROM ATRACCIONES;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_final = TRUE;
    OPEN c_checkGanancias;

    read_loop: LOOP
        FETCH c_checkGanancias INTO v_atraccion,v_ganTotales;

        IF v_final THEN
            LEAVE read_loop;
        END IF;
        
        SELECT SUM(ganancias)
        INTO v_ganTotalesPorDia
        FROM ATRACCION_DIA
        WHERE nombre_atraccion = v_atraccion;

        IF (v_ganTotalesPorDia<>v_ganTotales) THEN
            SET v_cadenaSalida = IF (v_cadenaSalida<>'',CONCAT(v_cadenaSalida,', '),'');	-- Para separar una atracción de otra
            SET v_cadenaSalida = CONCAT(v_cadenaSalida,v_atraccion,':',v_ganTotales,':',v_ganTotalesPorDia);
        END IF;


    END LOOP;

    CLOSE c_checkGanancias;   
    SELECT v_cadenaSalida as listaatracciones;
END$$
DELIMITER ;

call atracciones_checkGanancias();

-- EJERCICIO 11
/*Crea un procedimiento de nombre artistas_addSuplementoPorCuidados, que compruebe a cuantos animales cuida cada uno de los artistas. Aquellos artistas que cuidan más de un número de animales indicados por un parámetro se les dará un plus a su nómina igual al número de animales que cuida multiplicado por 100 euros. Muestra el nombre y complemento de cada artista así como la suma de todos los complementos.

El resultado debe aparecer como una única consulta (no valen varios SELECT).
Para ello haz uso de una tabla temporal que vaya guardando los datos (el nombre completo y el suplemento de la ganancia) y posteriormente haz un SELECT de dicha tabla. Para crear una tabla temporal haz uso de la sentencia CREATE TEMPORARY TABLE. Dicha orden debe ir después de la orden DECLARE CONTINUE HANDLER del cursor.
Recuerda borrar la tabla temporal al salir del procedimiento.*/
USE CIRCO;
DROP PROCEDURE IF EXISTS artistas_addSuplementoPorCuidados;

DELIMITER $$
CREATE PROCEDURE artistas_addSuplementoPorCuidados(p_numAnimales tinyint)
COMMENT 'Muestra un suplemento para aquellos artistas que cuidan a más animales de lo indicado así como la suma de los complementos'
BEGIN
    -- Declaración de variables
    DECLARE v_final INTEGER DEFAULT 0;
    DECLARE v_nif CHAR(9);
    DECLARE v_numAnimales TINYINT default 0;
    DECLARE v_complementoTotal INT DEFAULT 0;
    DECLARE v_apellidos VARCHAR(100);
    DECLARE v_nombre VARCHAR(45);

    -- Declaración del cursor
    DECLARE c_complemento CURSOR FOR 
        SELECT nif_artista,COUNT(*)
        FROM ANIMALES_ARTISTAS
        GROUP BY nif_artista
        HAVING COUNT(*) > p_numAnimales;
        
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_Final = TRUE;

    CREATE TEMPORARY TABLE T_TEMPORAL (nombre_completo varchar(150), suplemento decimal(6,2));
    OPEN c_complemento;


    read_loop: LOOP
        FETCH c_complemento INTO v_nif, v_numAnimales;
        IF v_final THEN
            LEAVE read_loop;
        END IF;
        
        IF (v_numAnimales > p_numAnimales) THEN
            SELECT apellidos, nombre
            INTO v_apellidos, v_nombre
            FROM ARTISTAS
            WHERE nif = v_nif;
            
            INSERT INTO T_TEMPORAL 
            VALUES (CONCAT(v_apellidos,', ',v_nombre),v_numAnimales*100);
            SET v_complementoTotal = v_complementoTotal + v_numAnimales*100;
            
        END IF;

    END LOOP;

    INSERT INTO T_TEMPORAL 
    VALUES ('Suplemento total',v_complementoTotal);

    SELECT nombre_completo, suplemento
    FROM T_TEMPORAL;

    CLOSE c_complemento;   
    
    DROP TEMPORARY TABLE T_TEMPORAL;

END$$
DELIMITER ;

call artistas_addSuplementoPorCuidados(2);

-- EJERCICIO 12
/*Crea un procedimiento de nombre animales_Delete que dado el nombre de un animal, lo borre. Antes tendrá que borrar todas las tablas relacionadas. En el caso de que el animal tenga menos de 2 años no estará permitido borrarlo y lanzará una excepción (recordar que el código de error para excepciones definidas por el usuario es el 45000) con el texto: No es posible dar de baja a animales con menos de dos años. En el caso de que el animal no exista, deberá lanzar una excepción con el texto 'Ese animal no existe' y un ErrorCode 1643.*/

USE CIRCO;
DROP PROCEDURE IF EXISTS animales_delete;

DELIMITER $$
CREATE PROCEDURE animales_delete(p_nombreAnimal VARCHAR(50))
COMMENT 'Da de baja un animal siempre que su edad sea superior a 2 años'
bloque_proc:BEGIN
	DECLARE v_anos TINYINT default -1;
    
    SELECT anhos
    INTO v_anos
    FROM ANIMALES
    WHERE nombre = p_nombreAnimal;
    
    CASE 
	WHEN v_anos = -1 THEN
		SIGNAL SQLSTATE '45000' 
		SET MESSAGE_TEXT='Ese animal no existe',
                    MYSQL_ERRNO = 1643;
                -- LEAVE bloque_proc;     NO HACE FALTA YA QUE SIGNAL HACE SALIR DEL PROCEDIMIENTO
        WHEN v_anos < 2 THEN
		SIGNAL SQLSTATE '45000' 
		SET MESSAGE_TEXT='No se puede dar de baja a animales con menos de dos años';
                -- LEAVE bloque_proc;     NO HACE FALTA YA QUE SIGNAL HACE SALIR DEL PROCEDIMIENTO
         ELSE BEGIN END;
    END CASE;

    -- BORRAMOS LOS ANIMALES. Necesitaríamos una transacción. 
    DELETE FROM ANIMALES_ARTISTAS
    WHERE nombre_animal = p_nombreAnimal;
    
    DELETE FROM ANIMALES
    WHERE nombre = p_nombreAnimal;

END$$
DELIMITER ;


call animales_delete('no_existe');   -- Devuelve el código 1643

call animales_delete('Berni');   -- No cumple que la edad sea superior a 2 años.

call animales_delete('Princesa2');   -- Lo da de baja de todas las tablas

-- EJERCICIO 13
/*Crea un procedimiento de nombre animales_addArtista al que se le pase el nombre de un animal y el nif de un artista y asigne el cuidador al animal. Deberá comprobar que el animal y el artista existen. En caso de que no, deberá lanzar una excepción con el ErrorCode 1643 y texto 'El animal no existe' o 'El artista no existe'.

En el caso de que ya exista ese artista con ese animal el propio Mysql lanzará una excepción de clave primaria duplicada.*/
USE CIRCO;
DROP PROCEDURE IF EXISTS animales_addArtista;

DELIMITER $$
CREATE PROCEDURE animales_addArtista(p_nombreAnimal VARCHAR(50),p_nif char(9))
COMMENT 'Asigna un nuevo artista a un animal'
bloque_proc:BEGIN
    
    IF (SELECT COUNT(*)
		FROM ANIMALES
		WHERE nombre = p_nombreAnimal)=0 THEN
	
		SIGNAL SQLSTATE '45000' 
			SET MESSAGE_TEXT='Ese animal no existe',
                MYSQL_ERRNO = 1643;
                -- LEAVE bloque_proc;     NO HACE FALTA YA QUE SIGNAL HACE SALIR DEL PROCEDIMIENTO
    END IF;
        
    IF (SELECT COUNT(*)
		FROM ARTISTAS
		WHERE nif = p_nif)=0 THEN
		SIGNAL SQLSTATE '45000' 
			SET MESSAGE_TEXT='Ese artista no existe',
                MYSQL_ERRNO = 1643;
                -- LEAVE bloque_proc;     NO HACE FALTA YA QUE SIGNAL HACE SALIR DEL PROCEDIMIENTO
    END IF;
		
    INSERT INTO ANIMALES_ARTISTAS (nombre_animal,nif_artista)
    VALUES (p_nombreAnimal,p_nif);
END$$
DELIMITER ;


call animales_addArtista('no_existe','11111111A'); 
call animales_addArtista('Princesa1','no_existe'); 

call animales_addArtista('Leo','33333333C'); -- Si lanzamos dos veces esta orden Mysql lanzará una excepción de clave duplicada.

