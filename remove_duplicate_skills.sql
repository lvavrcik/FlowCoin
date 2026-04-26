-- Skript na vyčištění duplicitních dovedností
DO $$
BEGIN
    -- 1. Pokud existuje stará dovednost bez závorek, smažeme její přiřazení a následně i ji samotnou (čistka testovacích dat)
    DELETE FROM public.kid_skills WHERE skill_id IN (SELECT id FROM public.skills WHERE name = 'Postoj - surikata');
    DELETE FROM public.skills WHERE name = 'Postoj - surikata';

    -- 2. Odstranění exaktních duplicit 'Postoj - surikata (výchozí pozice)' pro jeden kurz
    -- Ponechává z jednoho kurzu vždy jen tu nejstarší (jednu), zbytek maže
    DELETE FROM public.kid_skills WHERE skill_id IN (
        SELECT id FROM public.skills
        WHERE name = 'Postoj - surikata (výchozí pozice)'
        AND id NOT IN (
            SELECT (array_agg(id ORDER BY created_at ASC))[1]
            FROM public.skills
            WHERE name = 'Postoj - surikata (výchozí pozice)'
            GROUP BY COALESCE(course_id, '00000000-0000-0000-0000-000000000000'::uuid)
        )
    );

    DELETE FROM public.skills
    WHERE name = 'Postoj - surikata (výchozí pozice)'
    AND id NOT IN (
        SELECT (array_agg(id ORDER BY created_at ASC))[1]
        FROM public.skills
        WHERE name = 'Postoj - surikata (výchozí pozice)'
        GROUP BY COALESCE(course_id, '00000000-0000-0000-0000-000000000000'::uuid)
    );

END $$;
