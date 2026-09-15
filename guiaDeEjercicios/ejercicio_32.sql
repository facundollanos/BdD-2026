-- 32. Se desea conocer las familias que sus productos se facturaron juntos en las mismas
-- facturas para ello se solicita que escriba una consulta sql que retorne los pares de
-- familias que tienen productos que se facturaron juntos. Para ellos deberá devolver las
-- siguientes columnas:
--  Código de familia
--  Detalle de familia
--  Código de familia
--  Detalle de familia
--  Cantidad de facturas
--  Total vendido
-- Los datos deberan ser ordenados por Total vendido y solo se deben mostrar las familias
-- que se vendieron juntas más de 10 veces.


---professor version
SELECT fa.fami_id, fa.fami_detalle, fa2.fami_id, fa2.fami_detalle, 
COUNT(*) AS cantidadFacturas,
SUM(it1.item_cantidad) + SUM(it2.item_cantidad) AS TotalVendido
FROM item_factura it1
INNER JOIN item_factura it2 ON it1.item_numero = it2.item_numero AND it1.item_sucursal = it2.item_sucursal AND it1.item_tipo = it2.item_tipo
AND it1.item_producto < it2.item_producto
INNER JOIN producto pr ON pr.prod_codigo = it1.item_producto
INNER JOIN familia fa ON pr.prod_familia = fa.fami_id 
INNER JOIN producto pr2 ON pr2.prod_codigo = it2.item_producto
INNER JOIN familia fa2 ON pr2.prod_familia = fa2.fami_id
WHERE pr.prod_familia != pr2.prod_familia 
GROUP BY fa.fami_id, fa.fami_detalle, fa2.fami_id, fa2.fami_detalle 
HAVING COUNT(*) > 10
--mine

SELECT
    f1.fami_id AS familia1_codigo,
    f1.fami_detalle AS familia1_detalle,

    f2.fami_id AS familia2_codigo,
    f2.fami_detalle AS familia2_detalle,

    COUNT(DISTINCT
        i1.item_tipo + i1.item_sucursal + i1.item_numero
    ) AS cantidad_facturas,

    SUM(
        i1.item_cantidad * i1.item_precio
        +
        i2.item_cantidad * i2.item_precio
    ) AS total_vendido

FROM Item_Factura i1

INNER JOIN Item_Factura i2
    ON i1.item_tipo = i2.item_tipo
    AND i1.item_sucursal = i2.item_sucursal
    AND i1.item_numero = i2.item_numero

INNER JOIN Producto p1
    ON i1.item_producto = p1.prod_codigo

INNER JOIN Producto p2
    ON i2.item_producto = p2.prod_codigo
    AND p1.prod_familia < p2.prod_familia

INNER JOIN Familia f1
    ON p1.prod_familia = f1.fami_id

INNER JOIN Familia f2
    ON p2.prod_familia = f2.fami_id

GROUP BY
    f1.fami_id,
    f1.fami_detalle,
    f2.fami_id,
    f2.fami_detalle

HAVING COUNT(DISTINCT
    i1.item_tipo + i1.item_sucursal + i1.item_numero
) > 10

ORDER BY total_vendido DESC;
