/*1*/
SELECT codigo_oficina, ciudad FROM oficina;

/*2*/
SELECT ciudad, telefono FROM oficina
WHERE pais LIKE "españa";

/*3*/
SELECT nombre, apellido1, apellido2, email FROM empleado
WHERE codigo_jefe = 7;

/*4*/
SELECT puesto, nombre, apellido1, apellido2, email FROM empleado
WHERE puesto LIKE "director general";

/*5*/
SELECT nombre, apellido1, apellido2, puesto FROM empleado
WHERE puesto NOT LIKE "representante ventas";

/*6*/
SELECT nombre_cliente FROM cliente
WHERE pais LIKE "spain";

/*7*/
SELECT DISTINCT estado FROM pedido;

/*8 con funcion year*/
SELECT DISTINCT codigo_cliente FROM pago
WHERE year(fecha_pago) = 2008;

/*8 con funcion data_format*/
SELECT DISTINCT codigo_cliente FROM pago
WHERE date_format(fecha_pago, "%Y") = 2008;

/*8 conotra funcion*/
SELECT DISTINCT codigo_cliente FROM pago
WHERE fecha_pago >= "2008-01-01" AND fecha_pago >= "2008-12-31";

/*9*/
SELECT DISTINCT codigo_pedido, codigo_cliente, fecha_esperada, fecha_entrega FROM pedido
WHERE fecha_entrega > fecha_esperada;

/*10 con funcion adddate*/
SELECT DISTINCT codigo_pedido, codigo_cliente, fecha_esperada, fecha_entrega FROM pedido
WHERE adddate(fecha_entrega, 2) <= fecha_esperada;

/*10 con funcion datediff*/
SELECT DISTINCT codigo_pedido, codigo_cliente, fecha_esperada, fecha_entrega FROM pedido
WHERE  datediff(fecha_esperada, fecha_entrega) >= 2;

/*11*/
SELECT * FROM pedido
WHERE estado LIKE "rechazado";

/*12*/
SELECT * FROM pedido
WHERE estado LIKE "entregado" AND month(fecha_entrega) = 1;

/*13*/
SELECT * FROM pago
WHERE year(fecha_pago) = 2008 AND forma_pago LIKE "paypal"
ORDER BY total DESC;

/*14*/
SELECT DISTINCT forma_pago FROM pago;

/*15*/
SELECT * FROM producto
WHERE gama LIKE "ornamentales" AND cantidad_en_stock > 100 
ORDER BY precio_venta DESC;

/*16*/
SELECT * FROM cliente
WHERE ciudad LIKE "madrid" AND (codigo_empleado_rep_ventas = 11 OR codigo_empleado_rep_ventas = 30);