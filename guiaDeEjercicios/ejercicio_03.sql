-- 3. Código, nombre y stock total del producto
-- sin importar el depósito

SELECT
    p.prod_codigo,
    p.prod_detalle,
    SUM(s.stoc_cantidad) AS stock_total
FROM Producto p
INNER JOIN STOCK s
    ON p.prod_codigo = s.stoc_producto
GROUP BY
    p.prod_codigo,
    p.prod_detalle
ORDER BY
    p.prod_detalle ASC;