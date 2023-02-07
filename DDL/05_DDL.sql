/* 
EJERCICIO 05
Realiza el diseño fisico para el siguiente modelo relacional. Asigna el tipo de datos que consideremas más adecuado.
NOT NULL: 
	Nombre de empleado, 
    nombre de periodista,
    Titulo de revista.
Periodicidad ENUM, DEFAULT Mensual:
	Semanal,
    QUincenal,
    Mensual,
    Trimestral,
    Anual.
NumPaginas DEFAULT 1
*/

DROP DATABASE IF EXISTS ejercicio_05;
CREATE DATABASE ejercicio_05 CHARACTER SET utf8mb4;
USE ejercicio_05;

CREATE TABLE IF NOT EXISTS Sucursal (
	Codigo VARCHAR(10) PRIMARY KEY,
    Direccion VARCHAR(25),
    Telefono VARCHAR(12)
    );

CREATE TABLE IF NOT EXISTS Revista (
	NumReg VARCHAR(10) PRIMARY KEY,
    Titulo VARCHAR(25) NOT NULL,
    Periodicidad ENUM('Semanal', 'Quincenal', 'Mensual', 'Trimestral', 'Anual') DEFAULT 'Mensual',
    Tipo VARCHAR(25),
    Sucursal VARCHAR(10),
    FOREIGN KEY (Sucursal) REFERENCES Sucursal(Codigo) ON UPDATE CASCADE ON DELETE CASCADE
    );

CREATE TABLE IF NOT EXISTS Empleado (
	dni VARCHAR(9) PRIMARY KEY,
    Nombre VARCHAR(25) NOT NULL,
    Direccion VARCHAR(25),
    Telefono VARCHAR(12),
    Sucursal VARCHAR(10),
    FOREIGN KEY (Sucursal) REFERENCES Sucursal(Codigo) ON UPDATE CASCADE ON DELETE CASCADE
    );

CREATE TABLE IF NOT EXISTS Periodista (
	dni VARCHAR(9) PRIMARY KEY,
    Nombre VARCHAR(25) NOT NULL,
    Direccion VARCHAR(25),
    Telefono VARCHAR(12),
    Especialidad VARCHAR(25)
    );
    
/* Para declarar varias primary key de una tabla:
Marcar como no nulo las variables que serán primary key y al final de la tabla (dentro) escribir:
	CONSTRAINT ('nombre de la primary key') PRIMARY KEY ('id1', 'id2', 'id3', ...)
*/

CREATE TABLE IF NOT EXISTS escribe (
	NumReg VARCHAR(10) NOT NULL,
    dni_Per VARCHAR(9) NOT NULL,
    CONSTRAINT PK_esc_NudP PRIMARY KEY (numReg, dni_Per),
    FOREIGN KEY (NumReg) REFERENCES Revista(NumReg) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (dni_Per) REFERENCES Periodista(dni) ON UPDATE CASCADE ON DELETE CASCADE
	);

CREATE TABLE IF NOT EXISTS NumRevista (
	NumReg VARCHAR(10) NOT NULL,
	Numero INT(8) NOT NULL,
    NumPaginas VARCHAR(10),
	Fecha DATE, /* format: YYYY-MM-DD */
    CantVendidas INT(8),
    CONSTRAINT PK_nRev_NRNu PRIMARY KEY (NumReg, Numero),
    FOREIGN KEY (NumReg) REFERENCES Revista(NumReg) ON UPDATE CASCADE ON DELETE CASCADE
	);