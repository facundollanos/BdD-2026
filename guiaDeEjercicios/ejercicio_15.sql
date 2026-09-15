/*
15. Escriba una consulta que retorne los pares de productos que hayan sido vendidos juntos
(en la misma factura) más de 500 veces. 

El resultado debe mostrar el código y descripción de cada uno de los productos y la cantidad de veces que fueron vendidos
juntos. 

El resultado debe estar ordenado por la cantidad de veces que se vendieron juntos dichos productos. 

Los distintos pares no deben retornarse más de una vez.

Ejemplo de lo que retornaría la consulta:

PROD1 DETALLE1 PROD2 DETALLE2 VECES
1731 MARLBORO KS 1 7 1 8 P H ILIPS MORRIS KS 5 0 7
1718 PHILIPS MORRIS KS 1 7 0 5 P H I L I P S MORRIS BOX 10 5 6 2
*/

SELECT it1.item_producto, it2.item_producto, pr.prod_detalle, pr2.prod_detalle, COUNT(*) AS cantidad 
FROM item_factura it1
INNER JOIN item_factura it2 ON it1.item_numero = it2.item_numero AND it1.item_sucursal = it2.item_sucursal AND it1.item_tipo = it2.item_tipo
AND it1.item_producto < it2.item_producto
INNER JOIN producto pr ON pr.prod_codigo = it1.item_producto
INNER JOIN producto pr2 ON pr2.prod_codigo = it2.item_producto
GROUP BY it1.item_producto, it2.item_producto, pr.prod_detalle, pr2.prod_detalle
HAVING COUNT(*) > 500
