DO $$
BEGIN
    -- 1. Create temporary tables to hold IDs of what we want to KEEP
    CREATE TEMP TABLE IF NOT EXISTS keep_courses AS
    SELECT id FROM courses WHERE name IN (
        'Jedovnice PreFlow/Flow (Pondělí)',
        'Netro Shred (Pondělí)',
        'Netro PreFlow (Úterý)'
    );

    CREATE TEMP TABLE IF NOT EXISTS keep_kids AS
    SELECT DISTINCT kid_id AS id FROM enrollments WHERE course_id IN (SELECT id FROM keep_courses);

    CREATE TEMP TABLE IF NOT EXISTS keep_coaches AS
    SELECT DISTINCT coach_id AS id FROM course_coaches WHERE course_id IN (SELECT id FROM keep_courses);

    -- 2. Delete related records that don't belong to the kept entities
    
    -- Delete kid_skills for kids we are not keeping
    DELETE FROM kid_skills WHERE kid_id NOT IN (SELECT id FROM keep_kids);

    -- Delete kid_skills awarded by coaches we are not keeping
    DELETE FROM kid_skills WHERE coach_id NOT IN (SELECT id FROM keep_coaches);

    -- Delete skills not in kept courses
    DELETE FROM skills WHERE course_id NOT IN (SELECT id FROM keep_courses);

    -- Delete enrollments not in kept courses
    DELETE FROM enrollments WHERE course_id NOT IN (SELECT id FROM keep_courses);

    -- Delete course_coaches not in kept courses
    DELETE FROM course_coaches WHERE course_id NOT IN (SELECT id FROM keep_courses);

    -- Delete purchases of kids we are not keeping
    DELETE FROM purchases WHERE kid_id NOT IN (SELECT id FROM keep_kids);

    -- Delete transactions involving kids we are not keeping
    DELETE FROM transactions WHERE kid_id NOT IN (SELECT id FROM keep_kids);

    -- Delete transactions involving coaches we are not keeping
    DELETE FROM transactions WHERE coach_id NOT IN (SELECT id FROM keep_coaches);

    -- 3. Delete the main entities we are not keeping

    -- Delete courses
    DELETE FROM courses WHERE id NOT IN (SELECT id FROM keep_courses);

    -- Delete kids
    DELETE FROM profiles WHERE role = 'kid' AND id NOT IN (SELECT id FROM keep_kids);

    -- Delete coaches
    DELETE FROM profiles WHERE role = 'coach' AND id NOT IN (SELECT id FROM keep_coaches);

    -- 4. Drop temp tables
    DROP TABLE keep_courses;
    DROP TABLE keep_kids;
    DROP TABLE keep_coaches;
END $$;
