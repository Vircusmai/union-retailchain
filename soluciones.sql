-- ══════════════════════════════════════════
-- RetailChain — UNION y UNION ALL
-- Autor: Virginia Analia Cusmai
-- Fecha: 2026-10-06
-- ══════════════════════════════════════════

-- ── CONSULTA 1: UNION ────────────────────
-- Reporte de Catálogo Unificado
-- Pregunta de negocio: ¿Qué productos únicos comercializa la empresa en toda su red de sucursales?
-- Operador: UNION (elimina duplicados lógicos del catálogo entre sucursales)

SELECT id_producto, nombre_producto, categoria
FROM inventario_sucursal_norte
UNION
SELECT id_producto, nombre_producto, categoria
FROM inventario_sucursal_sur
ORDER BY id_producto;


-- ── CONSULTA 2: UNION ALL ────────────────
-- Auditoría de Stock Total
-- Pregunta de negocio: ¿Cuántos registros físicos de stock existen en total entre ambas sucursales?
-- Operador: UNION ALL (mantiene la totalidad de los registros de inventario físico sin filtrar)

SELECT id_producto, nombre_producto, categoria, stock
FROM inventario_sucursal_norte
UNION ALL
SELECT id_producto, nombre_producto, categoria, stock
FROM inventario_sucursal_sur
ORDER BY id_producto;


-- ── CONSULTA 3: COMPARACIÓN DE RESULTADOS ─
-- Ejecución comparativa para contrastar el total de registros devueltos por cada operador

-- Conteo de productos únicos consolidados en catálogo (UNION)
SELECT COUNT(*) AS filas_union 
FROM (
    SELECT id_producto, nombre_producto, categoria FROM inventario_sucursal_norte
    UNION
    SELECT id_producto, nombre_producto, categoria FROM inventario_sucursal_sur
) AS resultado_union;

-- Conteo de registros físicos totales auditados (UNION ALL)
SELECT COUNT(*) AS filas_union_all 
FROM (
    SELECT id_producto, nombre_producto, categoria, stock FROM inventario_sucursal_norte
    UNION ALL
    SELECT id_producto, nombre_producto, categoria, stock FROM inventario_sucursal_sur
) AS resultado_union_all;
