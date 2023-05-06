# Consultas con cláusulas tipo DML
## Tip util. Como hacer una Primary key AUTO_INCREMENT
```sql
1. ALTER TABLE nombre_tabla DROP PRIMARY KEY;
2. ALTER TABLE nombre_tabla ADD nueva_columna INT auto_increment PRIMARY KEY;
3. UPDATE nombre_tabla SET nueva_columna = antigua_columna;
4. ALTER TABLE nombre_tabla DROP COLUMN antigua_columna;
```
