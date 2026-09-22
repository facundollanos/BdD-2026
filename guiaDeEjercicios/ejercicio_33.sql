
-- 33. Se requiere obtener una estadística de venta de productos que sean componentes. Para
-- ello se solicita que realiza la siguiente consulta que retorne la venta de los
-- componentes del producto más vendido del año 2012. Se deberá mostrar:
-- a. Código de producto
-- b. Nombre del producto
-- c. Cantidad de unidades vendidas
-- d. Cantidad de facturas en la cual se facturo
-- e. Precio promedio facturado de ese producto.
-- f. Total facturado para ese producto
-- El resultado deberá ser ordenado por el total vendido por producto para el año 2012.


--solucion profesor

SELECT P.prod_codigo, P.prod_detalle, SUM(i.item_cantidad) AS CantidadUnidades,
COUNT(*) AS cantidadFacturas,
SUM(i.item_cantidad * i.item_precio) / SUM(i.item_cantidad) AS PrecioPromedio,
SUM(i.item_cantidad * i.item_precio) AS totalFacturado
FROM 
Composicion c
INNER JOIN producto p ON c.comp_componente = p.prod_codigo
INNER JOIN Item_Factura i ON p.prod_codigo = i.item_producto 
WHERE c.comp_producto IN (
SELECT TOP 1 i.item_producto
FROM Composicion c
INNER JOIN Item_Factura i ON c.comp_producto = i.item_producto
INNER JOIN Factura f ON i.item_tipo = f.fact_tipo AND i.item_sucursal = f.fact_sucursal AND i.item_numero = f.fact_numero
WHERE YEAR(f.fact_fecha) = 2012
GROUP BY i.item_producto 
ORDER BY SUM(i.item_cantidad) DESC)
GROUP BY P.prod_codigo, P.prod_detalle 
ORDER BY (SELECT SUM(i2.item_cantidad * i2.item_precio)
from Factura f2 
INNER JOIN item_factura i2 
ON i2.item_tipo = f2.fact_tipo AND i2.item_sucursal = f2.fact_sucursal AND i2.item_numero = f2.fact_numero 
WHERE YEAR(f2.fact_fecha) = 2012
AND i2.item_producto = P.prod_codigo) DESC

SELECT
    p.prod_codigo,

    p.prod_detalle,

    SUM(i.item_cantidad) AS unidades_vendidas,

    COUNT(DISTINCT
        f.fact_tipo + f.fact_sucursal + f.fact_numero
    ) AS cantidad_facturas,

    AVG(i.item_precio) AS precio_promedio,

    SUM(i.item_cantidad * i.item_precio) AS total_facturado

FROM Producto p

INNER JOIN Item_Factura i
    ON p.prod_codigo = i.item_producto

INNER JOIN Factura f
    ON i.item_tipo = f.fact_tipo
    AND i.item_sucursal = f.fact_sucursal
    AND i.item_numero = f.fact_numero

WHERE YEAR(f.fact_fecha) = 2012

AND p.prod_codigo IN (

    SELECT c.comp_componente

    FROM Composicion c

    WHERE c.comp_producto = (

        SELECT TOP 1
            i2.item_producto

        FROM Item_Factura i2

        INNER JOIN Factura f2
            ON i2.item_tipo = f2.fact_tipo
            AND i2.item_sucursal = f2.fact_sucursal
            AND i2.item_numero = f2.fact_numero

        WHERE YEAR(f2.fact_fecha) = 2012

        GROUP BY i2.item_producto

        ORDER BY
            SUM(i2.item_cantidad) DESC,
            i2.item_producto ASC
    )
)

GROUP BY
    p.prod_codigo,
    p.prod_detalle

ORDER BY
    SUM(i.item_cantidad * i.item_precio) DESC;
