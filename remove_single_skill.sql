DO $$
DECLARE
    id_to_keep UUID;
    id_to_delete UUID;
BEGIN
    -- Najdeme první ID (to si necháme)
    SELECT id INTO id_to_keep 
    FROM public.skills 
    WHERE name = 'Postoj - surikata (výchozí pozice)' 
    ORDER BY created_at ASC 
    LIMIT 1;

    -- Najdeme druhé ID (duplikát, který smažeme)
    SELECT id INTO id_to_delete 
    FROM public.skills 
    WHERE name = 'Postoj - surikata (výchozí pozice)' 
      AND id != id_to_keep
    LIMIT 1;

    IF id_to_delete IS NOT NULL THEN
        -- KROK 1: Pokud některé dítě omylem zaškrtlo OBĚ verze, záznam o smazané verzi rovnou vymažeme.
        DELETE FROM public.kid_skills ks
        WHERE ks.skill_id = id_to_delete
          AND EXISTS (
             SELECT 1 FROM public.kid_skills ks2
             WHERE ks2.kid_id = ks.kid_id AND ks2.skill_id = id_to_keep
          );

        -- KROK 2: Všechny ostatní záznamy dětí napojené na duplikát "přepojíme" na hlavní ID.
        UPDATE public.kid_skills
        SET skill_id = id_to_keep
        WHERE skill_id = id_to_delete;

        -- KROK 3: Teď už ve smazávaném ID nejsou žádná závislá data, můžeme ho bezpečně smazat.
        DELETE FROM public.skills 
        WHERE id = id_to_delete;
    END IF;
END $$;
