-- PASO A: Crear tabla temporal para los precios
drop table if exists public.precios_import;
create table public.precios_import (
  id text, -- ID del producto (ahora sí lo tenemos)
  precio text -- Precio nuevo
);

-- PASO B:
-- 1. Ve a Supabase Dashboard -> Table Editor.
-- 2. Selecciona 'precios_import'.
-- 3. Importa tu CSV/Excel de precios.
--    Mapea la columna de ID y la de PRECIO.

-- PASO C: Actualizar los precios en la tabla REAL de productos
-- Este comando toma el precio de 'precios_import' y actualiza directamente tu catálogo.
update public.productos prod
-- Limpiamos el precio (quitamos $ y ,) y lo convertimos a número
set precio = cast(regexp_replace(prec.precio, '[$,]', '', 'g') as numeric)
from public.precios_import prec
where prod.id = cast(prec.id as bigint); -- Compara por ID

-- PASO D: Verificar
-- select id, nombre, precio from public.productos_import;

-- Una vez hecho esto, puedes continuar con el PASO 3 del archivo 'csv_import_helper.sql' para mover todo a la tabla final.
