-- 1. Ensure the skills table has the course_id column
DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM information_schema.columns WHERE table_name = 'skills' AND column_name = 'course_id') THEN
        ALTER TABLE public.skills ADD COLUMN course_id UUID REFERENCES public.courses(id);
    END IF;
END $$;

-- 2. Insert skills for Jedovnice PreFlow/Flow (Pondělí)
DO $$
DECLARE
    v_course_id UUID;
    v_skill_name TEXT;
    v_skills TEXT[] := ARRAY[
        'Postoj - surikata',
        'Postoj - ještěrka',
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
        'Skok pro'
    ];
BEGIN
    -- Get the course ID
    SELECT id INTO v_course_id FROM public.courses WHERE name = 'Jedovnice PreFlow/Flow (Pondělí)' LIMIT 1;
    
    IF v_course_id IS NOT NULL THEN
        -- Insert each skill with course_id
        FOREACH v_skill_name IN ARRAY v_skills
        LOOP
            IF NOT EXISTS (SELECT 1 FROM public.skills WHERE name = v_skill_name AND course_id = v_course_id) THEN
                INSERT INTO public.skills (name, flowcoins_reward, course_id)
                VALUES (v_skill_name, 10, v_course_id);
            END IF;
        END LOOP;
    ELSE
        RAISE NOTICE 'Course Jedovnice PreFlow/Flow (Pondělí) not found!';
    END IF;
END $$;
