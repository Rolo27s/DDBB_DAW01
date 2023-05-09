INSERT INTO cliente VALUES (NULL, 'Pepe', 'Rubio', 'Gómez', 'Málaga', 300);
INSERT INTO cliente VALUES (15, 'Juan', 'Martín', 'Suárez', 'Málaga', 100);
INSERT INTO cliente VALUES (NULL, 'Lidia', 'Flores', 'Gómez', 'Málaga', 100);
INSERT INTO cliente VALUES (14, 'Lidia', 'Flores', 'Gómez', 'Málaga', 100);

SELECT * FROM cliente;

-- Para borrar la linea con id 12 de la tabla cliente, de la base de datos ventas
DELETE FROM `ventas`.`cliente` WHERE (`id` = '12');

INSERT INTO comercial (nombre, comisión, apellido1) VALUES ('Julian', 0.25, 'Aloa');

-- podemos meter varias lineas escribiendo una sola vez insert into
INSERT INTO comercial (nombre, comisión, apellido1) VALUES
	('Pepa', 0.30, 'Samoa'),
    ('Esther', 0.12, 'Bailar');
    
Select * from comercial;

-- creamos una tabla nueva con los campos de la consulta que vamos a querer guardar. Tiene que coincidir en tipo de variable. Si hay overflow en modo estricto da error.
 CREATE TABLE tabla (
		id INT PRIMARY KEY AUTO_INCREMENT,
        nombrecli varchar(100) not null,
        apellido1cli varchar(100) not null,
        apellido2cli varchar(100) default null,
        nombreco varchar(100) not null,
        apellido1co varchar(100) not null,
        apellido2co varchar(100) default null,
        total double not null,
        fecha date default null);

-- Consulta: Todos los pedidos de todos los clientes con sus comerciales.
SELECT c.nombre, c.apellido1, c.apellido2, co.nombre, co.apellido1, co.apellido2, p.total, p.fecha 
FROM cliente c
JOIN pedido p ON c.id = p.id_cliente
JOIN comercial co ON p.id_comercial = co.id;

-- Copiamos el contenido de la consulta en la tabla
INSERT INTO tabla (nombrecli, apellido1cli, apellido2cli, nombreco, apellido1co, apellido2co, total, fecha)
SELECT c.nombre, c.apellido1, c.apellido2, co.nombre, co.apellido1, co.apellido2, p.total, p.fecha 
FROM cliente c
JOIN pedido p ON c.id = p.id_cliente
JOIN comercial co ON p.id_comercial = co.id;

-- Estariamos viendo una tabla copiada. Sería estático y no se actualizaría.
select * from tabla;

-- Si quiero limpiar la tabla y conservar la estructura:
Truncate tabla;

-- Insertar en comerciales los clientes cuya categoria sea mayor de 200
INSERT INTO comercial (nombre, apellido1, apellido2) select nombre, apellido1, apellido2 from cliente where categoría > 200;

select nombre, apellido1, apellido2 from cliente where categoría > 200;

select * from comercial;
select * from cliente;
select * from pedido;

-- EJEMPLOS DE UPDATE
-- Poner una comision 0.2 a los comerciales con apellido2 Gómez
UPDATE comercial SET comisión = 0.2 WHERE apellido2 = "Gómez";

-- Poner una categoria de 50 a los clientes de sevilla cuyo comercial es 1.
UPDATE cliente SET categoría = 50 WHERE ciudad = "sevilla" AND 
id in (SELECT DISTINCT id_cliente from pedido where id_comercial = 1);

-- EJEMPLOS DE DELETE
-- Borrar clientes cuya ciudad sea malaga
DELETE FROM cliente WHERE ciudad = "huelva";

-- Nos damos cuenta que necesitamos modificar la foreign key a efectos en cascada
alter table pedido drop constraint pedido_ibfk_1;
alter table pedido drop constraint pedido_ibfk_2;
alter table pedido add constraint pedido_ibfk_1 FOREIGN KEY (id_cliente) references cliente (id) on update cascade on delete cascade;
alter table pedido add constraint pedido_ibfk_2 FOREIGN KEY (id_comercial) references comercial (id) on update cascade on delete cascade;

-- borrar pedido del comercial 2
delete from pedido where id_comercial=2;

-- borramos el comercial con id 1 y vemos que los pedidos de el tampoco salen
delete from comercial where id = 1;

-- vamos a poner como nombre JULIO a los clientes que han hecho pedidos en julio de 2017
update cliente set nombre = "JULIO" where exists (select id_cliente from pedido WHERE year(fecha) LIKE "2017" AND pedido.id_cliente=cliente.id);