/* 
EJERCICIO 10
Realiza el diseño fisico para el siguiente modelo relacional. Asigna el tipo de datos que consideremas más adecuado.
*/
DROP DATABASE IF EXISTS ejercicio_10;
CREATE DATABASE ejercicio_10 CHARACTER SET utf8mb4;
USE ejercicio_10;

CREATE TABLE IF NOT EXISTS Cliente(
	CodCliente INT(10),
    Nombre VARCHAR(25),
    Calle VARCHAR(25),
    Número INT(4),
    Comuna VARCHAR(25),
    Ciudad VARCHAR(25)
	);
    
CREATE TABLE IF NOT EXISTS Venta(
	IDVenta INT(10),
    MontoTotal FLOAT(10),
    CodCliente INT(10)
	);
    
CREATE TABLE IF NOT EXISTS Categoría(
	IDCategoría INT(10),
    Nombre VARCHAR(25),
    Descripción VARCHAR(100)
	);
    
CREATE TABLE IF NOT EXISTS Proveedor(
	CodProveedor INT(10),
    Nombre VARCHAR(25),
    Dirección VARCHAR(25),
    Teléfono VARCHAR(12),
    Web VARCHAR(25)
	);

CREATE TABLE IF NOT EXISTS Teléfono(
	Número VARCHAR(12)
	);
    
CREATE TABLE IF NOT EXISTS Producto(
	IDProducto INT(10),
    Nombre VARCHAR(25),
    Precio FLOAT(10),
    Stock INT(10),
    IDCategoría INT(10),
    IDProveedor INT(10)
	);
    
CREATE TABLE IF NOT EXISTS asociado(
	CodCliente INT(10),
    NumTelefono VARCHAR(12)
	);
    
CREATE TABLE IF NOT EXISTS incluye(
		IDVenta INT(10),
        IDProducto INT(10),
        Cantidad INT(10),
        PrecioVenta FLOAT(10)
	);
    
    /* Añado todas las restricciones */
    ALTER TABLE Cliente ADD CONSTRAINT PK_Cli_CCl PRIMARY KEY (CodCliente);
    
    ALTER TABLE Venta ADD CONSTRAINT PK_Ven_IDV PRIMARY KEY (IDVenta);
    ALTER TABLE Venta ADD CONSTRAINT FK_Ven_CCl FOREIGN KEY (CodCliente) REFERENCES Cliente(CodCliente) ON UPDATE CASCADE ON DELETE CASCADE;
    
	ALTER TABLE Categoría ADD CONSTRAINT PK_Cat_IDC PRIMARY KEY (IDCategoría);
	ALTER TABLE Proveedor ADD CONSTRAINT PK_Pro_CPr PRIMARY KEY (CodProveedor);
    
	ALTER TABLE Producto ADD CONSTRAINT PK_Pro_IDP PRIMARY KEY (IDProducto);
    ALTER TABLE Producto ADD CONSTRAINT FK_Pro_IDC FOREIGN KEY (IDCategoría) REFERENCES Categoría(IDCategoría) ON UPDATE CASCADE ON DELETE CASCADE;
    ALTER TABLE Producto ADD CONSTRAINT FK_Pro_IDP FOREIGN KEY (IDProveedor) REFERENCES Proveedor(CodProveedor) ON UPDATE CASCADE ON DELETE CASCADE;
    
	ALTER TABLE Teléfono ADD CONSTRAINT PK_Tel_Num PRIMARY KEY (Número);
    
	ALTER TABLE asociado ADD CONSTRAINT PK_aso_CNT PRIMARY KEY (CodCliente, NumTelefono);
    ALTER TABLE asociado ADD CONSTRAINT FK_aso_CCl FOREIGN KEY (CodCliente) REFERENCES Cliente(CodCliente) ON UPDATE CASCADE ON DELETE CASCADE;
    ALTER TABLE asociado ADD CONSTRAINT FK_aso_NTl FOREIGN KEY (NumTelefono) REFERENCES Teléfono(Número) ON UPDATE CASCADE ON DELETE CASCADE;
    
    ALTER TABLE incluye ADD CONSTRAINT PK_inc_IVP PRIMARY KEY (IDVenta, IDProducto);
    ALTER TABLE incluye ADD CONSTRAINT FK_inc_IDV FOREIGN KEY (IDVenta) REFERENCES Venta(IDVenta) ON UPDATE CASCADE ON DELETE CASCADE;
    ALTER TABLE incluye ADD CONSTRAINT FK_inc_IDP FOREIGN KEY (IDProducto) REFERENCES Producto(IDProducto) ON UPDATE CASCADE ON DELETE CASCADE;