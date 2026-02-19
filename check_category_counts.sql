-- Check product counts per category
SELECT 
    c.id, 
    c.nombre as categoria, 
    c.grupo,
    COUNT(p.id) as cantidad_productos
FROM categorias c
LEFT JOIN productos p ON c.id = p.categoria_id
GROUP BY c.id, c.nombre, c.grupo
ORDER BY c.grupo, c.nombre;

-- Check for products with invalid category_ids (orphans)
SELECT count(*) as productos_huerfanos
FROM productos
WHERE categoria_id IS NULL 
   OR categoria_id NOT IN (SELECT id FROM categorias);
