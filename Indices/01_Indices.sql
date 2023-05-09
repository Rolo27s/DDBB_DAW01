-- Ejercicios sobre Índices
-- Base de datos: Jardinería
-- 1. Consulte cuáles son los índices que hay en la tabla producto utilizando las dos instrucciones SQL que nos permiten obtener esta información de la tabla.
SHOW INDEXES FROM jardineria.producto;
SHOW INDEX FROM producto FROM Jardineria;
SHOW KEYS FROM producto;

DESCRIBE producto;

-- 2. Haga uso de EXPLAIN para obtener información sobre cómo se están realizando las consultas y diga cuál de las dos consultas realizará menos comparaciones para encontrar el producto que estamos buscando. ¿Cuántas comparaciones se realizan en cada caso? ¿Por qué?.
EXPLAIN SELECT *
FROM producto
WHERE codigo_producto = 'OR-114';

EXPLAIN SELECT *
FROM producto
WHERE nombre = 'Evonimus Pulchellus';

-- Vemos que el campo rows de la primera consulta es 1 y el de la segunda es 276, por tanto, la primera consulta solo realiza una comparacion y es mucho más eficiente.
-- El motivo es porque la primera consulta usa un indice y la segunda revisa la tabla al completo. El campo 'Type' clarifica esta situación. En la primera consulta es const (existe indice), y en la segunda es ALL (se revisa la tabla completa) 

-- 3. Suponga que estamos trabajando con la base de datos jardineria y queremos saber optimizar las siguientes consultas. ¿Cuál de las dos sería más eficiente?. Se recomienda hacer uso de EXPLAIN para obtener información sobre cómo se están realizando las consultas.
EXPLAIN SELECT AVG(total)
FROM pago
WHERE YEAR(fecha_pago) = 2008;

EXPLAIN SELECT AVG(total)
FROM pago
WHERE fecha_pago >= '2008-01-01' AND fecha_pago <= '2008-12-31';

-- La segunda consulta es mas eficiente.
-- Informacion de la primera consulta: type ALL, rows 26, filtered 100. No tiene indices, revisa 26 registros y el where filtra el 100% de los casos
-- Informacion de la segunda consulta: Type ALL, rows 26, filtered 11.11. Todo igual pero el filtered revisa el 11.11% de los casos, por lo que trabaja sobre un espacio acotado y obtendrá antes la solucion.


-- 4. Optimiza la siguiente consulta creando índices cuando sea necesario. Se recomienda hacer uso de EXPLAIN para obtener información sobre cómo se están realizando las consultas.
EXPLAIN SELECT * FROM cliente INNER JOIN pedido
ON cliente.codigo_cliente = pedido.codigo_cliente
WHERE cliente.nombre_cliente LIKE 'A%';

CREATE INDEX idx_cliente_nombre ON cliente(nombre_cliente);


-- 5. ¿Por qué no es posible optimizar el tiempo de ejecución de las siguientes consultas, incluso haciendo uso de índices? Prueba a optimizar dichas consultas con el índice adecuado.
EXPLAIN SELECT * FROM cliente INNER JOIN pedido
ON cliente.codigo_cliente = pedido.codigo_cliente
WHERE cliente.nombre_cliente LIKE '%A%';

EXPLAIN SELECT * FROM cliente INNER JOIN pedido
ON cliente.codigo_cliente = pedido.codigo_cliente
WHERE cliente.nombre_cliente LIKE '%A';

-- No se pueden optimizar consultas si el primer caracter que busca el where es cualquiera (%) porque sería obligatorio revisar cada registro disponible en la tabla.
	-- Se podría plantear un FULLTEXT en cliente.nombre_cliente
	-- ALTER TABLE cliente ADD FULLTEXT(nombre_cliente);
	/*
	SELECT * FROM cliente 
	INNER JOIN pedido
	ON cliente.codigo_cliente = pedido.codigo_cliente
	WHERE MATCH(nombre_cliente) AGAINST('+A*' IN BOOLEAN MODE);
	*/
	-- Esto si mejoraría el rendimiento para base de datos grandes ya que el operador LIKE seguido de cualquier caracter es de las cosas mas lentas que hay
    