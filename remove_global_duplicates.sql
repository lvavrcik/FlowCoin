-- Skript na odstranění globálních dovedností, které se kříží s dovednostmi kurzů
DO $$
BEGIN
    -- 1. Nejdříve odstraníme záznamy dětí pro globální dovednosti (kde course_id je NULL), 
    -- pokud už existuje stejnojmenná dovednost přiřazená konkrétnímu kurzu.
    DELETE FROM public.kid_skills
    WHERE skill_id IN (
        SELECT s1.id 
        FROM public.skills s1
        WHERE s1.course_id IS NULL 
        AND EXISTS (
            SELECT 1 FROM public.skills s2 
            WHERE s2.name = s1.name AND s2.course_id IS NOT NULL
        )
    );

    -- 2. Odstraníme samotné globální dovednosti
    DELETE FROM public.skills s1
    WHERE s1.course_id IS NULL 
    AND EXISTS (
        SELECT 1 FROM public.skills s2 
        WHERE s2.name = s1.name AND s2.course_id IS NOT NULL
    );
END $$;
