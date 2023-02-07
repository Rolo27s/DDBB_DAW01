/* 
EJERCICIO 08
Realiza el diseño fisico para el siguiente modelo relacional. Asigna el tipo de datos que consideremas más adecuado.
*/

DROP DATABASE IF EXISTS ejercicio_08;
CREATE DATABASE ejercicio_08 CHARACTER SET utf8mb4;
USE ejercicio_08;

CREATE TABLE IF NOT EXISTS Sucursal(
	CodSucursal INT(10),
    Nombre VARCHAR(25),
    Direccion VARCHAR(25),
    Localidad VARCHAR(25)
	);
    
CREATE TABLE IF NOT EXISTS Cuenta(
	CodSucursal INT(10),
    CodCuenta VARCHAR(25)
	);
    
CREATE TABLE IF NOT EXISTS Transacción(
	CodSucursal INT(10),
    CodCuenta  VARCHAR(25),
    NumTransacción VARCHAR(25),
    Fecha DATE,
    Cantidad INT(10),
    Tipo VARCHAR(25)
	);
    
CREATE TABLE IF NOT EXISTS Cliente(
	DNI VARCHAR(9),
    Nombre VARCHAR(25),
    Direccion VARCHAR(25),
    Localidad VARCHAR(25),
    FechaNax DATE,
    Sexo ENUM ('H', 'M')
	);
    
CREATE TABLE IF NOT EXISTS Cli_Cuenta(
	CodSucursal INT(10),
    CodCuenta  VARCHAR(25),
    DNI VARCHAR(9)
	);
    
/* Añado todas las restricciones */
ALTER TABLE Sucursal ADD CONSTRAINT PK_Suc_Cod PRIMARY KEY (CodSucursal);
ALTER TABLE Sucursal MODIFY CodSucursal INT(10) AUTO_INCREMENT;
ALTER TABLE Sucursal AUTO_INCREMENT=101;

ALTER TABLE Cuenta ADD CONSTRAINT PK_Cue_CoC PRIMARY KEY (CodSucursal, CodCuenta);
ALTER TABLE Cuenta ADD CONSTRAINT FK_Cue_CoS FOREIGN KEY (CodSucursal) REFERENCES Sucursal(CodSucursal) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE Transacción ADD CONSTRAINT PK_Tra_CCN PRIMARY KEY (CodSucursal, CodCuenta, NumTransacción);
ALTER TABLE Transacción ADD CONSTRAINT FK_Tra_CoC FOREIGN KEY (CodSucursal, CodCuenta) REFERENCES Cuenta(CodSucursal, CodCuenta) ON UPDATE CASCADE ON DELETE CASCADE;

ALTER TABLE Cliente ADD CONSTRAINT PK_Cli_DNI PRIMARY KEY (DNI);

ALTER TABLE Cli_Cuenta ADD CONSTRAINT PK_CCu_Cod PRIMARY KEY (CodSucursal, CodCuenta, DNI);
ALTER TABLE Cli_Cuenta ADD CONSTRAINT FK_CCu_CoC FOREIGN KEY (CodSucursal, CodCuenta) REFERENCES Cuenta(CodSucursal, CodCuenta) ON UPDATE CASCADE ON DELETE CASCADE;