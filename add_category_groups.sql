-- Agregar columna 'grupo' a la tabla categorías
ALTER TABLE public.categorias
ADD COLUMN IF NOT EXISTS grupo text;

-- (Opcional) Ejemplo para asignar grupos masivamente
-- UPDATE public.categorias SET grupo = 'Bebidas' WHERE nombre IN ('Gaseosas', 'Vinos', 'Cervezas');
-- UPDATE public.categorias SET grupo = 'Almacén' WHERE nombre IN ('Fideos', 'Arroz', 'Aceites');
-- UPDATE public.categorias SET grupo = 'Frescos' WHERE nombre IN ('Lácteos', 'Fiambres');

-- Por defecto, las que no tengan grupo quedarán bajo "Otros" o sin título en la lógica de JS.
