-- 20. Escriba una consulta sql que retorne un ranking de los mejores 3 empleados del 2012
-- Se debera retornar legajo, nombre y apellido, anio de ingreso, puntaje 2011, puntaje
-- 2012. El puntaje de cada empleado se calculara de la siguiente manera: para los que
-- hayan vendido al menos 50 facturas el puntaje se calculara como la cantidad de facturas
-- que superen los 100 pesos que haya vendido en el año, para los que tengan menos de 50
-- facturas en el año el calculo del puntaje sera 


---version profesor
SELECT TOP 3 e.empl_codigo as LEGAJO, e.empl_nombre, e.empl_apellido, YEAR(e.empl_ingreso) AS añoIngreso,
(SELECT 1) AS puntaje2011,
ISNULL((SELECT (SELECT COUNT(*) FROM Factura f2 
WHERE YEAR (f2.fact_fecha) = 2012 AND f2.fact_vendedor = f.fact_vendedor AND f2.fact_total > 100)
FROM factura f 
WHERE YEAR (f.fact_fecha) = 2012 
AND f.fact_vendedor = e.empl_codigo
GROUP BY f.fact_vendedor
HAVING COUNT(*) > 49) ,0) 
+
ISNULL((SELECT (SELECT COUNT(*) FROM Factura f2 
WHERE YEAR (f2.fact_fecha) = 2012 AND f2.fact_vendedor IN (SELECT e3.empl_codigo FROM Empleado e3 WHERE e3.empl_jefe = f.fact_vendedor))
FROM factura f 
WHERE YEAR (f.fact_fecha) = 2012 
AND f.fact_vendedor = e.empl_codigo
GROUP BY f.fact_vendedor
HAVING COUNT(*) < 50),0) 
AS puntaje2012
FROM Empleado e
ORDER BY puntaje2012 DESC
