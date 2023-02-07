/* 
EJERCICIO 09
Realiza el diseño fisico para el siguiente modelo relacional. Asigna el tipo de datos que consideremas más adecuado.
*/

DROP DATABASE IF EXISTS ejercicio_09;
CREATE DATABASE ejercicio_09 CHARACTER SET utf8mb4;
USE ejercicio_09;

CREATE TABLE IF NOT EXISTS Artículo(
	NumArtículo INT(10),
    Descripción VARCHAR(25)
	);

ALTER TABLE Artículo ADD CONSTRAINT PK_Art_NAr PRIMARY KEY (NumArtículo);
ALTER TABLE Artículo MODIFY NumArtículo INT(10) AUTO_INCREMENT;
    
CREATE TABLE IF NOT EXISTS Fábrica(
	NumFábrica INT(10),
    Teléfono VARCHAR(12)
	);

/* Añado todas las restricciones */
ALTER TABLE Fábrica ADD CONSTRAINT PK_Fab_NFa PRIMARY KEY (NumFábrica);
ALTER TABLE Fábrica MODIFY NumFábrica INT(10) AUTO_INCREMENT;
    
CREATE TABLE IF NOT EXISTS distribuye(
	NumArtículo INT(10),
    NumFábrica INT(10),
    CantSuministro INT(10),
    Existencias INT(10)
	);

ALTER TABLE distribuye ADD CONSTRAINT PK_dis_NNF PRIMARY KEY (NumArtículo, NumFábrica);
ALTER TABLE distribuye ADD CONSTRAINT FK_dis_NAr FOREIGN KEY (NumArtículo) REFERENCES Artículo(NumArtículo) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE distribuye ADD CONSTRAINT FK_dis_NFa FOREIGN KEY (NumFábrica) REFERENCES Fábrica(NumFábrica) ON UPDATE CASCADE ON DELETE CASCADE;
    
CREATE TABLE IF NOT EXISTS Dirección(
	CodDirección VARCHAR(25),
    Vía VARCHAR(25),
    NombreVía VARCHAR(25),
    Número VARCHAR(25),
    Piso VARCHAR(25),
    Portal VARCHAR(25),
    CodPostal INT(5)
	);

ALTER TABLE Dirección ADD CONSTRAINT PK_Dir_CDi PRIMARY KEY (CodDirección);

CREATE TABLE IF NOT EXISTS Cliente(
	NumCliente INT(10),
    Saldo FLOAT(10),
    LimCrédito FLOAT(10),
    Descuento FLOAT(10)
	);

ALTER TABLE Cliente ADD CONSTRAINT PK_Cli_NCl PRIMARY KEY (NumCliente);
    
CREATE TABLE IF NOT EXISTS Pedido(
	NumPedido INT(10),
    Fecha DATE,
    NumCliente INT(10),
    CodDirección VARCHAR(25)
	);

ALTER TABLE Pedido ADD CONSTRAINT PK_Ped_NPe PRIMARY KEY (NumPedido);
ALTER TABLE Pedido MODIFY NumPedido INT(10) AUTO_INCREMENT;
ALTER TABLE Pedido ADD CONSTRAINT FK_Ped_NCl FOREIGN KEY (NumCliente) REFERENCES Cliente(NumCliente) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE Pedido ADD CONSTRAINT FK_Ped_CDi FOREIGN KEY (CodDirección) REFERENCES Dirección(CodDirección) ON UPDATE CASCADE ON DELETE CASCADE;
    
CREATE TABLE IF NOT EXISTS posee(
	NumCliente INT(10),
    CodDirección VARCHAR(25)
	);

ALTER TABLE posee ADD CONSTRAINT PK_pos_NCD PRIMARY KEY (NumCliente, CodDirección);
ALTER TABLE posee ADD CONSTRAINT FK_pos_NCl FOREIGN KEY (NumCliente) REFERENCES Cliente(NumCliente) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE posee ADD CONSTRAINT FK_pos_CDi FOREIGN KEY (CodDirección) REFERENCES Dirección(CodDirección) ON UPDATE CASCADE ON DELETE CASCADE;
    
CREATE TABLE IF NOT EXISTS incluye(
	NumPedido INT(10),
    NumArtículo INT(10),
    Cantidad INT(10)
	);

ALTER TABLE incluye ADD CONSTRAINT PK_inc_NNA PRIMARY KEY (NumPedido, NumArtículo);
ALTER TABLE incluye ADD CONSTRAINT FK_inc_NPe FOREIGN KEY (NumPedido) REFERENCES Pedido(NumPedido) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE incluye ADD CONSTRAINT FK_inc_NAr FOREIGN KEY (NumArtículo) REFERENCES Artículo(NumArtículo) ON UPDATE CASCADE ON DELETE CASCADE;