-- Skript pro hromadné přidání dovedností do kurzů Netro Shred

DO $$
DECLARE
    v_course_name TEXT;
    v_course_id UUID;
    v_skill_name TEXT;
    v_courses TEXT[] := ARRAY[
        'Netro Shred (Středa)',
        'Netro Shred (Pondělí)'
    ];
    v_skills TEXT[] := ARRAY[
        'Výchozí pozice',
        'Ready pozice',
        'Ready pozice aplikovaná ve sjezdu',
        'Pumpování',
        'Pohyb ve 3 osách (rotace i angulace)',
        'Zatáčka pro',
        'Sjezd',
        'Jízda má flow',
        'Vyhoupnutí v rádiusu - precizně zvládnuté',
        'Skok základ - precizně zvládnuté',
        'Skok pro - precizně zvládnuté',
        'Bunny hop',
        'Manual - 5 metrů',
        'Manual - 15 metrů',
        'Wheelie - 5 metrů',
        'Wheelie - 15 metrů',
        'Braap',
        'Triky - table top',
        'Triky - whip',
        'Triky - x-up',
        'Triky - one hand',
        'Triky - one foot',
        'Triky - one foot low',
        'Triky - no foot',
        'Triky - T-bog',
        'Triky - Suicide nohander',
        'Triky - Condor'
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
