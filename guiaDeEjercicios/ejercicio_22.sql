
-- 22. Escriba una consulta sql que retorne una estadistica de venta para todos los rubros por
-- trimestre contabilizando todos los años. Se mostraran como maximo 4 filas por rubro (1
-- por cada trimestre).
-- Se deben mostrar 4 columnas:
--  Detalle del rubro
--  Numero de trimestre del año (1 a 4)
--  Cantidad de facturas emitidas en el trimestre en las que se haya vendido al
-- menos un producto del rubro
--  Cantidad de productos diferentes del rubro vendidos en el trimestre
-- El resultado debe ser ordenado alfabeticamente por el detalle del rubro y dentro de cada
-- rubro primero el trimestre en el que mas facturas se emitieron.
-- No se deberan mostrar aquellos rubros y trimestres para los cuales las facturas emitiadas
-- no superen las 100.
-- En ningun momento se tendran en cuenta los productos compuestos para esta
-- estadistica.

SELECT
    r.rubr_detalle,
    DATEPART(QUARTER, f.fact_fecha) AS trimestre,

    COUNT(DISTINCT
        f.fact_tipo + f.fact_sucursal + f.fact_numero
    ) AS cantidad_facturas,

    COUNT(DISTINCT p.prod_codigo) AS productos_diferentes

FROM Rubro r

INNER JOIN Producto p
    ON r.rubr_id = p.prod_rubro

INNER JOIN Item_Factura i
    ON p.prod_codigo = i.item_producto

INNER JOIN Factura f
    ON i.item_tipo = f.fact_tipo
    AND i.item_sucursal = f.fact_sucursal
    AND i.item_numero = f.fact_numero

WHERE p.prod_codigo NOT IN (
    SELECT comp_producto
    FROM Composicion
)

GROUP BY
    r.rubr_id,
    r.rubr_detalle,
    DATEPART(QUARTER, f.fact_fecha)

HAVING COUNT(DISTINCT
    f.fact_tipo + f.fact_sucursal + f.fact_numero
) > 100

ORDER BY
    r.rubr_detalle ASC,
    COUNT(DISTINCT
        f.fact_tipo + f.fact_sucursal + f.fact_numero
    ) DESC;