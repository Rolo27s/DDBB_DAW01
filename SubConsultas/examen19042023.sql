-- examen19042023.sql. ALUMNO: FRANCISCO JOSE RODRIGUEZ LOPEZ.
-- Resuelve las siguientes consultas sobre la base de datos llamada Universidad y Jardinería. (10 ptos, 0.67 por consulta)
-- UNIVERSIDAD

-- 1.	Devuelve un listado con los alumnos de la universidad que nunca se han matriculado de alguna asignatura.
select * from persona p where tipo = "alumno" AND not exists (select id_alumno from alumno_se_matricula_asignatura asm where asm.id_alumno=p.id);

-- 2.	Utilizando al menos una subconsulta, devuelve un listado con los alumnos de la universidad que hayan nacido en el año 1996 o 1997 y nunca se hayan matriculado de alguna asignatura.
select * from persona p where tipo = "alumno" AND not exists (select id_alumno from alumno_se_matricula_asignatura asm where asm.id_alumno=p.id) AND year(p.fecha_nacimiento) IN ('1996', '1997');

-- 3.	Utilizando al menos una subconsulta, devuelve un listado con las asignaturas del grado de Ingeniería Informática en las que se haya matriculado algún alumno.
select asignatura.nombre from asignatura where asignatura.id_grado = (select g.id from grado g where g.nombre like "%Ingeniería Informática%") and 
exists (select asm.id_asignatura from alumno_se_matricula_asignatura asm where asm.id_asignatura=asignatura.id);

	-- 3.1. id de los alumnos que se matricularon de algo
	select p.id from persona p where tipo = "alumno" AND exists (select id_alumno from alumno_se_matricula_asignatura asm where asm.id_alumno=p.id);

-- 4.	Listar los nombres, apellidos y nombre de las asignaturas de l@s alumn@s que se han matriculado en algunas de las asignaturas en que está matriculada Inma Lakin Yundt.
Select p.nombre, p.apellido1, p.apellido2, asig.nombre from persona p
join alumno_se_matricula_asignatura asm on p.id = asm.id_alumno
join asignatura asig on asm.id_asignatura = asig.id
where asm.id_asignatura IN (select asm.id_asignatura from alumno_se_matricula_asignatura asm where asm.id_alumno = (select p.id from persona p where p.nombre = "Inma" and p.apellido1 = "Lakin" and p.apellido2 = "Yundt"));

	-- id de la amiga
	select p.id from persona p where p.nombre = "Inma" and p.apellido1 = "Lakin" and p.apellido2 = "Yundt";

	-- id de asignaturas que da la amiga
    select asm.id_asignatura from alumno_se_matricula_asignatura asm where asm.id_alumno = (select p.id from persona p where p.nombre = "Inma" and p.apellido1 = "Lakin" and p.apellido2 = "Yundt");
 
-- 5.	Muestra los nombres de las asignaturas que tengan 4.5 créditos, el profesor que las imparte y el nombre del grado en el que se imparte.
-- Voy a unir asignatura con left join de profesor y join de grado, asi saldran los nombres de las asignaturas, aunque no tengan profesor asociado.
-- Estrictamente tendría que unir tambien la tabla personas para vincularlo con el id de profesor, pero en este caso se que id es null
select a.nombre, a.creditos, g.nombre ,p.id_profesor from asignatura a
left join profesor p on a.id_profesor = p.id_profesor
join grado g on a.id_grado = g.id
where a.creditos = 4.5;

-- 6.	Muestra   nombre, apellido, tipo y la edad de aquellas personas  cuyos dos primeros caracteres del teléfono coinciden con los de Manolo Hamill

	-- busco la info de la persona de manolo
    select p.telefono from persona p where p.nombre = "Manolo" and p.apellido1 = "Hamill";
    
    -- Se que su numero es 950263514
    
    select p.nombre, p.apellido1, p.tipo, round(datediff(now(), fecha_nacimiento)/365) as edad from persona p where p.telefono like "95%";
    
 -- ----------------------------------
select * from persona;
select * from alumno_se_matricula_asignatura;
select * from grado;
select * from asignatura;
select * from profesor;

-- 7.	Cuánto suman las edades de los profesores que imparten en el grado de *Informática* (no biotecnología) y cuál es la media de edad (AVG), redondeada a 2 decimales, y cuántos profesores son. **Revisar**
select per.nombre, round(datediff(now(), per.fecha_nacimiento)/365) as edad from grado g
join asignatura a on g.id=a.id_grado
join profesor p on a.id_profesor=p.id_profesor
join persona per on p.id_profesor=per.id
where g.nombre like "%Informatica%"
group by per.nombre, edad;

-- JARDINERÍA
-- 1.	Para cada cliente muestra los pedidos realizados,  los productos que contiene cada pedido, la cantidad pedida,  el precio y el total del detalle de cada producto.
select c.nombre_cliente, p.codigo_pedido, count(pro.nombre) as tipo_productos, sum(dp.cantidad) as num_tot_productos_en_pedido, sum(dp.cantidad * dp.precio_unidad) as precio_de_pedido from cliente c
join pedido p on c.codigo_cliente = p.codigo_cliente
join detalle_pedido dp on p.codigo_pedido=dp.codigo_pedido
join producto pro on dp.codigo_producto=pro.codigo_producto
group by p.codigo_pedido;
	
    -- Uní desde cliente hasta producto

-- 2.	Muestra el código, la ciudad y el teléfono de las oficinas donde trabajan los representantes de ventas de aquéllos  clientes que han realizado la compra de alguna herramienta.
select distinct o.codigo_oficina, o.ciudad, o.telefono from cliente c
join pedido p on c.codigo_cliente = p.codigo_cliente
join detalle_pedido dp on p.codigo_pedido=dp.codigo_pedido
join producto pro on dp.codigo_producto=pro.codigo_producto
join empleado e on c.codigo_empleado_rep_ventas=e.codigo_empleado
join oficina o on e.codigo_oficina=o.codigo_oficina
where c.codigo_empleado_rep_ventas = any (
	select distinct codigo_empleado_rep_ventas from cliente where codigo_cliente = any(select codigo_cliente from pedido where codigo_pedido = any (select codigo_pedido from detalle_pedido where codigo_producto = any (select codigo_producto from producto where gama = "Herramientas")))
);

	-- id de rep de venta de cliente que compro herramienta
    select cliente.codigo_empleado_rep_ventas from cliente where codigo_cliente ;
    
    -- codigo de producto de la gama herramientas
    select codigo_producto, gama from producto where gama = "Herramientas";

	-- codigo de pedido que contenga herramientas
    select codigo_pedido, codigo_producto from detalle_pedido where codigo_producto = any (select codigo_producto from producto where gama = "Herramientas");

	-- pedido de herramientas y relacionado con codigo cliente 
	select codigo_cliente, codigo_pedido from pedido where codigo_pedido = any (select codigo_pedido from detalle_pedido where codigo_producto = any (select codigo_producto from producto where gama = "Herramientas"));

	-- codigo de representante que el cliente pidio herramienta
    select distinct codigo_empleado_rep_ventas from cliente where codigo_cliente = any(select codigo_cliente from pedido where codigo_pedido = any (select codigo_pedido from detalle_pedido where codigo_producto = any (select codigo_producto from producto where gama = "Herramientas")));

select * from cliente;
select * from pedido;
select * from detalle_pedido;
select * from producto;
select * from pago;

-- 3.	Muestra el nombre y la cantidad de veces que se ha pedido un producto al menos una vez
select nombre, count(nombre) as cantidad  from producto where exists (select detalle_pedido.codigo_producto from detalle_pedido where(producto.codigo_producto=detalle_pedido.codigo_producto))
group by nombre;

-- 4.	Mostrar lo que ha pagado cada cliente en cada año, si lo pagado excede de 3000
select pago.codigo_cliente, c.nombre_cliente, sum(total) as total from pago
join cliente c on pago.codigo_cliente = c.codigo_cliente 
 where total > 3000 group by codigo_cliente, fecha_pago;

-- 5.	Mostrar el número de productos que tiene cada gama
select gama, count(*) total_productos_de_gama from producto group by gama;

-- 6.	Muestra el código, nombre y gama de los productos que nunca se han pedido
select codigo_producto, nombre, gama from producto where not exists (select detalle_pedido.codigo_producto from detalle_pedido where(producto.codigo_producto=detalle_pedido.codigo_producto));

-- 7.	Mostrar el código y estado de los pedidos donde se haya vendido productos cuyo precio de venta sea igual al del producto de la gama ‘frutales’ más caro.
select * from detalle_pedido dp
join producto p on dp.codigo_producto=p.codigo_producto
join pedido ped on ped.codigo_pedido=dp.codigo_pedido
where p.precio_venta = (
select producto.precio_venta from producto where producto.gama = "Frutales"
    order by 1 desc
    limit 1
);

	-- Localizo el precio mas caro de la gama frutales
	select producto.precio_venta from producto where producto.gama = "Frutales"
    order by 1 desc
    limit 1;
-- 8.	Mostrar el código y comentarios de los pedidos donde el total del pedido sea superior a la media de todos los pedidos
