/* 
EJERCICIO 11
Realiza el diseño fisico para el siguiente modelo relacional. Asigna el tipo de datos que consideremas más adecuado.
*/
DROP DATABASE IF EXISTS ejercicio_11;
CREATE DATABASE ejercicio_11 CHARACTER SET utf8mb4;
USE ejercicio_11;

CREATE TABLE IF NOT EXISTS Curso(
	CodCurso INT(10),
    Nombre VARCHAR(25),
    Duración VARCHAR(25),
    Coste FLOAT(10)
	);

ALTER TABLE Curso ADD CONSTRAINT PK_Cur_CCu PRIMARY KEY (CodCurso);

CREATE TABLE IF NOT EXISTS Empleado(
	CodEmp INT(10),
    NIF VARCHAR(9),
    Nombre VARCHAR(25),
    Apellidos VARCHAR(25),
    Dirección VARCHAR(25),
    Teléfono VARCHAR(12),
    FechaNac DATE,
    Salario FLOAT(10)
	);

ALTER TABLE Empleado ADD CONSTRAINT PK_Emp_CEm PRIMARY KEY (CodEmp);
ALTER TABLE Empleado MODIFY NIF VARCHAR(9) UNIQUE;
    
CREATE TABLE IF NOT EXISTS EmpCapacitado(
	CodEmp INT(10)
	);

ALTER TABLE EmpCapacitado ADD CONSTRAINT PK_ECa_CEm PRIMARY KEY (CodEmp);
ALTER TABLE EmpCapacitado ADD CONSTRAINT FK_ECa_CEm FOREIGN KEY (CodEmp) REFERENCES Empleado(CodEmp) ON UPDATE CASCADE ON DELETE CASCADE;
    
CREATE TABLE IF NOT EXISTS EmpNoCapacitado(
	CodEmp INT(10)
	);

ALTER TABLE EmpNoCapacitado ADD CONSTRAINT PK_ENC_CEm PRIMARY KEY (CodEmp);
ALTER TABLE EmpNoCapacitado ADD CONSTRAINT FK_ENC_CEm FOREIGN KEY (CodEmp) REFERENCES Empleado(CodEmp) ON UPDATE CASCADE ON DELETE CASCADE;
    
CREATE TABLE IF NOT EXISTS Edición(
	CodCurso INT(10),
    FechaInicio DATE,
    Lugar VARCHAR(25),
    Horario VARCHAR(25),
    Profesor INT(10)
	);

ALTER TABLE Edición ADD CONSTRAINT PK_Edi_CFI PRIMARY KEY (CodCurso, FechaInicio);
ALTER TABLE Edición ADD CONSTRAINT FK_Edi_CCu FOREIGN KEY (CodCurso) REFERENCES Curso(CodCurso) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE Edición ADD CONSTRAINT FK_Edi_Pro FOREIGN KEY (Profesor) REFERENCES EmpCapacitado(CodEmp) ON UPDATE CASCADE ON DELETE CASCADE;
    
CREATE TABLE IF NOT EXISTS recibe(
	CodEmpleado INT(10),
    CodCurso INT(10),
    FechaInicio DATE
	);

ALTER TABLE recibe ADD CONSTRAINT PK_rec_CCF PRIMARY KEY (CodEmpleado, CodCurso, FechaInicio);
ALTER TABLE recibe ADD CONSTRAINT FK_rec_CEm FOREIGN KEY (CodEmpleado) REFERENCES Empleado(CodEmp) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE recibe ADD CONSTRAINT FK_rec_CFI FOREIGN KEY (CodCurso, FechaInicio) REFERENCES Edición(CodCurso, FechaInicio) ON UPDATE CASCADE ON DELETE CASCADE;
    
CREATE TABLE IF NOT EXISTS prerrequisito(
	CursoSolicitado INT(10),
    CursoPrevio INT(10),
    Obligatorio ENUM('S', 'N')
	);
    
ALTER TABLE prerrequisito ADD CONSTRAINT PK_pre_CCP PRIMARY KEY (CursoSolicitado, CursoPrevio);
ALTER TABLE prerrequisito ADD CONSTRAINT FK_pre_CCP1 FOREIGN KEY (CursoSolicitado) REFERENCES Edición(CodCurso) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE prerrequisito ADD CONSTRAINT FK_pre_CCP2 FOREIGN KEY (CursoPrevio) REFERENCES Edición(CodCurso) ON UPDATE CASCADE ON DELETE CASCADE;