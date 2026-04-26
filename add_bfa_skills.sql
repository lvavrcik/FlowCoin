DO $$
DECLARE
    v_course_name TEXT;
    v_course_id UUID;
    v_skill_name TEXT;
    v_courses TEXT[] := ARRAY[
        'Brno Freestyle Academy (Čtvrtek)',
        'Brno Freestyle Academy (Úterý)'
    ];
    v_skills TEXT[] := ARRAY[
        'Jízda má flow',
        'Vyhoupnutí v radiusu - precizně zvládnuté',
        'Skok základ - precizně zvládnuté',
        'Skok pro - precizně zvládnuté',
        'Skok zdolání (pumptrack) - flyout',
        'Skok zdolání (pumptrack) - dvoják',
        'Skok zdolání (pumptrack) - velká lavice',
        'Skok zdolání (pumptrack) - obě velké lavice',
        'Skok zdolání (dirty) - malé dirty',
        'Skok zdolání (dirty) - střední dirty',
        'Skok zdolání (dirty) - transfery',
        'Skok zdolání (dirty) - kůra',
        'Skok zdolání (dirty) - velká lajna',
        'Bunny hop',
        'Manual - 5 metrů',
        'Manual - 15 metrů',
        'Wheelie - 5 metrů',
        'Wheelie - 15 metrů',
        'Braap',
        'Triky - tabletop',
        'Triky - whip',
        'Triky - x-up',
        'Triky - one hand',
        'Triky - one foot',
        'Triky - no foot',
        'Triky - one foot flow',
        'Triky - T-bog',
        'Triky - suicide nohander',
        'Triky - condor',
        'Triky - can',
        'Triky - no foot can',
        'Triky - backflip'
    ];
BEGIN
    FOREACH v_course_name IN ARRAY v_courses
    LOOP
        SELECT id INTO v_course_id FROM public.courses WHERE name = v_course_name LIMIT 1;
        
        IF v_course_id IS NOT NULL THEN
            FOREACH v_skill_name IN ARRAY v_skills
            LOOP
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
