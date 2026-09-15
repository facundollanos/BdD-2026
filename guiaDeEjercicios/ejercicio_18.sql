/*



18. Escriba una consulta que retorne una estadística de ventas para todos los rubros.
La consulta debe retornar:
DETALLE_RUBRO: Detalle del rubro
VENTAS: Suma de las ventas en pesos de productos vendidos de dicho rubro
PROD1: Código del producto más vendido de dicho rubro
PROD2: Código del segundo producto más vendido de dicho rubro
CLIENTE: Código del cliente que compro más productos del rubro en los últimos 30
días
La consulta no puede mostrar NULL en ninguna de sus columnas y debe estar ordenada
por cantidad de productos diferentes vendidos del rubro.
*/


SELECT r.rubr_detalle, 
(SELECT SUM(i2.item_cantidad * i2.item_precio)
FROM Item_Factura i2
INNER JOIN Producto p2 ON i2.item_producto = p2.prod_codigo
WHERE p2.prod_rubro = r.rubr_id) AS Ventas, 
i.item_producto AS MasVendido,
ISNULL((SELECT TOP 1 p2.prod_codigo
FROM Item_Factura i2
INNER JOIN Producto p2 ON i2.item_producto = p2.prod_codigo
WHERE p2.prod_rubro = r.rubr_id AND p2.prod_codigo != i.item_producto
GROUP BY p2.prod_codigo 
ORDER BY SUM(i2.item_cantidad) DESC) , '00000000') AS SegundoMasVendido,
ISNULL((SELECT TOP 1 F.fact_cliente FROM Factura F 
INNER JOIN Item_Factura I ON F.fact_numero = I.item_numero AND F.fact_sucursal = I.item_sucursal AND F.fact_tipo = I.item_tipo 
INNER JOIN Producto P ON i.item_producto = p.prod_codigo 
WHERE DATEDIFF(DAY,F.fact_fecha,getdate()) < 31 AND 
P.prod_rubro = R.rubr_id
GROUP BY F.fact_cliente 
ORDER BY SUM(I.item_cantidad) DESC
),0) AS Cliente
FROM Item_Factura i
INNER JOIN Producto p ON i.item_producto = p.prod_codigo 
INNER JOIN Rubro r ON p.prod_rubro = r.rubr_id
GROUP BY r.rubr_id, r.rubr_detalle, i.item_producto  
HAVING I.item_producto = (
SELECT TOP 1 p2.prod_codigo
FROM Item_Factura i2
INNER JOIN Producto p2 ON i2.item_producto = p2.prod_codigo
WHERE p2.prod_rubro = r.rubr_id
GROUP BY p2.prod_codigo 
ORDER BY SUM(i2.item_cantidad) DESC)
