-- Skript pro smazání všech položek v obchodě (merch_items)
DO $$
BEGIN
    -- Nejdříve smažeme všechny testovací nákupy, abychom zamezili chybám s klíči
    DELETE FROM public.purchases;
    
    -- Poté odstraníme všechny produkty z obchodu
    DELETE FROM public.merch_items;
END $$;
