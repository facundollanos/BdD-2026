-- 24. Escriba una consulta que considerando solamente las facturas correspondientes a los
-- dos vendedores con mayores comisiones, retorne los productos con composición
-- facturados al menos en cinco facturas,
-- La consulta debe retornar las siguientes columnas:
--  Código de Producto
--  Nombre del Producto
--  Unidades facturadas
-- El resultado deberá ser ordenado por las unidades facturadas descendente



SELECT
    p.prod_codigo,
    p.prod_detalle,
    SUM(i.item_cantidad) AS unidades_facturadas

FROM Producto p

INNER JOIN Item_Factura i
    ON p.prod_codigo = i.item_producto

INNER JOIN Factura f
    ON i.item_tipo = f.fact_tipo
    AND i.item_sucursal = f.fact_sucursal
    AND i.item_numero = f.fact_numero

WHERE f.fact_vendedor IN (
    SELECT TOP 2 empl_codigo
    FROM Empleado
    ORDER BY empl_comision DESC
)

AND p.prod_codigo IN (
    SELECT comp_producto
    FROM Composicion
)

GROUP BY
    p.prod_codigo,
    p.prod_detalle

HAVING COUNT(DISTINCT
    i.item_tipo + i.item_sucursal + i.item_numero
) >= 5

ORDER BY SUM(i.item_cantidad) DESC;