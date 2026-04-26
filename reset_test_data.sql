-- Skript na resetování testovacích dat jezdců
DO $$
BEGIN
    -- 1. Smazat historii všech domluvených transakcí (přičtené/odečtené FlowCoiny)
    DELETE FROM public.transactions;

    -- 2. Smazat historii všech nákupů v obchodě
    DELETE FROM public.purchases;

    -- 3. Smazat všechny záznamy o splněných dovednostech (všechny dovednosti budou opět dostupné k plnění)
    DELETE FROM public.kid_skills;

    -- 4. Ručně vynulovat zůstatek FlowCoinů všem jezdcům na nulu
    -- (Smazání transakcí neupraví bilance zpátky, protože triggery fungují jen při vložení - INSERT)
    UPDATE public.profiles 
    SET flowcoins_balance = 0 
    WHERE role = 'kid';
    
END $$;
