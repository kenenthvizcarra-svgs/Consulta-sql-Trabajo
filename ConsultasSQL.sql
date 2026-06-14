1 Listar información básica de las oficinas
SELECT codigo_oficina, ciudad, pais, telefono 
FROM oficina;

2 Obtener los empleados por oficina
SELECT codigo_oficina, nombre, apellido1, apellido2, puesto 
FROM empleado 
ORDER BY codigo_oficina;

3 Calcular el promedio de salario (límite de crédito) de los clientes por región
SELECT region, AVG(limite_credito) AS promedio_credito 
FROM cliente 
WHERE region IS NOT NULL 
GROUP BY region;

4 Listar clientes con sus representantes de ventas
SELECT c.nombre_cliente, 
       CONCAT(e.nombre, ' ', e.apellido1) AS nombre_representante 
FROM cliente c
INNER JOIN empleado e ON c.codigo_empleado_rep_ventas = e.codigo_empleado;

5 Obtener productos disponibles y en stock
SELECT codigo_producto, nombre, cantidad_en_stock 
FROM producto 
WHERE cantidad_en_stock >= 1;

6 Productos con precios por debajo del promedio
SELECT codigo_producto, nombre, precio_venta 
FROM producto 
WHERE precio_venta < (SELECT AVG(precio_venta) FROM producto);

7 Pedidos pendientes por cliente
SELECT p.codigo_pedido, p.estado, c.nombre_cliente 
FROM pedido p
INNER JOIN cliente c ON p.codigo_cliente = c.codigo_cliente
WHERE p.estado <> 'Entregado';

8 Total de productos por categoría (gama)
SELECT gama, COUNT(*) AS total_productos 
FROM producto 
GROUP BY gama;

9 Ingresos totales generados por cliente
SELECT c.nombre_cliente, SUM(p.total) AS total_ingresos 
FROM cliente c
INNER JOIN pago p ON c.codigo_cliente = p.codigo_cliente
GROUP BY c.codigo_cliente, c.nombre_cliente;

10 Pedidos realizados en un rango de fechas (Ejemplo: Año 2020)
SELECT codigo_pedido, fecha_pedido 
FROM pedido 
WHERE fecha_pedido BETWEEN '2020-01-01' AND '2020-12-31';

11 Detalles de un pedido específico (Ejemplo con el código 1)
SELECT dp.codigo_pedido, p.nombre AS producto, dp.cantidad, 
       (dp.cantidad * dp.precio_unidad) AS precio_total_linea
FROM detalle_pedido dp
INNER JOIN producto p ON dp.codigo_producto = p.codigo_producto
WHERE dp.codigo_pedido = 1;

12 Productos más vendidos
SELECT dp.codigo_producto, p.nombre, SUM(dp.cantidad) AS total_vendido 
FROM detalle_pedido dp
INNER JOIN producto p ON dp.codigo_producto = p.codigo_producto
GROUP BY dp.codigo_producto, p.nombre
ORDER BY total_vendido DESC;

13 Pedidos con un valor total superior al promedio
SELECT codigo_pedido, SUM(cantidad * precio_unidad) AS total_pedido 
FROM detalle_pedido 
GROUP BY codigo_pedido
HAVING total_pedido > (
    SELECT AVG(sub.total_lineas) 
    FROM (SELECT SUM(cantidad * precio_unidad) AS total_lineas FROM detalle_pedido GROUP BY codigo_pedido) sub);

14 Clientes sin representante de ventas asignado
SELECT codigo_cliente, nombre_cliente 
FROM cliente 
WHERE codigo_empleado_rep_ventas IS NULL;

15 Número total de empleados por oficina
SELECT codigo_oficina, COUNT(*) AS total_empleados 
FROM empleado 
GROUP BY codigo_oficina;

16 Pagos realizados en una forma específica (Ejemplo: Tarjeta de Crédito)
SELECT * FROM pago 
WHERE forma_pago = 'Tarjeta de Crédito';

17 Ingresos mensuales
SELECT DATE_FORMAT(fecha_pago, '%Y-%m') AS mes, SUM(total) AS ingresos_totales 
FROM pago 
GROUP BY DATE_FORMAT(fecha_pago, '%Y-%m')
ORDER BY mes;

18 Clientes con múltiples pedidos
SELECT c.nombre_cliente, COUNT(p.codigo_pedido) AS cantidad_pedidos 
FROM cliente c
INNER JOIN pedido p ON c.codigo_cliente = p.codigo_cliente
GROUP BY c.codigo_cliente, c.nombre_cliente
HAVING COUNT(p.codigo_pedido) > 1;

19 Pedidos con productos agotados
SELECT DISTINCT dp.codigo_pedido 
FROM detalle_pedido dp
INNER JOIN producto p ON dp.codigo_producto = p.codigo_producto
WHERE p.cantidad_en_stock = 0;

20 Promedio, máximo y mínimo del límite de crédito de los clientes por país
SELECT pais, 
       AVG(limite_credito) AS promedio, 
       MAX(limite_credito) AS maximo, 
       MIN(limite_credito) AS minimo 
FROM cliente 
GROUP BY pais;

21 Historial de transacciones de un cliente (Ejemplo con código 1)
SELECT fecha_pago, total, forma_pago 
FROM pago 
WHERE codigo_cliente = 1
ORDER BY fecha_pago DESC;

22 Empleados sin jefe directo asignado
SELECT codigo_empleado, nombre, apellido1 
FROM empleado 
WHERE codigo_jefe IS NULL;

23 Productos cuyo precio supera el promedio de su categoría (gama)
SELECT p1.codigo_producto, p1.nombre, p1.gama, p1.precio_venta 
FROM producto p1
WHERE p1.precio_venta > (
    SELECT AVG(p2.precio_venta) 
    FROM producto p2 
    WHERE p2.gama = p1.gama
);

24 Promedio de días de entrega por estado
SELECT estado, AVG(DATEDIFF(fecha_entrega, fecha_pedido)) AS promedio_dias_entrega 
FROM pedido 
WHERE fecha_entrega IS NOT NULL 
GROUP BY estado;

25 Clientes por país con más de un pedido
SELECT c.pais, COUNT(DISTINCT c.codigo_cliente) AS cantidad_clientes 
FROM cliente c
INNER JOIN pedido p ON c.codigo_cliente = p.codigo_cliente
GROUP BY c.pais;