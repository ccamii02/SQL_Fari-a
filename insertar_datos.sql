-- Inserción de datos en la tabla marca
INSERT IGNORE INTO marcas (nombre_marca) VALUES
	('AMD'),
	('Intel'),
	('NVIDIA'),
    ('Gigabyte'),
    ('ASUS'),
    ('Kingston'),
	('MSI'),
    ('Logitech'),
	('Sony'),
	('Samsung'),
	('NZXT'),
	('Microsoft'),
	('Nintendo');
    
-- Inserción de datos en la tabla categorias
INSERT IGNORE INTO categorias (nombre_categoria) VALUES
	('Procesadores'),
	('Placas de video'),
	('Memorias RAM'),
	('Motherboards'),
    ('Fuentes'),
    ('Gabinetes'),
	('Almacenamiento'),
    ('Perifericos'),
    ('Consolas');

-- Inserción de datos en la tabla productos
INSERT IGNORE INTO productos (nombre_producto, precio, id_marca, id_categoria) VALUES
	('Ryzen 5 5600X', 400000.00, (SELECT id_marca FROM marcas WHERE nombre_marca='AMD'), (SELECT id_categoria FROM categorias WHERE nombre_categoria='Procesadores')),
	('GeForce RTX 3060', 900000.00, (SELECT id_marca FROM marcas WHERE nombre_marca='NVIDIA'), (SELECT id_categoria FROM categorias WHERE nombre_categoria='Placas de video')),
	('Corsair Vengeance 16GB', 80000.00, (SELECT id_marca FROM marcas WHERE nombre_marca='Kingston'), (SELECT id_categoria FROM categorias WHERE nombre_categoria='Memorias RAM')),
	('ASUS TUF Gaming B550', 300000.00, (SELECT id_marca FROM marcas WHERE nombre_marca='ASUS'), (SELECT id_categoria FROM categorias WHERE nombre_categoria='Motherboards')),
	('Corsair RM750x', 250000.00, (SELECT id_marca FROM marcas WHERE nombre_marca='Corsair'), (SELECT id_categoria FROM categorias WHERE nombre_categoria='Fuentes')),
	('NZXT H510', 150000.00, (SELECT id_marca FROM marcas WHERE nombre_marca='NZXT'), (SELECT id_categoria FROM categorias WHERE nombre_categoria='Gabinetes')),
	('Samsung 970 EVO Plus 1TB SSD', 120000.00, (SELECT id_marca FROM marcas WHERE nombre_marca='Samsung'), (SELECT id_categoria FROM categorias WHERE nombre_categoria='Almacenamiento')),
	('Mouse Logitech MX Master 3', 85000.00, (SELECT id_marca FROM marcas WHERE nombre_marca='Logitech'), (SELECT id_categoria FROM categorias WHERE nombre_categoria='Perifericos')),
	('PlayStation 5', 20000000.00, (SELECT id_marca FROM marcas WHERE nombre_marca='Sony'), (SELECT id_categoria FROM categorias WHERE nombre_categoria='Consolas'));

-- Inserción de datos en la tabla consolas
INSERT IGNORE INTO consolas (nombre_consola, precio_consola, id_marca, id_categoria) VALUES
	('PlayStation 5', 20000000.00, (SELECT id_marca FROM marcas WHERE nombre_marca='Sony'),(SELECT id_categoria FROM categorias WHERE nombre_categoria = 'Consolas')),
	('Xbox Series X', 18000000.00, (SELECT id_marca FROM marcas WHERE nombre_marca='Microsoft'),(SELECT id_categoria FROM categorias WHERE nombre_categoria = 'Consolas')),
	('Nintendo Switch', 15000000.00, (SELECT id_marca FROM marcas WHERE nombre_marca='Nintendo'),(SELECT id_categoria FROM categorias WHERE nombre_categoria = 'Consolas'));

-- Inserción de datos en la tabla perifericos
INSERT IGNORE INTO perifericos (nombre_periferico, precio_periferico, id_marca, id_categoria) VALUES
	('Logitech MX Master 3', 85000.00, (SELECT id_marca FROM marcas WHERE nombre_marca='Logitech'), (SELECT id_categoria FROM categorias WHERE nombre_categoria = 'Perifericos')),
	('Corsair K70 Keyboard', 120000.00, (SELECT id_marca FROM marcas WHERE nombre_marca='Corsair'), (SELECT id_categoria FROM categorias WHERE nombre_categoria = 'Perifericos'));


-- Inserción de datos en la tabla clientes	  
INSERT IGNORE INTO clientes (nombre_cliente, dni, email, telefono) VALUES
	('Camila Fernandez', '440005566', 'camila@mail.com', '123456789'),
	('Juan Perez', '876543211', 'juan@mail.com', '987654321'),
	('María Lopez', '112233442', 'maria@mail.com', '456789123');

-- Inserción de datos en la tabla ventas
INSERT IGNORE INTO ventas (id_cliente) VALUES 
	((SELECT id_cliente FROM clientes WHERE nombre_cliente = 'Camila Fernández')),
    ((SELECT id_cliente FROM clientes WHERE nombre_cliente = 'Juan Perez')),
    ((SELECT id_cliente FROM clientes WHERE nombre_cliente = 'María Lopez'));

-- Inserción de datos en la tabla detalle_ventas_productos
INSERT IGNORE INTO detalle_ventas_productos (id_venta, id_producto, cantidad_producto, precio_unitario)
	SELECT
		v.id_venta,
		p.id_producto,
		2,
		p.precio
	FROM ventas v
	JOIN clientes c ON v.id_cliente = c.id_cliente
	JOIN productos p ON p.nombre_producto = 'GeForce RTX 3060'
	WHERE c.nombre_cliente = 'Camila Fernández'
	ORDER BY v.id_venta DESC
	LIMIT 1;

-- Inserción de datos en la tabla detalle_ventas_consolas
INSERT IGNORE INTO detalle_ventas_consolas (id_venta, id_consola, cantidad_consola, precio_unitario)
	SELECT
		v.id_venta,
		co.id_consola,
		1,
		co.precio_consola
	FROM ventas v
	JOIN clientes c ON v.id_cliente = c.id_cliente
	JOIN consolas co ON co.nombre_consola = 'Nintendo Switch' 
	WHERE c.nombre_cliente = 'Juan Perez'
	ORDER BY v.id_venta DESC
	LIMIT 1;

-- Inserción de datos en la tabla detalle_ventas_perifericos
INSERT IGNORE INTO detalle_ventas_perifericos (id_venta, id_periferico, cantidad_periferico, precio_unitario)
	SELECT
		v.id_venta,
		pe.id_periferico,
		1,
		pe.precio_periferico
	FROM ventas v
	JOIN clientes c ON v.id_cliente = c.id_cliente
	JOIN perifericos pe ON pe.nombre_periferico = 'Logitech MX Master 3' 
	WHERE c.nombre_cliente = 'María Lopez'
	ORDER BY v.id_venta DESC
	LIMIT 1;




--  Consulta Detalles de productos todos juntos
-- detalles producto
CREATE VIEW view_ventas_completas AS
SELECT
    c.nombre_cliente,
    v.fecha_venta,
    p.nombre_producto AS producto,
    dvp.cantidad_producto AS cantidad,
    dvp.precio_unitario,
    (dvp.cantidad_producto * dvp.precio_unitario) AS total
FROM detalle_ventas_productos dvp
JOIN ventas v ON dvp.id_venta = v.id_venta
JOIN clientes c ON v.id_cliente = c.id_cliente
JOIN productos p ON dvp.id_producto = p.id_producto

UNION ALL
-- Consulta Detalles de consolas compradas
SELECT
    c.nombre_cliente,
    v.fecha_venta,
    co.nombre_consola AS producto,
    dvc.cantidad_consola AS cantidad,
    dvc.precio_unitario,
    (dvc.cantidad_consola * dvc.precio_unitario) AS total
FROM detalle_ventas_consolas dvc
JOIN ventas v ON dvc.id_venta = v.id_venta
JOIN clientes c ON v.id_cliente = c.id_cliente
JOIN consolas co ON dvc.id_consola = co.id_consola

UNION ALL
-- Consulta Detalles de periféricos comprados
SELECT
    c.nombre_cliente,
    v.fecha_venta,
    pe.nombre_periferico AS producto,
    dvp2.cantidad_periferico AS cantidad,
    dvp2.precio_unitario,
    (dvp2.cantidad_periferico * dvp2.precio_unitario) AS total
FROM detalle_ventas_perifericos dvp2
JOIN ventas v ON dvp2.id_venta = v.id_venta
JOIN clientes c ON v.id_cliente = c.id_cliente
JOIN perifericos pe ON dvp2.id_periferico = pe.id_periferico

ORDER BY nombre_cliente, fecha_venta, producto;


--

SELECT * FROM view_ventas_completas;

-- consulta de todos los porductos y detalles
SELECT 
    p.nombre_producto AS producto,
    p.precio,
    c.nombre_categoria AS categoria,
    m.nombre_marca AS marca
FROM productos p
JOIN categorias c ON p.id_categoria = c.id_categoria
JOIN marcas m ON p.id_marca = m.id_marca
ORDER BY c.nombre_categoria, p.nombre_producto;

























