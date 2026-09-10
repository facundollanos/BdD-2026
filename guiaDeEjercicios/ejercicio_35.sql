-- 35. Se requiere realizar una estadística de ventas por año y producto, para ello se solicita
-- que escriba una consulta sql que retorne las siguientes columnas:
--  Año
--  Codigo de producto
--  Detalle del producto
--  Cantidad de facturas emitidas a ese producto ese año
--  Cantidad de vendedores diferentes que compraron ese producto ese año.
--  Cantidad de productos a los cuales compone ese producto, si no compone a ninguno
-- se debera retornar 0.
--  Porcentaje de la venta de ese producto respecto a la venta total de ese año.
-- Los datos deberan ser ordenados por año y por producto con mayor cantidad vendida


SELECT
    YEAR(f.fact_fecha) AS anio,

    p.prod_codigo,

    p.prod_detalle,

    COUNT(DISTINCT
        f.fact_tipo + f.fact_sucursal + f.fact_numero
    ) AS cantidad_facturas,

    COUNT(DISTINCT f.fact_vendedor) AS vendedores_diferentes,

    (
        SELECT COUNT(DISTINCT c.comp_producto)
        FROM Composicion c
        WHERE c.comp_componente = p.prod_codigo
    ) AS productos_que_compone,

    SUM(i.item_cantidad * i.item_precio) * 100.0 /
    (
        SELECT SUM(i2.item_cantidad * i2.item_precio)

        FROM Factura f2

        INNER JOIN Item_Factura i2
            ON f2.fact_tipo = i2.item_tipo
            AND f2.fact_sucursal = i2.item_sucursal
            AND f2.fact_numero = i2.item_numero

        WHERE YEAR(f2.fact_fecha) = YEAR(f.fact_fecha)
    ) AS porcentaje_venta

FROM Producto p

INNER JOIN Item_Factura i
    ON p.prod_codigo = i.item_producto

INNER JOIN Factura f
    ON i.item_tipo = f.fact_tipo
    AND i.item_sucursal = f.fact_sucursal
    AND i.item_numero = f.fact_numero

GROUP BY
    YEAR(f.fact_fecha),
    p.prod_codigo,
    p.prod_detalle

ORDER BY
    YEAR(f.fact_fecha),
    SUM(i.item_cantidad) DESC;