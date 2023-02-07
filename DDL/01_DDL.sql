/* 
EJERCICIO 01
Realiza el diseño fisico para el siguiente modelo relacional. Asigna el tipo de datos que consideremas más adecuado.
*/
/* La sentencia DROP DATABASE antes de crearla es simplemente para la realizacion de estos ejercicios y el objetivo
es simplemente forzar a la creacion de estas. No es una buena practica ni nada similar. De hecho, es peligroso. */
DROP DATABASE IF EXISTS ejercicio_01;
CREATE DATABASE ejercicio_01 CHARACTER SET utf8mb4;
USE ejercicio_01;

CREATE TABLE IF NOT EXISTS Alumno (
	numMatricula INT PRIMARY KEY,
	nombre VARCHAR(25) NOT NULL,
	fechaNacimiento DATETIME NOT NULL, 	/* format: YYYY-MM-DD HH:MI:SS */
	telefono VARCHAR(16) NOT NULL 		/* format: +34 625 74 25 48 */
	);

CREATE TABLE IF NOT EXISTS Profesor (
	idProfesor INT PRIMARY KEY,
    nif_p VARCHAR(9) UNIQUE NOT NULL,
    nombre VARCHAR(25) NOT NULL,
    especialidad VARCHAR(25) NOT NULL,
    telefono VARCHAR(16) NOT NULL 		/* format: +34 625 74 25 48 */
	);
    
CREATE TABLE IF NOT EXISTS Asignatura (
	codAsignatura INT PRIMARY KEY,
    nombre VARCHAR(25) NOT NULL,
    idProfesor INT NOT NULL,
    FOREIGN KEY (idProfesor) REFERENCES Profesor(idProfesor) ON UPDATE CASCADE ON DELETE CASCADE
    );

CREATE TABLE IF NOT EXISTS Recibe (
	numMatricula INT PRIMARY KEY,
    codAsignatura INT PRIMARY KEY,
    cursoEscolar DATE PRIMARY KEY,
    FOREIGN KEY (numMatricula) REFERENCES Alumno(numMatricula) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (codAsignatura) REFERENCES Asignatura(codAsignatura) ON UPDATE CASCADE ON DELETE CASCADE
	);
    
/* Renombra la tabla "Profesor" a "Docente" */
RENAME TABLE Profesor to Docente;