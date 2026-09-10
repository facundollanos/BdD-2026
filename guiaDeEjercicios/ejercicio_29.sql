
-- 29. Se solicita que realice una estadística de venta por producto para el año 2011, solo para
-- los productos que pertenezcan a las familias que tengan más de 20 productos asignados
-- a ellas, la cual deberá devolver las siguientes columnas:
-- a. Código de producto
-- b. Descripción del producto
-- c. Cantidad vendida
-- d. Cantidad de facturas en la que esta ese producto
-- e. Monto total facturado de ese producto
-- Solo se deberá mostrar un producto por fila en función a los considerandos establecidos
-- antes. El resultado deberá ser ordenado por el la cantidad vendida de mayor a menor.

SELECT
    p.prod_codigo,

    p.prod_detalle,

    SUM(i.item_cantidad) AS cantidad_vendida,

    COUNT(DISTINCT
        f.fact_tipo + f.fact_sucursal + f.fact_numero
    ) AS cantidad_facturas,

    SUM(i.item_cantidad * i.item_precio) AS monto_total

FROM Producto p

INNER JOIN Item_Factura i
    ON p.prod_codigo = i.item_producto

INNER JOIN Factura f
    ON i.item_tipo = f.fact_tipo
    AND i.item_sucursal = f.fact_sucursal
    AND i.item_numero = f.fact_numero

WHERE YEAR(f.fact_fecha) = 2011

AND p.prod_familia IN (
    SELECT p2.prod_familia
    FROM Producto p2

    GROUP BY p2.prod_familia

    HAVING COUNT(*) > 20
)

GROUP BY
    p.prod_codigo,
    p.prod_detalle

ORDER BY
    SUM(i.item_cantidad) DESC;