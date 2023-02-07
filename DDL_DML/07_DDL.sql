/* 
EJERCICIO 07
Realiza el diseño fisico para el siguiente modelo relacional. Asigna el tipo de datos que consideremas más adecuado.
*/

DROP DATABASE IF EXISTS ejercicio_07;
CREATE DATABASE ejercicio_07 CHARACTER SET utf8mb4;
USE ejercicio_07;

CREATE TABLE IF NOT EXISTS Municipio (
	ID VARCHAR(25) PRIMARY KEY,
    Nombre VARCHAR(25) NOT NULL,
    CodPostal INT(5),
    Provincia VARCHAR(25)
    );

CREATE TABLE IF NOT EXISTS Vivienda (
	ID VARCHAR(25) PRIMARY KEY,
    TipoVía VARCHAR(25) DEFAULT 'Calle',
    NombreVía VARCHAR(25) NOT NULL,
    IDMunicipio VARCHAR(25),
    FOREIGN KEY (IDMunicipio) REFERENCES Municipio(ID) ON UPDATE CASCADE ON DELETE CASCADE
    );

CREATE TABLE IF NOT EXISTS Persona (
	DNI VARCHAR(9) PRIMARY KEY,
    Nombre VARCHAR(25) NOT NULL,
    FechaNac DATE,
    Sexo ENUM('H', 'M'),
    IDVivienda VARCHAR(25),
    FOREIGN KEY (IDVivienda) REFERENCES Vivienda(ID) ON UPDATE CASCADE ON DELETE CASCADE
    );

CREATE TABLE IF NOT EXISTS posee (
	DNI VARCHAR(9),
    IDVivienda VARCHAR(25),
    CONSTRAINT PK_pos_DVi PRIMARY KEY (DNI, IDVivienda),
    FOREIGN KEY (DNI) REFERENCES Persona(DNI),
    FOREIGN KEY (IDVivienda) REFERENCES Vivienda(ID)
	);
    
CREATE TABLE IF NOT EXISTS cabezaFamilia (
	DNI VARCHAR(9) PRIMARY KEY,
    IDVivienda VARCHAR(25) UNIQUE,
    FOREIGN KEY (DNI) REFERENCES Persona(DNI),
    FOREIGN KEY (IDVivienda) REFERENCES Vivienda(ID)
    );