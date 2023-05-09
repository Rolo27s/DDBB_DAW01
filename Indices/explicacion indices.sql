-- BD JARDINERÍA
-- Parece ser que hay una regla general que si una consulta esta devolviendo sobre un 5-10% del total de la tabla ya suele
-- empezar a ser interesante el uso de indices.

describe cliente;
SHOW INDEX FROM cliente;

CREATE INDEX idx_pais ON cliente(pais);
DROP INDEX idx_pais ON cliente;

-- Esta sentencia explica como esta funcionando la consulta. Vemos que funciona distinto si tenemos creado un indice o no.
EXPLAIN SELECT nombre_contacto, telefono
FROM cliente
WHERE pais = 'France';


EXPLAIN SELECT * FROM producto
WHERE nombre LIKE '%acero%' OR descripcion LIKE '%acero%';

-- char, varchar y text pueden usar un fulltext index
CREATE FULLTEXT INDEX idx_nombre_descripcion ON producto(nombre, descripcion);

describe producto;
SHOW INDEX FROM producto;

-- Match y against solo sirven previo fulltext index.
EXPLAIN SELECT *
FROM producto
WHERE MATCH(nombre, descripcion) AGAINST ('acero');

-- BD01JUEGOS
/* Tb se puede crear índices  por ejemplo:*/
CREATE INDEX ind_juego ON juego(nombre);

 ALTER TABLE juego
 DROP INDEX ind_juego,
 ADD INDEX indice_juego (fechacompra desc, nombre asc);
 
 SHOW INDEX FROM juego;
 
 /* cambiar la tabla personal y añadir un nuevo campo DNI que sea único( clave alternativa) comprobar que se genera un nuevo índice*/
 ALTER TABLE personal  ADD dni CHAR(9) UNIQUE;
 SHOW INDEX FROM personal;
 
/* Eliminar un índice*/
ALTER TABLE personal DROP INDEX dni;