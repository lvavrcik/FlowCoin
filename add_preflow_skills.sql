DO $$
DECLARE
    v_course_name TEXT;
    v_course_id UUID;
    v_skill_name TEXT;
    v_courses TEXT[] := ARRAY[
        'Mariánské PreFlow/Flow (Čtvrtek)',
        'Jedovnice PreFlow/Flow (Pondělí)',
        'Netro PreFlow (Úterý)'
    ];
    v_skills TEXT[] := ARRAY[
        'Postoj - surikata (výchozí pozice)',
        'Postoj - ještěrka (ready pozice)',
        'Pohled',
        'Čtení trailu',
        'Pumpování',
        'Zatáčka základní',
        'Zatáčka pro',
        'Sjezd',
        'Sjezd překážky',
        'Vyjetí na překážku',
        'Nadhození předního kola',
        'Jízda má flow',
        'Kopírování terénu',
        'Vyhoupnutí v radiusu',
        'Skok základní',
        'Skok pro',
        'Ještěrka/ready pozice aplikovaná ve sjezdu',
        'Pohyb ve 3 osách (rotace i angulace)',
        'Bunny hop',
        'Manual',
        'Wheelie'
    ];
BEGIN
    -- Projdeme oba kurzy ze seznamu
    FOREACH v_course_name IN ARRAY v_courses
    LOOP
        -- Získáme ID kurzu
        SELECT id INTO v_course_id FROM public.courses WHERE name = v_course_name LIMIT 1;
        
        IF v_course_id IS NOT NULL THEN
            -- Pro každý kurz projdeme všechny nové dovednosti
            FOREACH v_skill_name IN ARRAY v_skills
            LOOP
                -- Vložíme pouze pokud ještě neexistuje pro tento kurz
                IF NOT EXISTS (SELECT 1 FROM public.skills WHERE name = v_skill_name AND course_id = v_course_id) THEN
                    INSERT INTO public.skills (name, flowcoins_reward, course_id)
                    VALUES (v_skill_name, 10, v_course_id);
                END IF;
            END LOOP;
        ELSE
            RAISE NOTICE 'Chyba: Kurz "%" nebyl v databázi nalezen!', v_course_name;
        END IF;
    END LOOP;
END $$;
