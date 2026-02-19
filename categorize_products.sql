-- ALMACÉN: Aceites, aceitunas
UPDATE public.categorias 
SET grupo = 'Almacén' 
WHERE nombre ILIKE 'aceite%' 
   OR nombre ILIKE 'aceitu%'
   OR nombre ILIKE 'vinagre%';

-- KIOSCO: Alfajores, Bombones, Caramelos (car...)
UPDATE public.categorias 
SET grupo = 'Kiosco' 
WHERE nombre ILIKE 'alf%' 
   OR nombre ILIKE 'bombon%'
   OR nombre ILIKE 'car%'   -- Cuidado que podría atrapar "carnes" si las hubiera
   OR nombre ILIKE 'golosi%'
   OR nombre ILIKE 'chocolat%';

-- BEBIDAS: Aguas, Sodas
UPDATE public.categorias 
SET grupo = 'Bebidas' 
WHERE nombre ILIKE 'agua%' 
   OR nombre ILIKE 'soda%'
   OR nombre ILIKE 'gaseosa%'
   OR nombre ILIKE 'jugo%'
   OR nombre ILIKE 'cerveza%'
   OR nombre ILIKE 'vino%';

-- LIMPIEZA / HOGAR (Ejemplos comunes)
UPDATE public.categorias 
SET grupo = 'Limpieza' 
WHERE nombre ILIKE 'detergente%' 
   OR nombre ILIKE 'jabon%'
   OR nombre ILIKE 'papel%';

-- Verificar qué quedó sin asignar
-- SELECT nombre FROM public.categorias WHERE grupo IS NULL;
