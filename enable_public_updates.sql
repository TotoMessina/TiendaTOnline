-- PERMITIR ACTUALIZACIONES PÚBLICAS (Para que el script de Python pueda guardar las imágenes)
-- ADVERTENCIA: Esto permite que cualquiera modifique los productos. 
-- Después de correr el script de imágenes, puedes borrar esta política.

create policy "Permitir updates públicos"
on public.productos
for update
using ( true )
with check ( true );
