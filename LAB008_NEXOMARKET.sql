CREATE DATABASE NEXOMARKET;
GO

USE NEXOMARKET;


select count (*) as
TOTALREGISTROS
FROM PRODUCTOS


SELECT COUNT(*) AS totalRegistros FROM PRODUCTOS;
SELECT TOP 10 * FROM PRODUCTOS;


----RETO 1

SELECT COUNT (*) PRODUCTOSACTIVOSSTOCK
FROM PRODUCTOS
WHERE estado = 'ACTIVO'
AND stock > 0;


SELECT COUNT (*) PRODUCTOSACTIVOSSTOCK
FROM PRODUCTOS
WHERE estado = 'ACTIVO'
OR stock > 0;


SELECT DISTINCT categoria
FROM PRODUCTOS
ORDER BY categoria;



---RETO 2

SELECT 
idOferta,
nombre,
categoria,
marca,
precio,
stock
FROM PRODUCTOS
WHERE categoria IN(
	'Laptops',
	'Tablets',
	'Smartphones'
	);


--- RETO 3


WHERE precio BETWEEN 1500 AND 3000
ORDER BY precio DESC;


---RETO 4


SELECT

	idOferta,
	nombre,
	categoria,
	marca,
	precio
FROM PRODUCTOS
WHERE nombre LIKE '%Pro%';

--- RETO 5

SELECT * FROM  PRODUCTOS
WHERE proveedor IS NULL;


---RETO 6 

SELECT DISTINCT marca
FROM PRODUCTOS
ORDER BY marca;





SELECT DISTINCT ciudad
FROM PRODUCTOS
ORDER BY ciudad;


SELECT DISTINCT categoria
FROM PRODUCTOS
ORDER BY categoria;





---RETO 7 

SELECT TOP 10
	idOferta,
	nombre,
	categoria,
	marca,
	precio,
	stock

FROM PRODUCTOS
WHERE estado = 'ACTIVO'
AND stock > 0
ORDER BY precio DESC;




---RETO 8 

SELECT TOP 20
	idOferta,
	nombre,
	categoria,
	precio,

	CASE
		WHEN precio < 1500 THEN 'ECONOMICO'
		WHEN precio BETWEEN 1500 AND 300 THEN 'MEDIO'
		ELSE 'PREMIUM'
	END AS segmentoPrecio
FROM PRODUCTOS;





SELECT TOP 20
	idOferta,
	nombre,
	categoria,
	stock,

	CASE
		WHEN stock = 0 THEN 'AGOTADO'
		WHEN stock BETWEEN 1 AND 10 THEN 'CRITICO'
		WHEN stock BETWEEN 11 AND 30 THEN 'BAJO'

		ELSE 'DISPONIBLE'
	END AS estadoStock
FROM PRODUCTOS;


---VISTA


CREATE OR ALTER VIEW vw_DecisionRoom
AS
SELECT
	idOferta,
	nombre,
	categoria,
	marca,
	precio,
	costo,
	stock,
	ventas30dias,
	rating,
	ciudad,

	CASE
		WHEN precio < 1500 THEN 'ECONOMICO'
		WHEN precio BETWEEN 1500 AND 300 THEN 'MEDIO'
		ELSE 'PREMIUM'
	END AS segmentoPrecio,


	CASE
		WHEN stock = 0 THEN 'AGOTADO'
		WHEN stock BETWEEN 1 AND 10 THEN 'CRITICO'
		WHEN stock BETWEEN 11 AND 30 THEN 'BAJO'

		ELSE 'DISPONIBLE'
	END AS estadoStock,

	precio * stock AS ValorInventario

FROM PRODUCTOS
WHERE estado <> 'DESCONTINUADO';
GO



SELECT * FROM vw_DecisionRoom;



SELECT TOP 20 *
FROM vw_DecisionRoom
ORDER BY ventas30dias DESC;



----------------------------

SELECT
    estadoStock,
    COUNT(*) AS cantidadProductos
FROM vw_DecisionRoom
GROUP BY estadoStock
ORDER BY cantidadProductos DESC;


/*-----------------------------------------------------------
  2. SELECCIONAR LOS 100 PRODUCTOS DE MAYOR VENTA
     QUE ACTUALMENTE TIENEN STOCK > 30
-----------------------------------------------------------*/

;WITH ProductosCambiar AS
(
    SELECT TOP (100)
        idOferta
    FROM PRODUCTOS
    WHERE stock > 30
      AND estado <> 'DESCONTINUADO'
    ORDER BY ventas30dias DESC
)


/*-----------------------------------------------------------
  3. CAMBIAR SU STOCK A 5

     Stock = 5 hará que la VIEW los clasifique
     automáticamente como CRITICO.
-----------------------------------------------------------*/

UPDATE P
SET P.stock = 5
FROM PRODUCTOS AS P
INNER JOIN ProductosCambiar AS C
    ON P.idOferta = C.idOferta;

GO


/*-----------------------------------------------------------
  4. COMPROBAR EL CAMBIO
-----------------------------------------------------------*/

SELECT
    estadoStock,
    COUNT(*) AS cantidadProductos
FROM vw_DecisionRoom
GROUP BY estadoStock
ORDER BY cantidadProductos DESC;
