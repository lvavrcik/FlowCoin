-- ==========================================
-- Bruteforce Roster Fix for 'Netro Shred (Středa)'
-- ==========================================
-- This script guarantees exactly the 16 kids requested are assigned.
-- It intelligently searches the database for the existing "Sára" and "Kuba F."
-- (to preserve their profiles/balances) and maps them into this course.

DO $$ 
DECLARE
    courseid UUID;
    kid RECORD;
    d_count INT := 1;
    single_names TEXT[] := ARRAY['Vojta', 'Matěj', 'Kryštof', 'Jakub', 'Samuel', 'Patrik', 'Filip', 'Štefan', 'David', 'Tadeáš', 'Prokop', 'Edward'];
    sn TEXT;
    sn_count INT;
    sara_id UUID;
    kubaf_id UUID;
BEGIN
    -- 1. Identify the Course
    SELECT id INTO courseid FROM courses WHERE name = 'Netro Shred (Středa)' LIMIT 1;
    IF courseid IS NULL THEN
        RAISE NOTICE 'Course not found.';
        RETURN;
    END IF;

    -- 2. Clear known collided last names inside this course to start fresh (For 'Dan')
    UPDATE profiles 
    SET last_name = '' 
    WHERE id IN (SELECT kid_id FROM enrollments WHERE course_id = courseid)
      AND first_name = 'Dan';

    -- 3. RESOLVE "Dan" (Target: exactly 2)
    FOR kid IN (
        SELECT p.id 
        FROM profiles p
        JOIN enrollments e ON e.kid_id = p.id
        WHERE e.course_id = courseid AND p.first_name = 'Dan'
        ORDER BY p.created_at ASC
    ) LOOP
        IF d_count <= 2 THEN
            -- Ensure last name is empty
            UPDATE profiles SET last_name = '' WHERE id = kid.id;
            d_count := d_count + 1;
        ELSE
            -- We have more than 2 Dans!
            DELETE FROM kid_skills WHERE kid_id = kid.id;
            DELETE FROM enrollments WHERE kid_id = kid.id;
            DELETE FROM profiles WHERE id = kid.id;
        END IF;
    END LOOP;

    -- If we have fewer than 2 Dans, create them
    WHILE d_count <= 2 LOOP
        WITH newkid AS (
            INSERT INTO profiles (id, role, first_name, last_name, flowcoins_balance, pin_code)
            VALUES (gen_random_uuid(), 'kid', 'Dan', '', 0, lpad(floor(random()*90000 + 10000)::text, 5, '0'))
            RETURNING id
        )
        INSERT INTO enrollments (course_id, kid_id) SELECT courseid, id FROM newkid;
        d_count := d_count + 1;
    END LOOP;


    -- 4. Re-use Sára and Kuba F. from the entire database (so they retain PINs and see 2 courses)
    
    -- Find Sára globally
    SELECT id INTO sara_id FROM profiles WHERE first_name = 'Sára' AND role = 'kid' LIMIT 1;
    
    IF sara_id IS NOT NULL THEN
        -- If found, softly enroll her
        IF NOT EXISTS(SELECT 1 FROM enrollments WHERE kid_id = sara_id AND course_id = courseid) THEN
            INSERT INTO enrollments (course_id, kid_id) VALUES (courseid, sara_id);
        END IF;
    ELSE
        -- Failsafe: if she was deleted by mistake previously, create her fresh
        WITH newkid AS (
            INSERT INTO profiles (id, role, first_name, last_name, flowcoins_balance, pin_code)
            VALUES (gen_random_uuid(), 'kid', 'Sára', '', 0, lpad(floor(random()*90000 + 10000)::text, 5, '0'))
            RETURNING id
        )
        SELECT id INTO sara_id FROM newkid;
        INSERT INTO enrollments (course_id, kid_id) VALUES (courseid, sara_id);
    END IF;

    -- Find Kuba F. globally
    SELECT id INTO kubaf_id FROM profiles WHERE first_name = 'Kuba' AND last_name = 'F.' AND role = 'kid' LIMIT 1;
    
    IF kubaf_id IS NOT NULL THEN
        -- If found, softly enroll him
        IF NOT EXISTS(SELECT 1 FROM enrollments WHERE kid_id = kubaf_id AND course_id = courseid) THEN
            INSERT INTO enrollments (course_id, kid_id) VALUES (courseid, kubaf_id);
        END IF;
    ELSE
        -- Failsafe: create fresh 
        WITH newkid AS (
            INSERT INTO profiles (id, role, first_name, last_name, flowcoins_balance, pin_code)
            VALUES (gen_random_uuid(), 'kid', 'Kuba', 'F.', 0, lpad(floor(random()*90000 + 10000)::text, 5, '0'))
            RETURNING id
        )
        SELECT id INTO kubaf_id FROM newkid;
        INSERT INTO enrollments (course_id, kid_id) VALUES (courseid, kubaf_id);
    END IF;


    -- 5. RESOLVE STRICT SINGLES (exactly 1 of each)
    FOREACH sn IN ARRAY single_names LOOP
        sn_count := 1;
        FOR kid IN (
            SELECT p.id 
            FROM profiles p
            JOIN enrollments e ON e.kid_id = p.id
            WHERE e.course_id = courseid AND p.first_name = sn
            ORDER BY p.created_at ASC
        ) LOOP
            IF sn_count = 1 THEN
                UPDATE profiles SET last_name = '' WHERE id = kid.id;
                sn_count := sn_count + 1;
            ELSE
                DELETE FROM kid_skills WHERE kid_id = kid.id;
                DELETE FROM enrollments WHERE kid_id = kid.id;
                DELETE FROM profiles WHERE id = kid.id;
            END IF;
        END LOOP;

        IF sn_count = 1 THEN
            WITH newkid AS (
                INSERT INTO profiles (id, role, first_name, last_name, flowcoins_balance, pin_code)
                VALUES (gen_random_uuid(), 'kid', sn, '', 0, lpad(floor(random()*90000 + 10000)::text, 5, '0'))
                RETURNING id
            )
            INSERT INTO enrollments (course_id, kid_id) SELECT courseid, id FROM newkid;
        END IF;
    END LOOP;


    -- 6. REMOVE ALL UNWANTED KIDS FROM THIS COURSE ONLY
    -- This uses the specific sara_id and kubaf_id we fetched earlier so we don't accidentally remove them!
    FOR kid IN (
        SELECT p.id 
        FROM profiles p
        JOIN enrollments e ON e.kid_id = p.id
        WHERE e.course_id = courseid 
          AND p.id != sara_id
          AND p.id != kubaf_id
          AND p.first_name NOT IN (
            'Vojta', 'Matěj', 'Kryštof', 'Jakub', 'Samuel', 'Patrik', 'Dan', 'Filip', 'Štefan', 'David', 'Tadeáš', 'Prokop', 'Edward'
        )
    ) LOOP
        -- Remove from this specific course
        DELETE FROM enrollments WHERE course_id = courseid AND kid_id = kid.id;
        
        -- Delete the underlying profile entirely ONLY if they aren't enrolled in any other courses
        DELETE FROM profiles WHERE id = kid.id AND id NOT IN (SELECT kid_id FROM enrollments);
    END LOOP;

END $$;
