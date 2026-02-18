-- Elige la opción que prefieras descomentando la línea (quita los guiones -- al inicio)

-- OPCIÓN 1: Redondear a ENTEROS (sin centavos)
-- Ej: 153.45 -> 153
-- Ej: 153.80 -> 154
UPDATE public.productos
SET precio = ROUND(precio, 0);


-- OPCIÓN 2: Redondear a 2 DECIMALES (estándar monedas)
-- Ej: 153.456 -> 153.46
-- UPDATE public.productos
-- SET precio = ROUND(precio, 2);


-- OPCIÓN 3: Redondear a MÚLTIPLOS DE 10 (billetes)
-- Ej: 153 -> 150
-- Ej: 158 -> 160
-- UPDATE public.productos
-- SET precio = ROUND(precio / 10.0) * 10;
