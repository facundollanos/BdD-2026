-- --Con el fin de lanzar una nueva campaña comercial para los clientes que menos compran
-- en la empresa, se pide una consulta SQL que retorne aquellos clientes cuyas ventas son
-- inferiores a 1/3 del promedio de ventas del producto que más se vendió en el 2012.
-- Además mostrar
-- 1. Nombre del Cliente
-- 2. Cantidad de unidades totales vendidas en el 2012 para ese cliente.
-- 3. Código de producto que mayor venta tuvo en el 2012 (en caso de existir más de 1,
-- mostrar solamente el de menor código) para ese cliente.
-- Aclaraciones:
-- La composición es de 2 niveles, es decir, un producto compuesto solo se compone de
-- productos no compuestos.
-- Los clientes deben ser ordenados por código de provincia ascendente.

SELECT AVG(x.cantidad)
FROM (
    SELECT
        f.fact_cliente,
        SUM(i.item_cantidad) AS cantidad
    FROM Factura f
    INNER JOIN Item_Factura i
        ON f.fact_tipo = i.item_tipo
        AND f.fact_sucursal = i.item_sucursal
        AND f.fact_numero = i.item_numero
    WHERE YEAR(f.fact_fecha) = 2012
      AND i.item_producto = (
            SELECT TOP 1
                i2.item_producto
            FROM Item_Factura i2
            INNER JOIN Factura f2
                ON i2.item_tipo = f2.fact_tipo
                AND i2.item_sucursal = f2.fact_sucursal
                AND i2.item_numero = f2.fact_numero
            WHERE YEAR(f2.fact_fecha) = 2012
            GROUP BY i2.item_producto
            ORDER BY SUM(i2.item_cantidad) DESC,
                     i2.item_producto ASC
      )
    GROUP BY f.fact_cliente
) x;