/* 
EJERCICIO 04
Realiza el diseño fisico para el siguiente modelo relacional. Asigna el tipo de datos que consideremas más adecuado.
*/

DROP DATABASE IF EXISTS ejercicio_04;
CREATE DATABASE ejercicio_04 CHARACTER SET utf8mb4;
USE ejercicio_04;

CREATE TABLE IF NOT EXISTS Cliente (
	CodCliente VARCHAR(10) PRIMARY KEY,
    NIF VARCHAR(9) UNIQUE NOT NULL,
    Nombre VARCHAR(25) NOT NULL,
    Direccion VARCHAR(25) NOT NULL,
    Telefono VARCHAR(16) NOT NULL 		/* format: +34 625 74 25 48 */
    );

CREATE TABLE IF NOT EXISTS Reserva (
	Numero INT(8) PRIMARY KEY,
    FechaInicio DATETIME NOT NULL, 	/* format: YYYY-MM-DD HH:MI:SS */
    FechaFin DATETIME NOT NULL, 	/* format: YYYY-MM-DD HH:MI:SS */
    PrecioTotal FLOAT(8) NOT NULL,
	CodCliente VARCHAR(10) NOT NULL,
    FOREIGN KEY (CodCliente) REFERENCES Cliente(CodCliente) ON UPDATE CASCADE ON DELETE CASCADE
    );

CREATE TABLE IF NOT EXISTS Coche (
	Matricula VARCHAR(10) PRIMARY KEY,
    Marca VARCHAR(25),
    modelo VARCHAR(25),
    color VARCHAR(25),
    PrecioHora FLOAT (6)
    );

CREATE TABLE IF NOT EXISTS avala (
	Avalado VARCHAR(10) PRIMARY KEY,
    Avalador VARCHAR(10) NOT NULL,
    FOREIGN KEY (Avalado) REFERENCES Cliente(CodCliente) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (Avalador) REFERENCES Cliente(CodCliente) ON UPDATE CASCADE ON DELETE CASCADE
	);

CREATE TABLE IF NOT EXISTS incluye (
	Numero INT(8) NOT NULL,
    Matricula VARCHAR(10) NOT NULL,
	litrosGas FLOAT(5),
    FOREIGN KEY (Numero) REFERENCES Reserva(Numero) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (Matricula) REFERENCES Coche(Matricula) ON UPDATE CASCADE ON DELETE CASCADE
	);
ALTER TABLE incluye ADD CONSTRAINT PK_inc_nm PRIMARY KEY (Numero, Matricula);