-- 20. Escriba una consulta sql que retorne un ranking de los mejores 3 empleados del 2012
-- Se debera retornar legajo, nombre y apellido, anio de ingreso, puntaje 2011, puntaje
-- 2012. El puntaje de cada empleado se calculara de la siguiente manera: para los que
-- hayan vendido al menos 50 facturas el puntaje se calculara como la cantidad de facturas
-- que superen los 100 pesos que haya vendido en el año, para los que tengan menos de 50
-- facturas en el año el calculo del puntaje sera 




SELECT TOP 3
    ranking.legajo,
    ranking.nombre,
    ranking.apellido,
    ranking.anio_ingreso,
    ranking.puntaje_2011,
    ranking.puntaje_2012

FROM
(

    /* =====================================================
       CASO 1:
       >= 50 facturas en 2011
       >= 50 facturas en 2012
       ===================================================== */

    SELECT
        e.empl_codigo AS legajo,
        e.empl_nombre AS nombre,
        e.empl_apellido AS apellido,
        YEAR(e.empl_ingreso) AS anio_ingreso,

        (
            SELECT COUNT(*)
            FROM Factura f11
            WHERE f11.fact_vendedor = e.empl_codigo
              AND YEAR(f11.fact_fecha) = 2011
              AND f11.fact_total > 100
        ) AS puntaje_2011,

        (
            SELECT COUNT(*)
            FROM Factura f12
            WHERE f12.fact_vendedor = e.empl_codigo
              AND YEAR(f12.fact_fecha) = 2012
              AND f12.fact_total > 100
        ) AS puntaje_2012

    FROM Empleado e

    WHERE
        (
            SELECT COUNT(*)
            FROM Factura f11
            WHERE f11.fact_vendedor = e.empl_codigo
              AND YEAR(f11.fact_fecha) = 2011
        ) >= 50

        AND

        (
            SELECT COUNT(*)
            FROM Factura f12
            WHERE f12.fact_vendedor = e.empl_codigo
              AND YEAR(f12.fact_fecha) = 2012
        ) >= 50


    UNION ALL


    /* =====================================================
       CASO 2:
       >= 50 facturas en 2011
       < 50 facturas en 2012
       ===================================================== */

    SELECT
        e.empl_codigo AS legajo,
        e.empl_nombre AS nombre,
        e.empl_apellido AS apellido,
        YEAR(e.empl_ingreso) AS anio_ingreso,

        (
            SELECT COUNT(*)
            FROM Factura f11
            WHERE f11.fact_vendedor = e.empl_codigo
              AND YEAR(f11.fact_fecha) = 2011
              AND f11.fact_total > 100
        ) AS puntaje_2011,

        (
            SELECT COUNT(*) * 0.5
            FROM Empleado subordinado
            INNER JOIN Factura f12
                ON f12.fact_vendedor = subordinado.empl_codigo
            WHERE subordinado.empl_jefe = e.empl_codigo
              AND YEAR(f12.fact_fecha) = 2012
        ) AS puntaje_2012

    FROM Empleado e

    WHERE
        (
            SELECT COUNT(*)
            FROM Factura f11
            WHERE f11.fact_vendedor = e.empl_codigo
              AND YEAR(f11.fact_fecha) = 2011
        ) >= 50

        AND

        (
            SELECT COUNT(*)
            FROM Factura f12
            WHERE f12.fact_vendedor = e.empl_codigo
              AND YEAR(f12.fact_fecha) = 2012
        ) < 50


    UNION ALL


    /* =====================================================
       CASO 3:
       < 50 facturas en 2011
       >= 50 facturas en 2012
       ===================================================== */

    SELECT
        e.empl_codigo AS legajo,
        e.empl_nombre AS nombre,
        e.empl_apellido AS apellido,
        YEAR(e.empl_ingreso) AS anio_ingreso,

        (
            SELECT COUNT(*) * 0.5
            FROM Empleado subordinado
            INNER JOIN Factura f11
                ON f11.fact_vendedor = subordinado.empl_codigo
            WHERE subordinado.empl_jefe = e.empl_codigo
              AND YEAR(f11.fact_fecha) = 2011
        ) AS puntaje_2011,

        (
            SELECT COUNT(*)
            FROM Factura f12
            WHERE f12.fact_vendedor = e.empl_codigo
              AND YEAR(f12.fact_fecha) = 2012
              AND f12.fact_total > 100
        ) AS puntaje_2012

    FROM Empleado e

    WHERE
        (
            SELECT COUNT(*)
            FROM Factura f11
            WHERE f11.fact_vendedor = e.empl_codigo
              AND YEAR(f11.fact_fecha) = 2011
        ) < 50

        AND

        (
            SELECT COUNT(*)
            FROM Factura f12
            WHERE f12.fact_vendedor = e.empl_codigo
              AND YEAR(f12.fact_fecha) = 2012
        ) >= 50


    UNION ALL


    /* =====================================================
       CASO 4:
       < 50 facturas en 2011
       < 50 facturas en 2012
       ===================================================== */

    SELECT
        e.empl_codigo AS legajo,
        e.empl_nombre AS nombre,
        e.empl_apellido AS apellido,
        YEAR(e.empl_ingreso) AS anio_ingreso,

        (
            SELECT COUNT(*) * 0.5
            FROM Empleado subordinado
            INNER JOIN Factura f11
                ON f11.fact_vendedor = subordinado.empl_codigo
            WHERE subordinado.empl_jefe = e.empl_codigo
              AND YEAR(f11.fact_fecha) = 2011
        ) AS puntaje_2011,

        (
            SELECT COUNT(*) * 0.5
            FROM Empleado subordinado
            INNER JOIN Factura f12
                ON f12.fact_vendedor = subordinado.empl_codigo
            WHERE subordinado.empl_jefe = e.empl_codigo
              AND YEAR(f12.fact_fecha) = 2012
        ) AS puntaje_2012

    FROM Empleado e

    WHERE
        (
            SELECT COUNT(*)
            FROM Factura f11
            WHERE f11.fact_vendedor = e.empl_codigo
              AND YEAR(f11.fact_fecha) = 2011
        ) < 50

        AND

        (
            SELECT COUNT(*)
            FROM Factura f12
            WHERE f12.fact_vendedor = e.empl_codigo
              AND YEAR(f12.fact_fecha) = 2012
        ) < 50

) ranking

ORDER BY ranking.puntaje_2012 DESC;



--otra forma pero con when y else
-- SELECT TOP 3

--     e.empl_codigo AS legajo,

--     e.empl_nombre,

--     e.empl_apellido,

--     YEAR(e.empl_ingreso) AS anio_ingreso,


--     /* PUNTAJE 2011 */

--     CASE

--         WHEN (
--             SELECT COUNT(*)
--             FROM Factura f11
--             WHERE f11.fact_vendedor = e.empl_codigo
--               AND YEAR(f11.fact_fecha) = 2011
--         ) >= 50

--         THEN (
--             SELECT COUNT(*)
--             FROM Factura f11
--             WHERE f11.fact_vendedor = e.empl_codigo
--               AND YEAR(f11.fact_fecha) = 2011
--               AND f11.fact_total > 100
--         )

--         ELSE (
--             SELECT COUNT(*) * 0.5
--             FROM Empleado s11

--             INNER JOIN Factura f11
--                 ON f11.fact_vendedor = s11.empl_codigo

--             WHERE s11.empl_jefe = e.empl_codigo
--               AND YEAR(f11.fact_fecha) = 2011
--         )

--     END AS puntaje_2011,


--     /* PUNTAJE 2012 */

--     CASE

--         WHEN (
--             SELECT COUNT(*)
--             FROM Factura f12
--             WHERE f12.fact_vendedor = e.empl_codigo
--               AND YEAR(f12.fact_fecha) = 2012
--         ) >= 50

--         THEN (
--             SELECT COUNT(*)
--             FROM Factura f12
--             WHERE f12.fact_vendedor = e.empl_codigo
--               AND YEAR(f12.fact_fecha) = 2012
--               AND f12.fact_total > 100
--         )

--         ELSE (
--             SELECT COUNT(*) * 0.5
--             FROM Empleado s12

--             INNER JOIN Factura f12
--                 ON f12.fact_vendedor = s12.empl_codigo

--             WHERE s12.empl_jefe = e.empl_codigo
--               AND YEAR(f12.fact_fecha) = 2012
--         )

--     END AS puntaje_2012

-- FROM Empleado e

-- ORDER BY puntaje_2012 DESC;

