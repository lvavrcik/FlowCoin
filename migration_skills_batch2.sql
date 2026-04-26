-- Script to update existing skill names and populate new/existing skills for specific courses

-- 1. Rename the two specific skills if they exist (This updates them safely for Jedovnice)
UPDATE public.skills 
SET name = 'Postoj - surikata (výchozí pozice)'
WHERE name = 'Postoj - surikata';

UPDATE public.skills 
SET name = 'Postoj - ještěrka (ready pozice)'
WHERE name = 'Postoj - ještěrka';

-- 2. Insert all 21 skills for both courses
DO $$
DECLARE
    v_course_name TEXT;
    v_course_id UUID;
    v_skill_name TEXT;
    v_courses TEXT[] := ARRAY[
        'Jedovnice PreFlow/Flow (Pondělí)',
        'Mariánské PreFlow/Flow (Čtvrtek)'
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
    FOREACH v_course_name IN ARRAY v_courses
    LOOP
        -- Get the course ID
        SELECT id INTO v_course_id FROM public.courses WHERE name = v_course_name LIMIT 1;
        
        IF v_course_id IS NOT NULL THEN
            -- Insert each skill if it doesn't already exist for this course
            FOREACH v_skill_name IN ARRAY v_skills
            LOOP
                IF NOT EXISTS (SELECT 1 FROM public.skills WHERE name = v_skill_name AND course_id = v_course_id) THEN
                    INSERT INTO public.skills (name, flowcoins_reward, course_id)
                    VALUES (v_skill_name, 10, v_course_id);
                END IF;
            END LOOP;
        ELSE
            RAISE NOTICE 'Kurz "%" nebyl nalezen!', v_course_name;
        END IF;
    END LOOP;
END $$;
