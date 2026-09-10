
-- 25. Realizar una consulta SQL que para cada año y familia muestre :
-- a. Año
-- b. El código de la familia más vendida en ese año.
-- c. Cantidad de Rubros que componen esa familia.
-- d. Cantidad de productos que componen directamente al producto más vendido de
-- esa familia.
-- e. La cantidad de facturas en las cuales aparecen productos pertenecientes a esa
-- familia.
-- f. El código de cliente que más compro productos de esa familia.
-- g. El porcentaje que representa la venta de esa familia respecto al total de venta
-- del año.
-- El resultado deberá ser ordenado por el total vendido por año y familia en forma
-- descendente.

SELECT
    a.anio,

    (
        SELECT TOP 1 p.prod_familia
        FROM Factura f
        INNER JOIN Item_Factura i
            ON f.fact_tipo = i.item_tipo
            AND f.fact_sucursal = i.item_sucursal
            AND f.fact_numero = i.item_numero
        INNER JOIN Producto p
            ON i.item_producto = p.prod_codigo
        WHERE YEAR(f.fact_fecha) = a.anio
        GROUP BY p.prod_familia
        ORDER BY SUM(i.item_cantidad * i.item_precio) DESC,
                 p.prod_familia ASC
    ) AS familia_mas_vendida,

    (
        SELECT COUNT(DISTINCT p.prod_rubro)
        FROM Producto p
        WHERE p.prod_familia = (
            SELECT TOP 1 p2.prod_familia
            FROM Factura f2
            INNER JOIN Item_Factura i2
                ON f2.fact_tipo = i2.item_tipo
                AND f2.fact_sucursal = i2.item_sucursal
                AND f2.fact_numero = i2.item_numero
            INNER JOIN Producto p2
                ON i2.item_producto = p2.prod_codigo
            WHERE YEAR(f2.fact_fecha) = a.anio
            GROUP BY p2.prod_familia
            ORDER BY SUM(i2.item_cantidad * i2.item_precio) DESC,
                     p2.prod_familia ASC
        )
    ) AS cantidad_rubros,

    (
        SELECT COUNT(*)
        FROM Composicion c
        WHERE c.comp_producto = (
            SELECT TOP 1 p3.prod_codigo
            FROM Factura f3
            INNER JOIN Item_Factura i3
                ON f3.fact_tipo = i3.item_tipo
                AND f3.fact_sucursal = i3.item_sucursal
                AND f3.fact_numero = i3.item_numero
            INNER JOIN Producto p3
                ON i3.item_producto = p3.prod_codigo
            WHERE YEAR(f3.fact_fecha) = a.anio
              AND p3.prod_familia = (
                    SELECT TOP 1 p4.prod_familia
                    FROM Factura f4
                    INNER JOIN Item_Factura i4
                        ON f4.fact_tipo = i4.item_tipo
                        AND f4.fact_sucursal = i4.item_sucursal
                        AND f4.fact_numero = i4.item_numero
                    INNER JOIN Producto p4
                        ON i4.item_producto = p4.prod_codigo
                    WHERE YEAR(f4.fact_fecha) = a.anio
                    GROUP BY p4.prod_familia
                    ORDER BY SUM(i4.item_cantidad * i4.item_precio) DESC,
                             p4.prod_familia ASC
              )
            GROUP BY p3.prod_codigo
            ORDER BY SUM(i3.item_cantidad) DESC,
                     p3.prod_codigo ASC
        )
    ) AS componentes_producto_mas_vendido,

    (
        SELECT COUNT(DISTINCT
            f.fact_tipo + f.fact_sucursal + f.fact_numero
        )
        FROM Factura f
        INNER JOIN Item_Factura i
            ON f.fact_tipo = i.item_tipo
            AND f.fact_sucursal = i.item_sucursal
            AND f.fact_numero = i.item_numero
        INNER JOIN Producto p
            ON i.item_producto = p.prod_codigo
        WHERE YEAR(f.fact_fecha) = a.anio
          AND p.prod_familia = (
              SELECT TOP 1 p2.prod_familia
              FROM Factura f2
              INNER JOIN Item_Factura i2
                  ON f2.fact_tipo = i2.item_tipo
                  AND f2.fact_sucursal = i2.item_sucursal
                  AND f2.fact_numero = i2.item_numero
              INNER JOIN Producto p2
                  ON i2.item_producto = p2.prod_codigo
              WHERE YEAR(f2.fact_fecha) = a.anio
              GROUP BY p2.prod_familia
              ORDER BY SUM(i2.item_cantidad * i2.item_precio) DESC,
                       p2.prod_familia ASC
          )
    ) AS cantidad_facturas,

    (
        SELECT TOP 1 f.fact_cliente
        FROM Factura f
        INNER JOIN Item_Factura i
            ON f.fact_tipo = i.item_tipo
            AND f.fact_sucursal = i.item_sucursal
            AND f.fact_numero = i.item_numero
        INNER JOIN Producto p
            ON i.item_producto = p.prod_codigo
        WHERE YEAR(f.fact_fecha) = a.anio
          AND p.prod_familia = (
              SELECT TOP 1 p2.prod_familia
              FROM Factura f2
              INNER JOIN Item_Factura i2
                  ON f2.fact_tipo = i2.item_tipo
                  AND f2.fact_sucursal = i2.item_sucursal
                  AND f2.fact_numero = i2.item_numero
              INNER JOIN Producto p2
                  ON i2.item_producto = p2.prod_codigo
              WHERE YEAR(f2.fact_fecha) = a.anio
              GROUP BY p2.prod_familia
              ORDER BY SUM(i2.item_cantidad * i2.item_precio) DESC,
                       p2.prod_familia ASC
          )
        GROUP BY f.fact_cliente
        ORDER BY SUM(i.item_cantidad) DESC,
                 f.fact_cliente ASC
    ) AS cliente_que_mas_compro,

    (
        SELECT
            SUM(i.item_cantidad * i.item_precio) * 100.0 /
            (
                SELECT SUM(i2.item_cantidad * i2.item_precio)
                FROM Factura f2
                INNER JOIN Item_Factura i2
                    ON f2.fact_tipo = i2.item_tipo
                    AND f2.fact_sucursal = i2.item_sucursal
                    AND f2.fact_numero = i2.item_numero
                WHERE YEAR(f2.fact_fecha) = a.anio
            )
        FROM Factura f
        INNER JOIN Item_Factura i
            ON f.fact_tipo = i.item_tipo
            AND f.fact_sucursal = i.item_sucursal
            AND f.fact_numero = i.item_numero
        INNER JOIN Producto p
            ON i.item_producto = p.prod_codigo
        WHERE YEAR(f.fact_fecha) = a.anio
          AND p.prod_familia = (
              SELECT TOP 1 p2.prod_familia
              FROM Factura f2
              INNER JOIN Item_Factura i2
                  ON f2.fact_tipo = i2.item_tipo
                  AND f2.fact_sucursal = i2.item_sucursal
                  AND f2.fact_numero = i2.item_numero
              INNER JOIN Producto p2
                  ON i2.item_producto = p2.prod_codigo
              WHERE YEAR(f2.fact_fecha) = a.anio
              GROUP BY p2.prod_familia
              ORDER BY SUM(i2.item_cantidad * i2.item_precio) DESC,
                       p2.prod_familia ASC
          )
    ) AS porcentaje_venta

FROM (
    SELECT DISTINCT YEAR(fact_fecha) AS anio
    FROM Factura
) a

ORDER BY (
    SELECT SUM(i.item_cantidad * i.item_precio)
    FROM Factura f
    INNER JOIN Item_Factura i
        ON f.fact_tipo = i.item_tipo
        AND f.fact_sucursal = i.item_sucursal
        AND f.fact_numero = i.item_numero
    INNER JOIN Producto p
        ON i.item_producto = p.prod_codigo
    WHERE YEAR(f.fact_fecha) = a.anio
      AND p.prod_familia = (
          SELECT TOP 1 p2.prod_familia
          FROM Factura f2
          INNER JOIN Item_Factura i2
              ON f2.fact_tipo = i2.item_tipo
              AND f2.fact_sucursal = i2.item_sucursal
              AND f2.fact_numero = i2.item_numero
          INNER JOIN Producto p2
              ON i2.item_producto = p2.prod_codigo
          WHERE YEAR(f2.fact_fecha) = a.anio
          GROUP BY p2.prod_familia
          ORDER BY SUM(i2.item_cantidad * i2.item_precio) DESC
      )
) DESC;