
-- 27. Escriba una consulta sql que retorne una estadística basada en la facturacion por año y
-- envase devolviendo las siguientes columnas:
--  Año
--  Codigo de envase
--  Detalle del envase
--  Cantidad de productos que tienen ese envase
--  Cantidad de productos facturados de ese envase
--  Producto mas vendido de ese envase
--  Monto total de venta de ese envase en ese año
--  Porcentaje de la venta de ese envase respecto al total vendido de ese año
-- Los datos deberan ser ordenados por año y dentro del año por el envase con más
-- facturación de mayor a menor


SELECT
    YEAR(f.fact_fecha) AS anio,

    e.enva_codigo,

    e.enva_detalle,

    (
        SELECT COUNT(*)
        FROM Producto p2
        WHERE p2.prod_envase = e.enva_codigo
    ) AS productos_del_envase,

    COUNT(DISTINCT p.prod_codigo) AS productos_facturados,

    (
        SELECT TOP 1 p2.prod_codigo
        FROM Factura f2

        INNER JOIN Item_Factura i2
            ON f2.fact_tipo = i2.item_tipo
            AND f2.fact_sucursal = i2.item_sucursal
            AND f2.fact_numero = i2.item_numero

        INNER JOIN Producto p2
            ON i2.item_producto = p2.prod_codigo

        WHERE YEAR(f2.fact_fecha) = YEAR(f.fact_fecha)
          AND p2.prod_envase = e.enva_codigo

        GROUP BY p2.prod_codigo

        ORDER BY
            SUM(i2.item_cantidad) DESC,
            p2.prod_codigo ASC

    ) AS producto_mas_vendido,

    SUM(i.item_cantidad * i.item_precio) AS monto_total,

    SUM(i.item_cantidad * i.item_precio) * 100.0 /
    (
        SELECT SUM(i3.item_cantidad * i3.item_precio)

        FROM Factura f3

        INNER JOIN Item_Factura i3
            ON f3.fact_tipo = i3.item_tipo
            AND f3.fact_sucursal = i3.item_sucursal
            AND f3.fact_numero = i3.item_numero

        WHERE YEAR(f3.fact_fecha) = YEAR(f.fact_fecha)
    ) AS porcentaje_venta

FROM Factura f

INNER JOIN Item_Factura i
    ON f.fact_tipo = i.item_tipo
    AND f.fact_sucursal = i.item_sucursal
    AND f.fact_numero = i.item_numero

INNER JOIN Producto p
    ON i.item_producto = p.prod_codigo

INNER JOIN Envases e
    ON p.prod_envase = e.enva_codigo

GROUP BY
    YEAR(f.fact_fecha),
    e.enva_codigo,
    e.enva_detalle

ORDER BY
    YEAR(f.fact_fecha),
    SUM(i.item_cantidad * i.item_precio) DESC;