-- Aumentar los precios de TODOS los productos en un 17%
-- Multiplicamos por 1.17 para agregar el 17% al valor actual.

UPDATE public.productos
SET precio = precio * 1.17;

-- (Opcional) Ver los nuevos precios para confirmar
-- SELECT nombre, precio FROM public.productos LIMIT 10;
