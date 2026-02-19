-- SCRIPT MASIVO DE CATEGORIZACIÓN
-- Ejecutar en Supabase para organizar todo el menú

-- 1. KIOSCO (Golosinas, Chocolates, Alfajores)
UPDATE public.categorias SET grupo = 'Kiosco' WHERE nombre IN (
    'Alfajores', 'Alfajor', -- Generico
    'Banados', 'Bocaditos', 'Bonafide', 'Cacao', 
    'Caramelos', 'ChARCOR', 'ChLHER', 'ChMDLZ', 
    'ChocManiArcor', 'ChocManiGeorgalos', 'ChocManiNestle', 'ChocManiVarios', 
    'ChocMBonafide', 'ChocMCadbury', 'ChocMFelfort', 'ChocMGeo', 
    'ChocMKinder', 'ChocMVarios', 'ChocRellenos', 
    'ChuARCOR', 'ChuBEN', 'ChuGEO', 'ChuLher', 'ChuPOP', 'ChuVarios', 'ChVarios',
    'Confituras', 'Conitos', 'Cubanitos', 
    'GomMisky', 'GomMOG', 'GomTembleke', 'GomVarias', 
    'MacizoArcor', 'Malvaviscos', 'Muecas', 
    'PascuasArcor', 'PastArcor', 'PastDolce', 'PastDorins', 'PastHalls', 'PastTictac', 'PastVarias', 
    'Placer', 'PostredeMani', 'PostresyFlanes', 
    'ProdChocARCOR', 'ProdChocBonafide', 'ProdChocGAM', 'ProdChocNESTLE', 'ProdChocVarios', 
    'Repostería', 'Turrones', 'Varios'
);

-- 2. GALLETITAS (Dulces y Saladas)
UPDATE public.categorias SET grupo = 'Galletitas' WHERE nombre IN (
    'Bizcochos', 'Bizcochuelos', 'Budines', 'BudinesMadalenas', 
    'CerealesArcor', 'CerealesGeorgalos', 'CerealesLasfor', 'CerealFort', 'OtrosCereales',
    'CrackersAgua', 
    'GalletasArrozCerealko', 'GalletasArrozDosHermanos', 'GalletasArrozVarias', 
    'GalletasDulces9DeOro', 'GalletasDulcesArcor', 'GalletasDulcesCelosas', 
    'GalletasDulcesCoronitas', 'GalletasDulcesFantoche', 'GalletasDulcesFrutigran', 
    'GalletasDulcesHojalmar', 'GalletasDulcesNonna', 'GalletasDulcesOkebon', 
    'GalletasDulcesParnor', 'GalletasDulcesToddy', 'GalletasDulcesTrio', 'GalletasDulcesVarias', 
    'GalletasRellenasArcor', 'GalletasRellenasCoronitas', 'GalletasRellenasNonna', 
    'GalletasRellenasParnor', 'GalletasRellenasVarias', 'GalletasSaladasVarias', 
    'ObleasArcor', 'ObleasGallo', 'ObleasRecital', 'ObleasVarias', 'Oblita', 
    'Pepas', 'Tostadas'
);

-- 3. BEBIDAS (Gaseosas, Aguas, Jugos)
UPDATE public.categorias SET grupo = 'Bebidas' WHERE nombre IN (
    'Aquarius', 'Baggio', 'Cepita', 'CocaCola', 'Energizantes', 'Fanta', 
    'Fernet/Blanca', 'Isotonicas', 'Levite', 'Manaos', 'Pindapoy', 'Schweppes', 'Sprite', 'Terma',
    'Aguas', 'Sodas', 'Jugos'
);

-- 4. ALMACÉN (Desayuno, Comidas)
UPDATE public.categorias SET grupo = 'Almacén' WHERE nombre IN (
    'Aderezos', 'Azucar', 'Cafe', 'DDL', 'Edulcorantes', 
    'HarinasPremezclas', 'MateCocidoyTe', 'Mermeladas', 'MermeladasLight', 
    'Tomates', 'Yerba', 'Aceites', 'Aceitunas', 'Arroz', 'Fideos'
);

-- 5. SNACKS (Salados, Papas)
UPDATE public.categorias SET grupo = 'Snacks' WHERE nombre IN (
    'Aireados', 'Chizitos', 'GPepsico', 'Mani', 'Nachos', 'Palitos', 
    'PapasKrachitos', 'PapasPepsico', 'PapasPringles', 'PapasSaladix', 
    'OtrosSnacks', 'OtrosSnacksPipas', 'OtrosSnacksSaladix', 'Snacks', 
    'Pochoclo/Tutuca'
);

-- 6. FRESCOS / LÁCTEOS
UPDATE public.categorias SET grupo = 'Frescos' WHERE nombre IN (
    'Leches', 'Quesos', 'Gelatinas', 'Manteca', 'Yogur'
);

-- 7. OTROS (Cosas sueltas)
UPDATE public.categorias SET grupo = 'Varios' WHERE nombre IN (
    'FrutasyVegetales', 'Tabaco', 'PanyQuesoRallado', 'FULLMINT'
);

-- Limpieza final de nombres raros que hayan quedado sueltos con patrones
UPDATE public.categorias SET grupo = 'Kiosco' WHERE grupo IS NULL AND nombre ILIKE 'alf%';
UPDATE public.categorias SET grupo = 'Kiosco' WHERE grupo IS NULL AND nombre ILIKE 'bombon%';
UPDATE public.categorias SET grupo = 'Kiosco' WHERE grupo IS NULL AND nombre ILIKE 'caramelo%';
