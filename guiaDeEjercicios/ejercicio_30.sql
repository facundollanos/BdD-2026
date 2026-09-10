-- 30. Se desea obtener una estadistica de ventas del año 2012, para los empleados que sean
-- jefes, o sea, que tengan empleados a su cargo, para ello se requiere que realice la
-- consulta que retorne las siguientes columnas:
--  Nombre del Jefe
--  Cantidad de empleados a cargo
--  Monto total vendido de los empleados a cargo
--  Cantidad de facturas realizadas por los empleados a cargo
--  Nombre del empleado con mejor ventas de ese jefe
-- Debido a la perfomance requerida, solo se permite el uso de una subconsulta si fuese
-- necesario.
-- Los datos deberan ser ordenados por de mayor a menor por el Total vendido y solo se
-- deben mostrarse los jefes cuyos subordinados hayan realizado más de 10 facturas

SELECT
    j.empl_nombre + ' ' + j.empl_apellido AS nombre_jefe,

    COUNT(DISTINCT e.empl_codigo) AS empleados_a_cargo,

    SUM(f.fact_total) AS total_vendido,

    COUNT(DISTINCT
        f.fact_tipo + f.fact_sucursal + f.fact_numero
    ) AS cantidad_facturas,

    (
        SELECT TOP 1
            e2.empl_nombre + ' ' + e2.empl_apellido

        FROM Empleado e2

        INNER JOIN Factura f2
            ON f2.fact_vendedor = e2.empl_codigo

        WHERE e2.empl_jefe = j.empl_codigo
          AND YEAR(f2.fact_fecha) = 2012

        GROUP BY
            e2.empl_codigo,
            e2.empl_nombre,
            e2.empl_apellido

        ORDER BY
            SUM(f2.fact_total) DESC,
            e2.empl_codigo ASC

    ) AS mejor_empleado

FROM Empleado j

INNER JOIN Empleado e
    ON e.empl_jefe = j.empl_codigo

INNER JOIN Factura f
    ON f.fact_vendedor = e.empl_codigo

WHERE YEAR(f.fact_fecha) = 2012

GROUP BY
    j.empl_codigo,
    j.empl_nombre,
    j.empl_apellido

HAVING COUNT(DISTINCT
    f.fact_tipo + f.fact_sucursal + f.fact_numero
) > 10

ORDER BY SUM(f.fact_total) DESC;


