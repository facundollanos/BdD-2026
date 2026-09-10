-- 23. Realizar una consulta SQL que para cada año muestre :
--  Año
--  El producto con composición más vendido para ese año.
--  Cantidad de productos que componen directamente al producto más vendido
--  La cantidad de facturas en las cuales aparece ese producto.
--  El código de cliente que más compro ese producto.
--  El porcentaje que representa la venta de ese producto respecto al total de venta
-- del año.
-- El resultado deberá ser ordenado por el total vendido por año en forma descendente


SELECT
    a.anio,

    (
        SELECT TOP 1 i.item_producto
        FROM Factura f
        INNER JOIN Item_Factura i
            ON f.fact_tipo = i.item_tipo
            AND f.fact_sucursal = i.item_sucursal
            AND f.fact_numero = i.item_numero
        WHERE YEAR(f.fact_fecha) = a.anio
          AND i.item_producto IN (
              SELECT comp_producto
              FROM Composicion
          )
        GROUP BY i.item_producto
        ORDER BY SUM(i.item_cantidad) DESC,
                 i.item_producto ASC
    ) AS producto_mas_vendido,

    (
        SELECT COUNT(*)
        FROM Composicion c
        WHERE c.comp_producto = (
            SELECT TOP 1 i.item_producto
            FROM Factura f
            INNER JOIN Item_Factura i
                ON f.fact_tipo = i.item_tipo
                AND f.fact_sucursal = i.item_sucursal
                AND f.fact_numero = i.item_numero
            WHERE YEAR(f.fact_fecha) = a.anio
              AND i.item_producto IN (
                  SELECT comp_producto
                  FROM Composicion
              )
            GROUP BY i.item_producto
            ORDER BY SUM(i.item_cantidad) DESC,
                     i.item_producto ASC
        )
    ) AS cantidad_componentes,

    (
        SELECT COUNT(DISTINCT
            i.item_tipo + i.item_sucursal + i.item_numero
        )
        FROM Factura f
        INNER JOIN Item_Factura i
            ON f.fact_tipo = i.item_tipo
            AND f.fact_sucursal = i.item_sucursal
            AND f.fact_numero = i.item_numero
        WHERE YEAR(f.fact_fecha) = a.anio
          AND i.item_producto = (
            SELECT TOP 1 i2.item_producto
            FROM Factura f2
            INNER JOIN Item_Factura i2
                ON f2.fact_tipo = i2.item_tipo
                AND f2.fact_sucursal = i2.item_sucursal
                AND f2.fact_numero = i2.item_numero
            WHERE YEAR(f2.fact_fecha) = a.anio
              AND i2.item_producto IN (
                  SELECT comp_producto
                  FROM Composicion
              )
            GROUP BY i2.item_producto
            ORDER BY SUM(i2.item_cantidad) DESC,
                     i2.item_producto ASC
        )
    ) AS cantidad_facturas,

    (
        SELECT TOP 1 f.fact_cliente
        FROM Factura f
        INNER JOIN Item_Factura i
            ON f.fact_tipo = i.item_tipo
            AND f.fact_sucursal = i.item_sucursal
            AND f.fact_numero = i.item_numero
        WHERE YEAR(f.fact_fecha) = a.anio
          AND i.item_producto = (
            SELECT TOP 1 i2.item_producto
            FROM Factura f2
            INNER JOIN Item_Factura i2
                ON f2.fact_tipo = i2.item_tipo
                AND f2.fact_sucursal = i2.item_sucursal
                AND f2.fact_numero = i2.item_numero
            WHERE YEAR(f2.fact_fecha) = a.anio
              AND i2.item_producto IN (
                  SELECT comp_producto
                  FROM Composicion
              )
            GROUP BY i2.item_producto
            ORDER BY SUM(i2.item_cantidad) DESC,
                     i2.item_producto ASC
        )
        GROUP BY f.fact_cliente
        ORDER BY SUM(i.item_cantidad) DESC,
                 f.fact_cliente ASC
    ) AS mejor_cliente,

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
        WHERE YEAR(f.fact_fecha) = a.anio
          AND i.item_producto = (
            SELECT TOP 1 i3.item_producto
            FROM Factura f3
            INNER JOIN Item_Factura i3
                ON f3.fact_tipo = i3.item_tipo
                AND f3.fact_sucursal = i3.item_sucursal
                AND f3.fact_numero = i3.item_numero
            WHERE YEAR(f3.fact_fecha) = a.anio
              AND i3.item_producto IN (
                  SELECT comp_producto
                  FROM Composicion
              )
            GROUP BY i3.item_producto
            ORDER BY SUM(i3.item_cantidad) DESC,
                     i3.item_producto ASC
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
    WHERE YEAR(f.fact_fecha) = a.anio
) DESC;