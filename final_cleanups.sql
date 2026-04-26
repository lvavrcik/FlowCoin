-- ==========================================
-- Final Cleanups & Adjustments
-- ==========================================

-- 1. DELETE MATYÁŠ AND TEREZA FROM SPECIFIC COURSE
-- First, find the course and remove their enrollments
DELETE FROM enrollments
WHERE course_id IN (
    SELECT id FROM courses WHERE name = 'Jedovnice PreFlow/Flow (Pondělí)'
)
AND kid_id IN (
    SELECT id FROM profiles WHERE first_name IN ('Matyáš', 'Tereza') AND role = 'kid'
);

-- 2. CLEAN UP ORPHANED PROFILES (Optional but recommended)
-- If Matyáš and Tereza have no other courses, it's best to delete their profiles 
-- entirely so they don't clutter the database.
DO $$ 
DECLARE
    orphan_id UUID;
BEGIN
    FOR orphan_id IN 
        SELECT id FROM profiles 
        WHERE first_name IN ('Matyáš', 'Tereza') 
          AND role = 'kid'
          AND id NOT IN (SELECT kid_id FROM enrollments)
    LOOP
        -- Delete any stray records just in case
        DELETE FROM kid_skills WHERE kid_id = orphan_id;
        DELETE FROM transactions WHERE kid_id = orphan_id;
        DELETE FROM purchases WHERE kid_id = orphan_id;
        
        -- Delete the actual profile
        DELETE FROM profiles WHERE id = orphan_id;
    END LOOP;
END $$;

-- 3. RENAME RIDER TO BAJKER
-- Updates the last name of any kid with the last name "Rider" to "Bajker"
UPDATE profiles
SET last_name = 'Bajker'
WHERE last_name = 'Rider' AND role = 'kid';
