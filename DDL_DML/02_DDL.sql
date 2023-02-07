/* 
EJERCICIO 02
Realiza el diseño fisico para el siguiente modelo relacional. Asigna el tipo de datos que consideremas más adecuado.
*/

DROP DATABASE IF EXISTS ejercicio_02;
CREATE DATABASE ejercicio_02 CHARACTER SET utf8mb4;
USE ejercicio_02;

CREATE TABLE IF NOT EXISTS Region (
	codRegion INT PRIMARY KEY,
	nombre VARCHAR(25) NOT NULL
	);

CREATE TABLE IF NOT EXISTS Provincia (
	codProvincia INT PRIMARY KEY,
    nombre VARCHAR(25) NOT NULL,
    codRegion INT NOT NULL,
    FOREIGN KEY (codRegion) REFERENCES Region(codRegion) ON UPDATE CASCADE ON DELETE CASCADE
	);
    
CREATE TABLE IF NOT EXISTS Localidad (
	codLocalidad INT PRIMARY KEY,
    nombre VARCHAR(25) NOT NULL,
    codProvincia INT NOT NULL,
    FOREIGN KEY (codProvincia) REFERENCES Provincia(codProvincia) ON UPDATE CASCADE ON DELETE CASCADE
    );

CREATE TABLE IF NOT EXISTS Empleado (
	id INT PRIMARY KEY,
    dni VARCHAR(9) UNIQUE NOT NULL,
    nombre VARCHAR(25) NOT NULL,
    fechaNacimiento DATETIME NOT NULL, 	/* format: YYYY-MM-DD HH:MI:SS */
	telefono VARCHAR(16) NOT NULL, 		/* format: +34 625 74 25 48 */
    salario FLOAT(8) NOT NULL,
    codLocalidad INT NOT NULL,
    FOREIGN KEY (codLocalidad) REFERENCES Localidad(codLocalidad) ON UPDATE CASCADE ON DELETE CASCADE
	);