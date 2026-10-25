
--Paso 1: abrir una nueva consulta

USE BD_NEXOMARKET_S11_RAW;
GO

-- Productos con descripciones inconsistentes
SELECT idProducto
FROM dbo.VENTAS_ORIGEN
GROUP BY idProducto
HAVING COUNT(DISTINCT nombreProducto) > 1
    OR COUNT(DISTINCT categoria) > 1
    OR COUNT(DISTINCT precioLista) > 1;

-- Clientes con segmentos inconsistentes
SELECT idCliente
FROM dbo.VENTAS_ORIGEN
GROUP BY idCliente
HAVING COUNT(DISTINCT segmentoCliente) > 1;

-- Tiendas con ciudades inconsistentes
SELECT idTienda
FROM dbo.VENTAS_ORIGEN
GROUP BY idTienda
HAVING COUNT(DISTINCT ciudad) > 1;


--Paso 2: crear las cuatro dimensiones

USE BD_NEXOMARKET_S11_RAW;
GO

-- DIMENSIÓN PRODUCTO
CREATE TABLE dbo.DIM_PRODUCTO (
    idProducto INT NOT NULL PRIMARY KEY,
    nombreProducto NVARCHAR(100),
    categoria NVARCHAR(100),
    precioLista DECIMAL(18,2)
);

-- DIMENSIÓN CLIENTE
CREATE TABLE dbo.DIM_CLIENTE (
    idCliente INT NOT NULL PRIMARY KEY,
    segmentoCliente NVARCHAR(100)
);

-- DIMENSIÓN TIENDA
CREATE TABLE dbo.DIM_TIENDA (
    idTienda INT NOT NULL PRIMARY KEY,
    ciudad NVARCHAR(100)
);

-- DIMENSIÓN FECHA
CREATE TABLE dbo.DIM_FECHA (
    fechaVenta DATE NOT NULL PRIMARY KEY,
    anio INT,
    trimestre INT,
    mes INT,
    dia INT
);


---Paso 3: cargar las dimensiones

-- Productos
INSERT INTO dbo.DIM_PRODUCTO
SELECT DISTINCT
    idProducto,
    nombreProducto,
    categoria,
    precioLista
FROM dbo.VENTAS_ORIGEN;

-- Clientes
INSERT INTO dbo.DIM_CLIENTE
SELECT DISTINCT
    idCliente,
    segmentoCliente
FROM dbo.VENTAS_ORIGEN;

-- Tiendas
INSERT INTO dbo.DIM_TIENDA
SELECT DISTINCT
    idTienda,
    ciudad
FROM dbo.VENTAS_ORIGEN;

-- Fechas
INSERT INTO dbo.DIM_FECHA
SELECT DISTINCT
    fechaVenta,
    YEAR(fechaVenta),
    DATEPART(QUARTER, fechaVenta),
    MONTH(fechaVenta),
    DAY(fechaVenta)
FROM dbo.VENTAS_ORIGEN;

SELECT COUNT(*) AS productos FROM dbo.DIM_PRODUCTO;
SELECT COUNT(*) AS clientes FROM dbo.DIM_CLIENTE;
SELECT COUNT(*) AS tiendas FROM dbo.DIM_TIENDA;
SELECT COUNT(*) AS fechas FROM dbo.DIM_FECHA;

--Paso 4: crear la tabla central FACT_VENTA

CREATE TABLE dbo.FACT_VENTA (
    idVenta INT NOT NULL PRIMARY KEY,
    fechaVenta DATE NOT NULL,
    idProducto INT NOT NULL,
    idCliente INT NOT NULL,
    idTienda INT NOT NULL,
    canal NVARCHAR(50),
    cantidad INT,
    precioUnitario DECIMAL(18,2),
    importeTotal DECIMAL(18,2),

    CONSTRAINT FK_VENTA_PRODUCTO
        FOREIGN KEY (idProducto)
        REFERENCES dbo.DIM_PRODUCTO(idProducto),

    CONSTRAINT FK_VENTA_CLIENTE
        FOREIGN KEY (idCliente)
        REFERENCES dbo.DIM_CLIENTE(idCliente),

    CONSTRAINT FK_VENTA_TIENDA
        FOREIGN KEY (idTienda)
        REFERENCES dbo.DIM_TIENDA(idTienda),

    CONSTRAINT FK_VENTA_FECHA
        FOREIGN KEY (fechaVenta)
        REFERENCES dbo.DIM_FECHA(fechaVenta)
);


--Paso 5: cargar las 500 000 ventas

INSERT INTO dbo.FACT_VENTA (
    idVenta,
    fechaVenta,
    idProducto,
    idCliente,
    idTienda,
    canal,
    cantidad,
    precioUnitario,
    importeTotal
)
SELECT
    idVenta,
    fechaVenta,
    idProducto,
    idCliente,
    idTienda,
    canal,
    cantidad,
    precioUnitario,
    importeTotal
FROM dbo.VENTAS_ORIGEN;

SELECT COUNT_BIG(*) AS totalHechos
FROM dbo.FACT_VENTA;

--Paso 6: generar el diagrama estrella visualmente en SSMS

-- Paso 7: comprobar que el modelo funciona con JOIN

SELECT
    t.ciudad,
    p.categoria,
    COUNT_BIG(*) AS operaciones,
    SUM(f.cantidad) AS unidades,
    SUM(f.importeTotal) AS ingresos
FROM dbo.FACT_VENTA AS f
INNER JOIN dbo.DIM_PRODUCTO AS p
    ON f.idProducto = p.idProducto
INNER JOIN dbo.DIM_TIENDA AS t
    ON f.idTienda = t.idTienda
GROUP BY
    t.ciudad,
    p.categoria
ORDER BY ingresos DESC;


--- Validacion final

SELECT SUM(importeTotal) AS ingresosOrigen
FROM dbo.VENTAS_ORIGEN;

SELECT SUM(importeTotal) AS ingresosModelo
FROM dbo.FACT_VENTA;
