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

SELECT * FROM fabricante, producto;

/*1*/
SELECT nombre FROM producto;

/*2*/
SELECT nombre, precio FROM producto;

/*3*/
SELECT * FROM producto;

/*4*/
SELECT nombre, precio AS euros, precio*1.09 AS dolares FROM producto;

/*5*/
SELECT nombre AS "nombre de productos", precio AS euros, precio*1.09 AS dolares FROM producto;

/*6*/
SELECT UPPER(nombre), precio FROM producto;

/*7*/
SELECT LOWER(nombre), precio FROM producto;

/*8*/
SELECT nombre, upper(left(nombre, 2))  FROM fabricante;
SELECT nombre, left(upper(nombre), 2)  FROM fabricante;

/*9*/
SELECT nombre, round(precio)  FROM producto;

/*10*/
SELECT nombre, truncate(precio, 0)  FROM producto;

/*11*/
SELECT codigo_fabricante FROM producto;

/*12*/
SELECT  DISTINCT codigo_fabricante FROM producto;

/*13*/
SELECT nombre FROM fabricante ORDER BY nombre asc;

/*14*/
SELECT nombre FROM fabricante ORDER BY nombre desc;

/*15*/
SELECT nombre, precio FROM producto ORDER BY nombre asc, precio desc;

/*16*/
SELECT nombre FROM fabricante limit 5;

/*17*/
SELECT nombre FROM fabricante limit 3,2;

/*18*/
SELECT nombre, precio FROM producto 
ORDER BY precio asc 
limit 1;

/*19*/
SELECT nombre, precio FROM producto 
ORDER BY precio desc 
limit 1;

/*20*/
SELECT nombre FROM producto
where codigo_fabricante = 2;

/*21*/
SELECT nombre FROM producto
where precio <= 120;

/*22*/
SELECT nombre FROM producto
where precio >= 400;

/*23*/
SELECT nombre FROM producto
where precio < 400;

/*24*/
SELECT nombre FROM producto
where precio >= 80 and precio <=300;

/*25*/
SELECT nombre FROM producto
where precio BETWEEN 60 and 200;

/*26*/
SELECT nombre FROM producto
where precio >200 and codigo_fabricante = 6;

/*27*/
SELECT nombre FROM producto
where codigo_fabricante = 1 or codigo_fabricante = 3 or codigo_fabricante = 5;

/*28*/
SELECT nombre FROM producto
where codigo_fabricante IN (1,3,5);

/*29*/
SELECT nombre, precio*100 AS centimos FROM producto;

/*30*/
SELECT nombre FROM fabricante
WHERE nombre LIKE "s%";

/*31*/
SELECT nombre FROM fabricante
WHERE nombre LIKE "%e";

/*32*/
SELECT nombre FROM fabricante
WHERE nombre LIKE "%w%";

/*33*/
SELECT nombre FROM fabricante
WHERE nombre LIKE "____";

/*34*/
SELECT nombre FROM producto
WHERE nombre LIKE "%portatil%";

/*35*/
SELECT nombre FROM producto
WHERE nombre LIKE "%monitor%" and precio <215;

/*36*/
SELECT nombre, precio FROM producto
WHERE precio >=180
ORDER BY precio desc, nombre asc;