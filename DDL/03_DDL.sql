/* 
EJERCICIO 03
Realiza el diseño fisico para el siguiente modelo relacional. Asigna el tipo de datos que consideremas más adecuado.
*/

DROP DATABASE IF EXISTS ejercicio_03;
CREATE DATABASE ejercicio_03 CHARACTER SET utf8mb4;
USE ejercicio_03;

CREATE TABLE IF NOT EXISTS Cliente (
	NIF VARCHAR(9) PRIMARY KEY,
    Nombre VARCHAR(25) NOT NULL,
    Direccion VARCHAR(25) NOT NULL,
    Telefono VARCHAR(16) NOT NULL 		/* format: +34 625 74 25 48 */
    );

CREATE TABLE IF NOT EXISTS Montador (
	NIF VARCHAR(9) PRIMARY KEY,
    Nombre VARCHAR(25) NOT NULL,
    Direccion VARCHAR(25) NOT NULL,
    Telefono VARCHAR(16) NOT NULL 		/* format: +34 625 74 25 48 */
    );

CREATE TABLE IF NOT EXISTS ModeloDormitorio (
	Cod VARCHAR(25) PRIMARY KEY
    );

CREATE TABLE IF NOT EXISTS compra (
	NIF_C VARCHAR(9) NOT NULL,
    Modelo VARCHAR(25) NOT NULL,
	FechaCompra DATE NOT NULL, /* format: YYYY-MM-DD */
    FOREIGN KEY (NIF_C) REFERENCES Cliente(NIF) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (Modelo) REFERENCES ModeloDormitorio(Cod) ON UPDATE CASCADE ON DELETE CASCADE
	);
/* Con este comando consigo generar una columna con tres claves primarias */
/* Otra opcion mas facil es declarar como no nulo las variables que serán primary key y al final de la tabla (dentro) escribir:
PRIMARY KEY ('id1', 'id2', 'id3', ...)
*/
ALTER TABLE compra ADD CONSTRAINT PK_com_nmf PRIMARY KEY (NIF_C, Modelo, FechaCompra);

CREATE TABLE IF NOT EXISTS monta (
	NIF_M VARCHAR(9) NOT NULL,
    Modelo VARCHAR(25) NOT NULL,
	FechaMontaje DATE NOT NULL, /* format: YYYY-MM-DD */
    FOREIGN KEY (NIF_M) REFERENCES Montador(NIF) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (Modelo) REFERENCES ModeloDormitorio(Cod) ON UPDATE CASCADE ON DELETE CASCADE
	);
ALTER TABLE monta ADD CONSTRAINT PK_cmon_nmf PRIMARY KEY (NIF_M, Modelo, FechaMontaje);