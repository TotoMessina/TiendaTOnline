-- SOLUCIÓN PARA ERROR DE IMPORTACIÓN
-- El error ocurre porque tu CSV tiene el NOMBRE de la categoría (texto) y la tabla espera el ID (número).

-- PASO 1: Crea esta tabla temporal. ¡TRUCO! Hacemos todo TEXTO para que no falle la importación.
-- Luego arreglaremos los tipos de datos en el paso 3.
drop table if exists public.productos_import;
create table public.productos_import (
  id text, -- Lo importamos como texto por si acaso
  nombre text,
  descripcion text,
  precio text, -- Importante: texto para evitar errores con símbolos de moneda
  imagen_url text,
  categoria_nombre text, 
  categoria_id text 
);

-- PASO 2:
-- Ve al Dashboard de Supabase -> Table Editor.
-- Selecciona la tabla 'productos_import'.
-- Haz clic en "Insert" -> "Import Data from CSV".
-- Sube tu archivo CSV. AHORA NO DEBERÍA FALLAR porque todo entra como texto.

-- PASO 3: Ejecuta el siguiente script para limpiar y mover los datos:

-- A. CREAR CATEGORÍAS (Mejorado: usa coalesce para buscar nombre en ambos campos)
insert into public.categorias (nombre)
select distinct trim(coalesce(nullif(categoria_nombre, ''), nullif(categoria_id, '')))
from public.productos_import
where coalesce(nullif(categoria_nombre, ''), nullif(categoria_id, '')) is not null 
  -- Solo insertamos si NO parece ser un ID numérico (es decir, es texto como "Aceites")
  and coalesce(nullif(categoria_nombre, ''), nullif(categoria_id, '')) !~ '^[0-9]+$'
  and trim(coalesce(nullif(categoria_nombre, ''), nullif(categoria_id, ''))) not in (select nombre from public.categorias);

-- B. INSERTAR PRODUCTOS (Mejorado: a prueba de fallos + ID MANUAL)
insert into public.productos (id, nombre, descripcion, precio, imagen_url, categoria_id)
select
  cast(p.id as bigint) as id, -- Importamos el ID explícitamente
  p.nombre,
  p.descripcion,
  -- Limpiamos el precio: quitamos '$' y ',' si existen. Si es nulo o vacío, ponemos 0.
  coalesce(cast(nullif(regexp_replace(p.precio, '[$,]', '', 'g'), '') as numeric), 0) as precio,
  p.imagen_url,
  -- Lógica de categorías SUPER ROBUSTA:
  case 
    -- 1. Si categoria_id es NUMÉRICO, úsalo como ID
    when p.categoria_id ~ '^[0-9]+$' then cast(p.categoria_id as bigint)
    -- 2. Si categoria_nombre coincide con una categoría, usa su ID
    when c_nombre.id is not null then c_nombre.id
    -- 3. Si categoria_id (que no es número) coincide con una categoría, usa su ID
    when c_id_text.id is not null then c_id_text.id
    else null
  end as categoria_id
from public.productos_import p
left join public.categorias c_nombre on trim(p.categoria_nombre) = c_nombre.nombre
left join public.categorias c_id_text on trim(p.categoria_id) = c_id_text.nombre;

-- PASO 4: Verifica
-- select * from public.productos;

-- PASO 5: Limpieza
-- drop table public.productos_import;
