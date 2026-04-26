-- ==========================================
-- Rename Matěj in Jedovnice Course
-- ==========================================

-- This snippet finds exactly one kid named Matěj in the 'Jedovnice PreFlow/Flow (Pondělí)' 
-- course and updates his last name to 'Mongoosák'.

UPDATE profiles
SET last_name = 'Mongoosák'
WHERE id = (
    SELECT p.id 
    FROM profiles p
    JOIN enrollments e ON e.kid_id = p.id
    JOIN courses c ON c.id = e.course_id
    WHERE p.first_name = 'Matěj'
      AND p.role = 'kid'
      AND c.name = 'Jedovnice PreFlow/Flow (Pondělí)'
    LIMIT 1
);
