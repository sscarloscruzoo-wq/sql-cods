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
                                                        RESTRICCIONES DE INTEGRIDAD
=========================================================================================================================================================

1. Integridad de Entidad
Aseguran que cada fila de una tabla sea única e identificable,evitando duplicados en los registros principales y garantizando que las columnas
clave nunca estén vacías.

PRIMARY KEY (Clave Primaria): Identifica de forma única cada fila en una tabla. Es obligatoriamente NOT NULL y no se puede repetir.
En tu tabla Cliente, el campo idCliente es la PK. Si intentas registrar dos clientes con el idCliente = 1, la base de datos lo rechazará de inmediato.

idCliente INT PRIMARY KEY


UNIQUE (Clave Única): Garantiza que todos los valores de una columna sean diferentes entre sí, aunque no sea la clave primaria
El correo electrónico de un cliente debe ser único para que no existan dos cuentas registradas con el mismo correo
  
correo VARCHAR(100) UNIQUE


2. Integridad Referencial
Asegura que las relaciones entre las tablas se mantengan sincronizadas y no existan "puentes rotos" o datos huérfanos.
FOREIGN KEY (Clave Foránea): Conecta una tabla con otra asegurando que el valor que insertes en la tabla hija exista previamente en la tabla maestra.
En la tabla Pedido, la columna idCliente es una FK que apunta al idCliente de la tabla Cliente.
No puedes hacer un pedido a nombre de un idCliente = 999 si ese cliente jamás se registró

CONSTRAINT FK_Pedido_Cliente FOREIGN KEY (idCliente) 
    REFERENCES Cliente(idCliente)


3. Integridad de Dominio
Controlan el tipo, formato y rango de los valores que se pueden ingresar en una columna específica.
DEFAULT (Valor por defecto): Asigna un valor predeterminado a una columna si el usuario no especifica ninguno al momento de insertar el registro.
Si un cliente hace un pedido y no se especifica el estado, por defecto se le asigna "Pendiente"

estado VARCHAR(30) DEFAULT 'Pendiente'


CHECK (Validación de condición): Permite establecer una regla lógica que se debe cumplir obligatoriamente para aceptar el dato.
Asegurarnos de que el sueldo de un empleado o el stock de un producto nunca sean negativos.

sueldo DECIMAL(10, 2) CHECK (sueldo > 0)


CREATE TABLE Producto (
    idProducto INT PRIMARY KEY,                             -- Integridad de Entidad (PK)
    nombreProducto VARCHAR(100) NOT NULL,                    -- Integridad de Dominio (No nulo)
    categoria VARCHAR(50),
    precio DECIMAL(10, 2) CHECK (precio >= 0),              -- Integridad de Dominio (Check)
    stock INT DEFAULT 0                                     -- Integridad de Dominio (Default)
);



=========================================================================================================================================================
                                                                    NOT NULL
=========================================================================================================================================================
nombre y apellido llevan NOT NULL: Porque es indispensable que cada cliente registrado tenga nombre y apellido.
Si alguien intenta hacer un INSERT sin esos datos, SQL rechazará la operación de inmediato.

ciudad, correo y fechaRegistro NO tienen NOT NULL: Esto significa que son opcionales (NULL por defecto).
Por ejemplo, quizás al registrar un cliente rápido aún no tienes su correo o su ciudad, y el sistema le permite guardarlo temporalmente con un valor nulo.

Un dato clave: Por definición, cualquier columna que sea PRIMARY KEY (como idCliente) es automáticamente NOT NULL
y única, ya que no puedes identificar un registro único en la base de datos si su identificador está vacío.


  
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


========================================================================================================================================
                                                                  VARIABLE
========================================================================================================================================
Una variable es un espacio reservado en la memoria RAM de la computadora para almacenar un dato o valor específico.

Puedes imaginarla como una caja con una etiqueta (su nombre) en la que guardas algo adentro.
A lo largo de la ejecución de un programa, el contenido de esa "caja" puede cambiar (por eso se llaman variables), o puede mantenerse fijo.

Guardar información temporalmente: Como el puntaje de un juego, el resultado de una operación matemática o el nombre de un usuario que acaba de iniciar sesión.

Reutilizar datos: En lugar de escribir un número o un texto largo muchas veces en tu código, lo guardas en una variable y lo llamas usando su nombre las veces que necesites.

Facilitar cálculos y lógica: Permiten que los programas sean dinámicos y tomen decisiones basadas en los datos que el usuario ingresa.

  
Cuando escribes código, una variable se compone de un tipo de dato, un nombre y un valor. Aquí tienes ejemplos cotidianos basados en lo que estás estudiando:



Variable numérica entera (int): Sirve para almacenar números sin decimales (como edades, IDs o cantidades).


int edad = 22;
int stockProducto = 60; // Como el stock de tus productos CSV

Variable de texto (String): Sirve para almacenar palabras, nombres o frases completas.
String nombreCliente = "Jhan";
String ciudad = "Chiclayo";


Variable con decimales (double o float): Sirve para precios, sueldos o medidas exactas.
double sueldoEmpleado = 2027.50; // Como los sueldos de tu tabla Empleado

Variable booleana (boolean): Solo puede almacenar dos valores: verdadero (true) o falso (false).
boolean estaActivo = true;
















