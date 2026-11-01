CREAR BASE DE DATOS:

LA BASE DE DATOS ES EJERCICIO 1, CONTIENE 5 ARCHIVOS CSV
  
CREATE DATABABASE [NOMBRE_DE_LA_BASE_DE_DATOS];
GO

Después de crear una base de datos utilizamos el use para ingresar y trabajar con dicha base de datos 

USE institucion;
GO  -- Le dices a SQL Server: "Entra a la base de datos AHORA MISMO"
  
=====================================================================================================================

Consultas Básicas y Filtrado
SE SELECCIOAN EL NOMBRE DEL ARCHIVO CVS DE DONDE SE DESEA OBTENER LA CONSULTA
SELECT * FROM BaseDeDatos;
SELECT * FROM ArchivoCSV;


Filtrar por ciudad: Muestra el nombre, apellido y correo de los clientes que vivan en la ciudad de
Aquí se seleecionan los nombres de la colummas nombre, apellido, correo  
SELECT nombre, apellido, correo 
FROM Cliente 
WHERE ciudad = 'Lima';

Productos en stock: Encuentra todos los productos cuyo stock sea menor a 10 unidades para saber qué reponer.
SELECT nombreProducto, stock, precio 
FROM Producto 
WHERE stock < 10;


Ordenar sueldos: Muestra a los empleados ordenados de mayor a menor sueldo.
SELECT nombre, apellido, sueldo 
FROM Empleado 
ORDER BY sueldo DESC;


Para mostrar todas las ciudades sin que se repitan (eliminar duplicados), debes utilizar la cláusula DISTINCT en SQL
SELECT DISTINCT ciudad 
FROM Cliente;
============================================================================================================


Funciones de Agregación y Agrupamiento
  
Total de clientes:
SELECT COUNT(*) AS TotalClientes 
FROM Cliente;


Promedio de sueldos : Calcula el sueldo promedio de los empleados de la empresa
SELECT AVG(sueldo) AS SueldoPromedio 
FROM Empleado;


Productos por categoría: Cuenta cuántos productos hay en cada categoría.
SELECT categoria, COUNT(*) AS CantidadProductos 
FROM Producto 
GROUP BY categoria;


Suma de stock : Obtiene el total de stock disponible sumando todos los productos de la tabla
SELECT SUM(stock) AS StockTotal 
FROM Producto;



==============================================================================================================

Uniones de Tablas - INNER JOIN
  
Pedidos y sus Clientes: Muestra el ID del pedido, la fecha, y el nombre y apellido del cliente que lo realizó
SELECT p.idPedido, p.fechaPedido, c.nombre, c.apellido
FROM Pedido p
INNER JOIN Cliente c ON p.idCliente = c.idCliente;

Detalle de los Pedidos: Muestra qué productos se compraron en cada pedido, incluyendo la cantidad y el precio unitario
SELECT dp.idPedido, pr.nombreProducto, dp.cantidad, dp.precioUnitario
FROM DetallePedido dp
INNER JOIN Producto pr ON dp.idProducto = pr.idProducto;

====================================================================================================================
---------------------------------------------------------
MOFIDICAR TABLA
ALTER TABLE
La sentencia ALTER TABLE en SQL sirve para modificar la estructura de una tabla que ya existe (agregar columnas, eliminarlas,
cambiar tipos de datos o modificar restricciones) sin perder los datos almacenados en ella. 

---------------------------------------------------------

CAMBIAR EL NOMBRE DE UNA COLUMNA
Sp_rename ‘nombreTabla, nombre de la columna actual,’ ‘nuevo nombre’, ‘column’;

EXEC sp_rename 'NombreTabla.NombreColumnaActual', 'NuevoNombreColumna', 'COLUMN';
EXEC sp_rename 'Usuarios.telefono', 'celular', 'COLUMN';

------------------------------------------------------------

AGREGAR UNA NUEVA COLUMNA

ALTER TABLE Usuarios
ADD email VARCHAR(100);

BORRAR UNA COLUMNA
ALTER TABLE Usuarios
DROP COLUMN email;

-----------------------------------------------------------
BORRAR TABLA 
DROP TABLE [NOMBRE DE LA TABLA];
DROP TABLE Matricula; 

BORRAR TABLAS EN UNA SOLA LÍNEA
DROP TABLE Matricula, Estudiante, Curso;


-------------------------------------------
CONSULTAR QUE LOS REGISTROS SE INSERTARON CORRECTAMENTE
Se deben crear previamente las tablas
SELECT * FROM Estudiante;

-----------------------------------------------








