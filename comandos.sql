CREAR BASE DE DATOS:

LA BASE DE DATOS ES EJERCICIO 1, CONTIENE 5 ARCHIVOS CSV
  
CREATE DATABABASE [NOMBRE_DE_LA_BASE_DE_DATOS];
GO

Después de crear una base de datos utilizamos el use para ingresar y trabajar con dicha base de datos 

USE institucion;
GO  -- Le dices a SQL Server: "Entra a la base de datos AHORA MISMO"


---CONSULTA BASICA
SE SELECCIOAN EL NOMBRE DEL ARCHIVO CVS DE DONDE SE DESEA OBTENER LA CONSULTA
SELECT * FROM BaseDeDatos;
SELECT * FROM ArchivoCSV;


Filtrar por ciudad: Muestra el nombre, apellido y correo de los clientes que vivan en la ciudad de
SELECT nombre, apellido, correo 
FROM Cliente 
WHERE ciudad = 'Lima';











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








