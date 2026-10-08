CREATE DATABASE ComercioLibros;
GO

USE ComercioLibros;
Go

SELECT * FROM PRODUCTO_WEB_STAGE;


SELECT COUNT(*) AS TotalRegistros
FROM PRODUCTO_WEB_STAGE;

EXEC sp_help 'PRODUCTO_WEB_STAGE ';
GO


---BLOQUE C


SELECT TOP 10 * FROM PRODUCTO_WEB_STAGE;
GO

SELECT 
nombre, 
precio,
disponibilidad
FROM PRODUCTO_WEB_STAGE;
GO


----ALIAS

SELECT 
	nombre As Producto
FROM PRODUCTO_WEB_STAGE;
GO

----DISTING 1

SELECT DISTINCT 
disponibilidad
FROM PRODUCTO_WEB_STAGE;
GO


----CALIFICACION
SELECT DISTINCT 
calificacion
FROM PRODUCTO_WEB_STAGE;
GO

---- WHERE

SELECT nombre,
precio,
calificacion
FROM PRODUCTO_WEB_STAGE
WHERE calificacion = 5;
GO


SELECT nombre,
precio,
calificacion
FROM PRODUCTO_WEB_STAGE
WHERE calificacion = 1
or calificacion = 5;
GO

SELECT nombre, precio, calificacion
FROM PRODUCTO_WEB_STAGE
WHERE calificacion < 1 OR calificacion > 5;
GO



-------in
SELECT
nombre,
precio,
calificacion
FROM PRODUCTO_WEB_STAGE
WHERE precio < = 0;
GO


SELECT
nombre,
precio,
calificacion
FROM PRODUCTO_WEB_STAGE
WHERE calificacion in( 4,5)
or precio < 25;
GO



------between
SELECT
nombre,
precio,
calificacion
FROM PRODUCTO_WEB_STAGE
WHERE precio between 20 and 30
order by precio;
GO

--like

select 
nombre,
precio
from PRODUCTO_WEB_STAGE
where nombre like '%Secret%';
go


select top 10
nombre,
precio,
calificacion
from PRODUCTO_WEB_STAGE
where calificacion = 5
order by precio asc;
go

select top 10
nombre,
precio,
calificacion
from PRODUCTO_WEB_STAGE
order by precio desc;
go




SELECT TOP 10
nombre,
precio  As PrecioOriginal,
TRY_CAST (precio AS DECIMAL(10,2)) As PrecioDecimal
from PRODUCTO_WEB_STAGE
go

------
SELECT TOP 10
nombre, len(nombre) LongitudNombre
from PRODUCTO_WEB_STAGE
order by len(nombre) desc;
go


---sección D



CREATE TABLE PRODUCTO_DML(
id_producto int identity(1,1) primary key,
nombre nvarchar(500) not null,
precio decimal(10,2) not null,check(precio>0),
disponibilidad nvarchar(100) null,
calificacion tinyint not null check (calificacion BETWEEN 1 and 5),
url nvarchar(1000) null, stock int not null default (10) CHECK (stock >=0),
estado varchar(10) not null default ('ACTIVO'),
check (estado in ('ACTIVO', 'INACTIVO'))
);
GO


SELECT * FROM PRODUCTO_DML;


---COPIAR DATOS

INSERT INTO PRODUCTO_DML(
nombre,
precio,
disponibilidad,
calificacion,
url)
from PRODUCTO_WEB_STAGE



SELECT LTRIM(RTRIM(nombre))
CAST (precio as decimal(10,2)),
LTRIM(RTRIM(disponibilidad)),
calificacion,
url from PRODUCTO_WEB_STAGE
where nombre is not null and 
LTRIM(RTRIM(nombre)) <>''
and precio > 0
and calificacion BETWEEN 1 AND 5;

INSERT INTO PRODUCTO_DML (nombre, precio, disponibilidad, calificacion, url)
SELECT 
    LTRIM(RTRIM(nombre)),
    TRY_CAST(precio AS DECIMAL(10,2)),
    LTRIM(RTRIM(disponibilidad)),
    calificacion,
    url 
FROM PRODUCTO_WEB_STAGE
WHERE nombre IS NOT NULL 
  AND LTRIM(RTRIM(nombre)) <> ''
  AND precio > 0
  AND calificacion BETWEEN 1 AND 5;

SELECT @@ROWCOUNT AS FilasInsertadasDesdeStage;
go

);


SELECT * FROM PRODUCTO_DML;

-----------E8

SELECT * FROM PRODUCTO_DML WHERE id_producto = 1;



UPDATE PRODUCTO_DML SET stock = 15 WHERE id_producto = 1;
SELECT @@ROWCOUNT AS FilasModificadas;



SELECT * FROM PRODUCTO_DML WHERE id_producto = 1;

----------E9


SELECT * FROM PRODUCTO_DML WHERE id_producto = 1000;


DELETE FROM PRODUCTO_DML WHERE id_producto = 1000;
SELECT @@ROWCOUNT AS FilasEliminadas;


SELECT * FROM PRODUCTO_DML WHERE id_producto = 1000;


-----E10
TRUNCATE TABLE PRODUCTO_DML;
SELECT COUNT(*) AS TotalRegistros FROM PRODUCTO_DML;





-------E11

INSERT INTO PRODUCTO_DML (nombre, precio, calificacion, stock, estado)
VALUES ('Libro Coquito', -15.00, 20, 5, 'ACTIVO');







