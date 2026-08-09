-- ==============================================
-- m4_consultas_negocio - Consultas de negocio
-- Autor: Agustina Arambarri
-- Fecha: 05/08/2026
-- Descripción: Consultas SQL sobre la tabla ventas
-- de Ventas_Tech_DB para responder las preguntas de
-- negocio de RetailPro: resumen mensual, ranking de
-- productos y clientes recurrentes.
-- ==============================================

--Consulta 1 
SELECT
    MONTH(fecha_venta) AS mes,
    SUM(cantidad * precio_unitario) AS total_facturado,
    COUNT(id_venta) AS cantidad_pedidos,
    ROUND(AVG(cantidad * precio_unitario), 2) AS ticket_promedio
FROM ventas
GROUP BY MONTH(fecha_venta);

--Consulta 2 
SELECT top 5
    id_producto,
    SUM(cantidad) AS unidades_vendidas,
    SUM(cantidad * precio_unitario) AS total_facturado
FROM ventas
GROUP BY id_producto
ORDER BY total_facturado DESC;

--Consulta 3 
Select id_cliente,
    COUNT (*) as cantidad_pedidos,
    sum (cantidad * precio_unitario) AS total_gastado
from ventas
GROUP BY id_cliente 
HAVING COUNT(*) > 1;


--Consulta 4 
SELECT
    MONTH(fecha_venta) AS mes,
    AVG(cantidad * precio_unitario) AS prom_facturado,
    CASE
        WHEN AVG(cantidad * precio_unitario) > (SELECT AVG(cantidad * precio_unitario) FROM ventas)
            THEN 'Por encima'
        WHEN AVG(cantidad * precio_unitario) < (SELECT AVG(cantidad * precio_unitario) FROM ventas)
            THEN 'Por debajo'
        ELSE 'En el promedio'
    END AS clasificacion
FROM ventas
GROUP BY MONTH(fecha_venta)
ORDER BY mes;


--Hallazgo 1: concentración brutal en el producto 1. 
--El producto 1: 3.600 de 6.444 totales = 56%
--Un solo producto genera más de la mitad de toda la facturación del mes. Y los 5 del top representan 6.084 de 6.444, o sea el 94%.

--Hallazgo 2: volumen ≠ rentabilidad
--El producto 2 vende 4 veces más unidades que el 1, pero genera 10 veces menos plata. Si mirabas solo unidades vendidas, sacabas la conclusión opuesta.

--Hallazgo 3: todos los clientes son recurrentes. La Consulta 3 devolvió 5 clientes, todos con 2 pedidos. Eso son 10 pedidos — exactamente el total del mes.
--O sea: el 100% de los clientes repitió compra. No hubo ni una compra de cliente nuevo que no volviera.
--Y además, los clientes 1 y 5 juntos gastaron 4.740 de 6.444 = 74% del total. Dos clientes sostienen tres cuartos de la facturación.
