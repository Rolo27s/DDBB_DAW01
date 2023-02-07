DROP DATABASE IF EXISTS tienda;
CREATE DATABASE tienda CHARACTER SET utf8mb4;
USE tienda;
CREATE TABLE fabricante (
codigo INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
nombre VARCHAR(100) NOT NULL
);
CREATE TABLE producto (
codigo INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
nombre VARCHAR(100) NOT NULL,
precio DOUBLE NOT NULL,
codigo_fabricante INT UNSIGNED NOT NULL,
FOREIGN KEY (codigo_fabricante) REFERENCES fabricante(codigo)
);
INSERT INTO fabricante VALUES(1, 'Asus');
INSERT INTO fabricante VALUES(2, 'Lenovo');
INSERT INTO fabricante VALUES(3, 'Hewlett-Packard');
INSERT INTO fabricante VALUES(4, 'Samsung');
INSERT INTO fabricante VALUES(5, 'Seagate');
INSERT INTO fabricante VALUES(6, 'Crucial');
INSERT INTO fabricante VALUES(7, 'Gigabyte');
INSERT INTO fabricante VALUES(8, 'Huawei');
INSERT INTO fabricante VALUES(9, 'Xiaomi');
INSERT INTO producto VALUES(1, 'Disco duro SATA3 1TB', 86.99, 5);
INSERT INTO producto VALUES(2, 'Memoria RAM DDR4 8GB', 120, 6);
INSERT INTO producto VALUES(3, 'Disco SSD 1 TB', 150.99, 4);
INSERT INTO producto VALUES(4, 'GeForce GTX 1050Ti', 185, 7);
INSERT INTO producto VALUES(5, 'GeForce GTX 1080 Xtreme', 755, 6);
INSERT INTO producto VALUES(6, 'Monitor 24 LED Full HD', 202, 1);
INSERT INTO producto VALUES(7, 'Monitor 27 LED Full HD', 245.99, 1);
INSERT INTO producto VALUES(8, 'Portátil Yoga 520', 559, 2);
INSERT INTO producto VALUES(9, 'Portátil Ideapd 320', 444, 2);
INSERT INTO producto VALUES(10, 'Impresora HP Deskjet 3720', 59.99, 3);
INSERT INTO producto VALUES(11, 'Impresora HP Laserjet Pro M26nw', 180, 3);

/* 1 */
SELECT nombre FROM producto;
select nombre, precio FROM producto;
SELECT * FROM producto;
SELECT nombre, precio, precio*1.09 AS dolares FROM producto;
SELECT nombre AS "nombre de producto", precio AS euros, precio*1.09 AS dólares FROM producto;
SELECT upper(nombre), precio FROM producto;
SELECT lower(nombre), precio FROM producto;
SELECT nombre, upper(LEFT(nombre,2)) FROM fabricante;
SELECT nombre, round(precio) FROM producto;
SELECT nombre, TRUNCATE(precio,0) FROM producto;
SELECT codigo_fabricante FROM producto;
SELECT DISTINCT codigo_fabricante FROM producto;
SELECT nombre FROM fabricante ORDER BY nombre ASC;
SELECT nombre FROM fabricante ORDER BY nombre DESC;
SELECT * FROM fabricante LIMIT 5;
SELECT * FROM fabricante LIMIT 3, 2;

SELECT nombre, precio FROM producto
ORDER BY precio ASC
LIMIT 1;

/* 19 */
SELECT nombre, precio FROM producto
ORDER BY precio DESC
LIMIT 1;


##20. Lista el nombre de todos los productos del fabricante cuyo código…
	
SELECT nombre FROM producto
WHERE codigo = 2;

##21. Lista el nombre de los productos que tienen un precio menor o igual a 120€

SELECT nombre 
	from producto
	where precio <=120;

## 22. Lista el nombre de todos los productos que tienen un precio mayor o igual a ##400

SELECT nombre FROM producto
WHERE precio >= 400;

##23 Lista el nombre de los productos que no tiene un precio mayor o igual a 400€

SELECT nombre 
	from producto
	where precio <400;

## 24. Lista todos los productos que tengan un precio entre 80 y 300 sin BETWEEN

SELECT nombre 
FROM producto
WHERE precio >= 80 AND precio <= 300;
	

##25 Lista todos los productos que tengan un precio entre 60 y 200.

SELECT *
	from producto
	where precio between 60 and 200;


##26. Lista todos los productos que tengan un precio mayor que 200 y que el codigo #de fabr sea 6

SELECT nombre FROM producto
WHERE precio > 200 AND codigo_fabricante = 6;

##27 Lista todos los productos donde el codigo de fabricante sea 1,3 o 5 sin utilizar ##el operador IN
  
SELECT *
    from producto
    where codigo_fabricante = 1 or codigo_fabricante = 3 or codigo_fabricante = 5;

##28. Lista todos los productos donde el codigo de fabricante sea 1, 3 o 5 utilizando ##IN

SELECT nombre 
FROM producto
WHERE codigo_fabricante IN (1,3,5);

#29 Lista el nombre y el precio de los productos en centimos. Con un alias

SELECT nombre, precio * 100 as Centimos
FROM producto;

##30. Lista los nombres de los fabricantes cuyo nombre empiece por la letra s

SELECT nombre 
FROM fabricante
WHERE nombre LIKE 's%';

##31 Lista los nombres de los fabricantes cuyo nombre termine por la vocal e

SELECT nombre
from fabricante
where nombre like '%e';

## 32. Lista los nombres de los fabricantes cuyo nombre contenga 'w'

SELECT nombre 
FROM fabricante
WHERE nombre LIKE '%w%';


##33 Lista los nombres de los fabricantes cuyo nombre sea de 4 caracteres

SELECT nombre
from fabricante
where nombre like '____';

## 34. Lista los nombres de los fabricantes cuyo nombre contenga 'w'

SELECT nombre 
FROM producto
WHERE nombre LIKE '%Portátil%';

##35 Devuelve una lista con el nombre de todos los productos que contienen la ##cadena monitor en el nombre y tiene un precio inferior a 125

SELECT nombre
    from producto
    where nombre like '%monitor%' and precio < 215;

## 36. Lista el nombre y el precio de todos los productos...

SELECT nombre, precio 
FROM producto
WHERE precio >= 180 ORDER BY precio DESC, nombre ASC;
