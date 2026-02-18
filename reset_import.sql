-- SCRIPT DE RESETEO COMPLETO PARA IMPORTACIÓN
-- Ejecuta esto si quieres borrar todas las tablas temporales y empezar de cero con un solo archivo Excel/CSV unido.

-- 1. Borrar tabla de importación de productos
drop table if exists public.productos_import;

-- 2. Borrar tabla de importación de precios
drop table if exists public.precios_import;

-- 3. (Opcional) Si también quieres borrar los datos finales para reimportar todo limpio:
-- truncate table public.productos cascade;
-- truncate table public.categorias cascade;

-- NOTA: Si ejecutas las líneas del paso 3, borrarás TODOS los productos de tu catálogo real.
-- Solo hazlo si estás en etapa de pruebas y quieres limpiar todo.
