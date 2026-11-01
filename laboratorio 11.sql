CREATE DATABASE Ejercicio1;

USE Ejercicio1;
GO


SELECT * FROM Cliente;
SELECT * FROM DetallePedido;
SELECT * FROM Empleado;
SELECT * FROM Pedido;
SELECT * FROM Producto;

SELECT COUNT(*) FROM Cliente;
SELECT COUNT(*) FROM DetallePedido;
SELECT COUNT(*) FROM Empleado;
SELECT COUNT(*) FROM Pedido;
SELECT COUNT(*) FROM Producto;

SELECT ciudad 
FROM Cliente;

-----CANTIDAD DE PERSONAS POR CIUDAD
SELECT ciudad, COUNT(*) AS total_clientes
FROM Cliente
GROUP BY ciudad;


----CLIENTES REALIZARON PEDIDOS


SELECT idCliente
FROM Pedido;

SELECT C.idCliente, C.nombre, apellido, C.ciudad
FROM Cliente C
WHERE C.idCliente IN(
		SELECT P.idCliente
		FROM Pedido P);


SELECT idCliente
FROM Pedido;
SELECT C.idCliente, C.nombre, apellido, C.ciudad
FROM Cliente C
WHERE EXISTS(
		SELECT 1
		FROM Pedido P
		WHERE P.idCliente = C.idCliente);


----CLIENTES QUE NO REALIZARON PEDIDOS
SELECT idCliente
FROM Pedido;

SELECT C.idCliente, C.nombre, apellido, C.ciudad
FROM Cliente C
WHERE NOT EXISTS(
		SELECT 1
		FROM Pedido P
		WHERE P.idCliente = C.idCliente);


---CLIENTES EN LIMA CON PEDIDOS
SELECT C.idCliente, C.nombre, C.apellido, C.ciudad
FROM Cliente C
WHERE C.ciudad = 'Lima'
AND EXISTS(
		SELECT 1
		FROM Pedido P
		WHERE P.idCliente = C.idCliente);





--FECHA

SELECT
	idPedido,
	fechaPedido,
	DAY(fechaPedido) AS Día
FROM Pedido;



---FECHA MES

SELECT
	idPedido,
	fechaPedido,
	MONTH(fechaPedido) AS Día
FROM Pedido;

---AÑO
SELECT
	idPedido,
	fechaPedido,
	YEAR(fechaPedido) AS Día
FROM Pedido;




SELECT
	idPedido,
	fechaPedido,
	DAY(fechaPedido) AS Día,
	MONTH(fechaPedido) AS Mes,
	YEAR(fechaPedido) AS anio
FROM Pedido
WHERE YEAR (fechaPedido)=2026
ORDER BY fechaPedido;


---3

	SELECT GETDATE () As FechaActual;


----
	SELECT
	idCliente,
	nombre,
	fechaRegistro,
	DATEADD(DAY, 30 ,fechaRegistro) AS FechaSeguimiento
	FROM Cliente;




	----BLOQUE 4


	SELECT
		IdCliente,
		CONCAT(nombre, '', apellido) AS NombreCompleto
	FROM Cliente;


-----LEN
SELECT
	idCliente,
	nombre,
	LEN(nombre) AS LongitudNombre
FROM Cliente;



----UPPER

SELECT
	idCliente,
	nombre,
	UPPER(nombre) AS NombreMayusculas
FROM Cliente;


---LTRIM

	SELECT
	'  Carlos' AS TextoOriginal,
	LTRIM('  CARLOS') AS TextoLimpio;



	SELECT
		idCliente,
		UPPER(LTRIM(RTRIM(nombre))) AS NombreNormalizado,
		LOWER(LTRIM(RTRIM(correo))) AS CorreoNormalizado,
		LTRIM (RTRIM(ciudad)) AS CiudadLimpia
	FROM Cliente;



---ESTILO 103 FECHA


SELECT
	idPedido,
	fechaPedido,
	CONVERT(VARCHAR(10), fechaPedido, 103) AS FechaDDMMYYYY
FROM Pedido


---ESTILO 112

SELECT
	idPedido,
	fechaPedido,
	CONVERT(VARCHAR(8), fechaPedido, 112) AS FechaAAAAMMDD
FROM Pedido






