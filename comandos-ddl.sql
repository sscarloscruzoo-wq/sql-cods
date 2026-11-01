CREAR BASE DE DATOS:

LA BASE DE DATOS ES EJERCICIO 1, CONTIENE 5 ARCHIVOS CSV
  
CREATE DATABABASE [NOMBRE_DE_LA_BASE_DE_DATOS];
GO

Después de crear una base de datos utilizamos el use para ingresar y trabajar con dicha base de datos 

USE institucion;
GO  -- Le dices a SQL Server: "Entra a la base de datos AHORA MISMO"
  
================================================================================================================
                                                    CREATE TABLE
================================================================================================================

1. CREATE TABLE (Crear tablas)
Aquí es donde aplicamos todo lo que vimos: definimos las columnas, sus tipos de datos, las PK (Llaves Primarias)
y las FK (Llaves Foráneas) para conectar las tablas tal como en tus CSV.

-- 1. Tabla Cliente (Independiente)
CREATE TABLE Cliente (
    idCliente INT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    ciudad VARCHAR(50),
    correo VARCHAR(100),
    fechaRegistro DATE
);

-- 2. Tabla Empleado (Independiente)
CREATE TABLE Empleado (
    idEmpleado INT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    fechaIngreso DATE,
    sueldo DECIMAL(10, 2),
    idDepartamento INT
);

-- 3. Tabla Producto (Independiente)
CREATE TABLE Producto (
    idProducto INT PRIMARY KEY,
    nombreProducto VARCHAR(100) NOT NULL,
    categoria VARCHAR(50),
    precio DECIMAL(10, 2),
    stock INT
);

-- 4. Tabla Pedido (Depende de Cliente mediante FK)
CREATE TABLE Pedido (
    idPedido INT PRIMARY KEY,
    idCliente INT,
    fechaPedido DATE,
    estado VARCHAR(30),
    CONSTRAINT FK_Pedido_Cliente FOREIGN KEY (idCliente) 
        REFERENCES Cliente(idCliente)
);

-- 5. Tabla DetallePedido (Tiene una clave compuesta y depende de Pedido y Producto)
CREATE TABLE DetallePedido (
    idDetalle INT,
    idPedido INT,
    idProducto INT,
    cantidad INT,
    precioUnitario DECIMAL(10, 2),
    -- Definimos una Clave Primaria Compuesta
    PRIMARY KEY (idDetalle, idPedido),
    -- Llaves foráneas que conectan con sus tablas maestras
    CONSTRAINT FK_Detalle_Pedido FOREIGN KEY (idPedido) 
        REFERENCES Pedido(idPedido),
    CONSTRAINT FK_Detalle_Producto FOREIGN KEY (idProducto) 
        REFERENCES Producto(idProducto)
);

=========================================================================================================================================================
                                                                  ALTER TABLE
  =========================================================================================================================================================

2. ALTER TABLE (Modificar la estructura de una tabla existente)
El comando ALTER TABLE te permite agregar columnas, borrarlas, cambiarles el tipo de dato o añadir restricciones (PRIMARY KEY, FOREIGN KEY, CHECK, etc.)
a una tabla que ya fue creada.
  
A. Agregar una nueva columna (ADD)
Imagina que a tu tabla Cliente necesitas agregarle una columna para registrar la fecha de nacimiento del cliente.
ALTER TABLE Cliente 
ADD fechaNacimiento DATE;


B. Modificar el tipo de dato o tamaño de una columna (ALTER COLUMN / MODIFY)
Imagina que el campo correo en la tabla Cliente se te queda corto y necesitas ampliar los caracteres permitidos a VARCHAR(150)

ALTER TABLE Cliente 
ALTER COLUMN correo VARCHAR(150);


C. Eliminar una columna que ya no necesitas (DROP COLUMN)
Si decides que la columna fechaRegistro ya no es necesaria en la tabla Cliente:

ALTER TABLE Cliente 
DROP COLUMN fechaRegistro;


D. Agregar una restricción o Llave Foránea (ADD CONSTRAINT)
Imagina que creaste la tabla Pedido, pero olvidaste agregarle la relación (FOREIGN KEY) que la conecta con el idCliente de la tabla Cliente.
Puedes agregársela así:

ALTER TABLE Pedido 
ADD CONSTRAINT FK_Pedido_Cliente 
FOREIGN KEY (idCliente) REFERENCES Cliente(idCliente);

========================================================================================================================================
                                                              DROP TABLE
========================================================================================================================================

3. DROP TABLE (Eliminar una tabla por completo)
El comando DROP TABLE borra por completo la estructura de la tabla y todos los datos que contenga de forma permanente
Si por alguna razón quisieras eliminar por completo la tabla temporal o de prueba llamada DetallePedido:
  
DROP TABLE DetallePedido;

Si intentas hacer un DROP TABLE de una tabla que tiene una Llave Primaria enlazada a una Llave Foránea de otra tabla
(por ejemplo, intentar borrar Cliente mientras Pedido sigue dependiendo de ella),la base de datos te arrojará un error de restricción.


