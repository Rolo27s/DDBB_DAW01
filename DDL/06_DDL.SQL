/* 
EJERCICIO 06
Realiza el diseño fisico para el siguiente modelo relacional. Asigna el tipo de datos que consideremas más adecuado.
NOT NULL: 
	Nombre de socio, 
    Titulo de pelicula,
Sexo ENUM:
	H,
    M
Prota ENUM, DEFAULT 'N'
	S,
    N
*/

/* let x = VARCHAR (25); */

DROP DATABASE IF EXISTS ejercicio_06;
CREATE DATABASE ejercicio_06 CHARACTER SET utf8mb4;
USE ejercicio_06;

CREATE TABLE IF NOT EXISTS Director (
	Nombre VARCHAR(25) PRIMARY KEY,
    Nacionalidad VARCHAR(25)
	);
    
CREATE TABLE IF NOT EXISTS Pelicula (
	ID VARCHAR(25) PRIMARY KEY,
    Titulo VARCHAR(25) NOT NULL,
    Productora VARCHAR(25),
    Nacionalidad VARCHAR(25),
    Fecha DATE,
    Director VARCHAR(25),
    FOREIGN KEY (Director) REFERENCES Director(Nombre) ON UPDATE CASCADE ON DELETE CASCADE
    );
    
CREATE TABLE IF NOT EXISTS Ejemplar (
	ID_Peli VARCHAR (25),
    Numero VARCHAR (25),
    Estado VARCHAR (25),
    CONSTRAINT PK_Eje_IDN PRIMARY KEY (ID_Peli, Numero)
    );

CREATE TABLE IF NOT EXISTS Actores (
	Nombre VARCHAR(25) PRIMARY KEY,
    Nacionalidad VARCHAR(25),
    Sexo ENUM ('H', 'M')
    );
    
CREATE TABLE IF NOT EXISTS actua (
	Actor VARCHAR(25),
    ID_Peli VARCHAR(25),
    Prota ENUM ('S', 'N') DEFAULT 'N',
    CONSTRAINT PK_act_AID PRIMARY KEY (Actor, ID_Peli),
    FOREIGN KEY (ID_Peli) REFERENCES Pelicula(ID) ON UPDATE CASCADE ON DELETE CASCADE
    );

CREATE TABLE IF NOT EXISTS Socio (
	dni VARCHAR(9) PRIMARY KEY,
    Nombre VARCHAR(25) NOT NULL,
    Direccion VARCHAR(25),
    Telefono VARCHAR(25),
    Avalador VARCHAR(9),
    FOREIGN KEY (Avalador) REFERENCES Socio(dni) ON UPDATE CASCADE ON DELETE CASCADE
    );
    
CREATE TABLE IF NOT EXISTS alquila (
	dni VARCHAR(9),
    ID_Peli VARCHAR (25),
    Numero VARCHAR (25),
    FechaAlquiler DATE,
    FechaDevolucion DATE,
    CONSTRAINT PK_alq_var PRIMARY KEY (dni, ID_Peli, Numero, FechaAlquiler),
    FOREIGN KEY (dni) REFERENCES Socio(dni) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (ID_Peli, Numero) REFERENCES Ejemplar(ID_Peli, Numero) ON UPDATE CASCADE ON DELETE CASCADE
    );