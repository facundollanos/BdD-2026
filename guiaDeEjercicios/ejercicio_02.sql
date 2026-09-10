
/*
2. Mostrar el código, detalle de todos los artículos vendidos en el año 2012 ordenados por cantidad vendida.
*/

SELECT
    p.prod_codigo,
    p.prod_detalle,
    SUM(i.item_cantidad) AS cantidad_vendida
FROM Producto p
INNER JOIN Item_Factura i
    ON p.prod_codigo = i.item_producto
INNER JOIN Factura f
    ON i.item_tipo = f.fact_tipo
    AND i.item_sucursal = f.fact_sucursal
    AND i.item_numero = f.fact_numero
WHERE YEAR(f.fact_fecha) = 2012
GROUP BY
    p.prod_codigo,
    p.prod_detalle
ORDER BY cantidad_vendida;