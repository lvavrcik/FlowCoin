-- ==========================================
-- Surnames Removal & Adjustment
-- ==========================================

-- 1. CLEAR SURNAMES FOR ALL KIDS (GLOBAL)
-- As you decided to stick with first names, we set the last_name to an empty string globally.
-- Note: Supabase requires the field to exist (NOT NULL), so setting it to an empty string '' is perfect.
UPDATE profiles
SET last_name = ''
WHERE role = 'kid';

-- 2. RESOLVE DUPLICATE MATĚJ IN JEDOVNICE COURSE
-- Since both Matějs now have the same first name and empty last name,
-- we dynamically pick them and assign 'D.' to the first one, and 'K.' to the second one as their last name.
WITH matejs AS (
    SELECT p.id,
           ROW_NUMBER() OVER(ORDER BY p.id) as rnum
    FROM profiles p
    JOIN enrollments e ON e.kid_id = p.id
    JOIN courses c ON c.id = e.course_id
    WHERE c.name = 'Jedovnice PreFlow/Flow (Pondělí)'
      AND p.first_name = 'Matěj'
      AND p.role = 'kid'
)
UPDATE profiles p
SET last_name = CASE 
                  WHEN m.rnum = 1 THEN 'D.'
                  WHEN m.rnum = 2 THEN 'K.'
                  ELSE ''
                END
FROM matejs m
WHERE p.id = m.id;
