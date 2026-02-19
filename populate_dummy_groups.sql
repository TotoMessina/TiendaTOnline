-- Asignar grupos de ejemplo para ver el cambio en el menú
-- Ajusta los nombres de categorías según los que tengas reales en tu base de datos

UPDATE public.categorias SET grupo = 'Tecnología' WHERE nombre ILIKE '%tecnología%' OR nombre ILIKE '%celular%' OR nombre ILIKE '%audio%';
UPDATE public.categorias SET grupo = 'Hogar' WHERE nombre ILIKE '%hogar%' OR nombre ILIKE '%cocina%' OR nombre ILIKE '%deco%';
UPDATE public.categorias SET grupo = 'Moda' WHERE nombre ILIKE '%ropa%' OR nombre ILIKE '%moda%' OR nombre ILIKE '%accesorios%';

-- Si no tienes esas categorías exactas, aquí hay un "Truco" para asignar grupos al azar y probar:
-- UPDATE public.categorias SET grupo = 'Grupo A' WHERE id % 2 = 0;
-- UPDATE public.categorias SET grupo = 'Grupo B' WHERE id % 2 != 0;

-- Importante: Si la columna 'grupo' está vacía (null) en todas, el menú no mostrará divisiones.
