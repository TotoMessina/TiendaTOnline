-- CORRECCIÓN DE PRECIOS
-- 1. Revertimos el aumento del 17% (Dividimos por 1.17)
-- 2. Aplicamos el aumento correcto del 10% (Multiplicamos por 1.10)

UPDATE public.productos
SET precio = (precio / 1.17) * 1.10;

-- Opcional: Redondear de nuevo si quieres que queden "limpios"
-- UPDATE public.productos SET precio = ROUND(precio, 0);
