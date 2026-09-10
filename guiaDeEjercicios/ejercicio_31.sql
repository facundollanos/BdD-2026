/*
31. Escriba una consulta sql que retorne una estadística por Año y Vendedor que retorne las
siguientes columnas:
 Año.
 Codigo de Vendedor
 Detalle del Vendedor
 Cantidad de facturas que realizó en ese año
 Cantidad de clientes a los cuales les vendió en ese año.
 Cantidad de productos facturados con composición en ese año
 Cantidad de productos facturados sin composicion en ese año.
 Monto total vendido por ese vendedor en ese año
Los datos deberan ser ordenados por año y dentro del año por el vendedor que haya
vendido mas productos diferentes de mayor a menor.
*/

SELECT
    YEAR(f.fact_fecha) AS anio,

    e.empl_codigo AS codigo_vendedor,

    e.empl_nombre + ' ' + e.empl_apellido AS vendedor,

    COUNT(DISTINCT
        f.fact_tipo + f.fact_sucursal + f.fact_numero
    ) AS cantidad_facturas,

    COUNT(DISTINCT f.fact_cliente) AS cantidad_clientes,

    COUNT(DISTINCT
        CASE
            WHEN c.comp_producto IS NOT NULL
            THEN p.prod_codigo
        END
    ) AS productos_con_composicion,

    COUNT(DISTINCT
        CASE
            WHEN c.comp_producto IS NULL
            THEN p.prod_codigo
        END
    ) AS productos_sin_composicion,

    SUM(i.item_cantidad * i.item_precio) AS monto_total

FROM Factura f

INNER JOIN Empleado e
    ON f.fact_vendedor = e.empl_codigo

INNER JOIN Item_Factura i
    ON f.fact_tipo = i.item_tipo
    AND f.fact_sucursal = i.item_sucursal
    AND f.fact_numero = i.item_numero

INNER JOIN Producto p
    ON i.item_producto = p.prod_codigo

LEFT JOIN (
    SELECT DISTINCT comp_producto
    FROM Composicion
) c
    ON p.prod_codigo = c.comp_producto

GROUP BY
    YEAR(f.fact_fecha),
    e.empl_codigo,
    e.empl_nombre,
    e.empl_apellido

ORDER BY
    YEAR(f.fact_fecha),
    COUNT(DISTINCT p.prod_codigo) DESC;