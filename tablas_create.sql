-- Crear base de datos
CREATE DATABASE IF NOT EXISTS tiendaComponentes;
USE tiendacomponentes;

-- Tabla Marcas

CREATE TABLE IF NOT EXISTS marcas(
	id_marca INT AUTO_INCREMENT PRIMARY KEY,
    nombre_marca VARCHAR(50) NOT NULL UNIQUE
);

-- Tabla Categorias

CREATE TABLE IF NOT EXISTS categorias(
	id_categoria INT AUTO_INCREMENT PRIMARY KEY,
    nombre_categoria VARCHAR(100) NOT NULL UNIQUE
);

-- Tabla Productos
CREATE TABLE IF NOT EXISTS productos (
	id_producto INT AUTO_INCREMENT PRIMARY KEY,
    nombre_producto VARCHAR(100) NOT NULL,
    precio DECIMAL(10,2) NOT NULL,
    id_marca INT,
    id_categoria INT,
    FOREIGN KEY (id_marca) REFERENCES marcas(id_marca),
    FOREIGN KEY (id_categoria) REFERENCES categorias(id_categoria)
);

-- Tabla Clientes

CREATE TABLE IF NOT EXISTS clientes(
	id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nombre_cliente VARCHAR(100) NOT NULL,
    dni VARCHAR(9) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE,
    telefono VARCHAR(100) UNIQUE
);

-- Tabla Ventas

CREATE TABLE IF NOT EXISTS ventas(
	id_venta INT AUTO_INCREMENT PRIMARY KEY,
    fecha_venta DATETIME DEFAULT CURRENT_TIMESTAMP,
    id_cliente INT,
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)
);

-- Tabla Consolas

CREATE TABLE IF NOT EXISTS consolas( 
	id_consola INT AUTO_INCREMENT PRIMARY KEY,
    nombre_consola VARCHAR(100) NOT NULL,
    precio_consola DECIMAL(10,2) NOT NULL,
    id_marca INT,
    FOREIGN KEY (id_marca) REFERENCES marcas(id_marca)
);

-- Tabla Perifericos

CREATE TABLE IF NOT EXISTS perifericos(
	id_periferico INT AUTO_INCREMENT PRIMARY KEY,
    nombre_periferico VARCHAR(100) NOT NULL,
    precio_periferico DECIMAL(10,2) NOT NULL,
    id_marca INT,
    FOREIGN KEY (id_marca) REFERENCES marcas(id_marca)
);

-- Tabla Detalle Ventas

CREATE TABLE IF NOT EXISTS detalle_ventas_productos(
	id_detalle_producto INT AUTO_INCREMENT PRIMARY KEY,
    id_venta INT,
    id_producto INT,
    cantidad_producto INT NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_venta) REFERENCES ventas(id_venta),
    FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
);

-- Tabla Detalle Ventas - Consolas

CREATE TABLE IF NOT EXISTS detalle_ventas_consolas(
    id_detalle_consola INT AUTO_INCREMENT PRIMARY KEY,
    id_venta INT,
    id_consola INT,
    cantidad_consola INT NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_venta) REFERENCES ventas(id_venta),
    FOREIGN KEY (id_consola) REFERENCES consolas(id_consola)
);

-- Tabla Detalle de ventas - Periféricos

CREATE TABLE IF NOT EXISTS detalle_ventas_perifericos(
    id_detalle_periferico INT AUTO_INCREMENT PRIMARY KEY,
    id_venta INT,
    id_periferico INT,
    cantidad_periferico INT NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_venta) REFERENCES ventas(id_venta),
    FOREIGN KEY (id_periferico) REFERENCES perifericos(id_periferico)
);


ALTER TABLE consolas ADD COLUMN id_categoria INT;
ALTER TABLE consolas ADD FOREIGN KEY (id_categoria) REFERENCES categorias(id_categoria);

ALTER TABLE perifericos ADD COLUMN id_categoria INT;
ALTER TABLE perifericos ADD FOREIGN KEY (id_categoria) REFERENCES categorias(id_categoria);























