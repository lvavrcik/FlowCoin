-- ==========================================
-- Bruteforce Roster Fix for 'Brno Freestyle Academy (Úterý)'
-- ==========================================
-- This script guarantees the final roster exactly matches your requested 14 kids.
-- It resolves the missing last initials (caused by the global surname wipe yesterday),
-- handles exact duplicates, creates any missing children, and deletes any outliers.

DO $$ 
DECLARE
    courseid UUID;
    kid RECORD;
    t_count INT := 1;
    k_count INT := 1;
    desired_tomas TEXT[] := ARRAY['K.', 'H.', 'M.', 'P.'];
    desired_kuba TEXT[] := ARRAY['F.', 'S.'];
    single_names TEXT[] := ARRAY['Jirka', 'Masťa', 'Kiki', 'Jonáš', 'František', 'Dominik', 'David', 'Sára'];
    sn TEXT;
    sn_count INT;
BEGIN
    -- 1. Identify the Brno Course
    SELECT id INTO courseid FROM courses WHERE name = 'Brno Freestyle Academy (Úterý)' LIMIT 1;
    IF courseid IS NULL THEN
        RAISE NOTICE 'Course not found.';
        RETURN;
    END IF;

    -- 2. Clear known collided last names inside this course to start fresh
    UPDATE profiles 
    SET last_name = '' 
    WHERE id IN (SELECT kid_id FROM enrollments WHERE course_id = courseid)
      AND first_name IN ('Tomáš', 'Kuba');

    -- 3. RESOLVE "Tomáš" Collisions (Target: exactly 4)
    FOR kid IN (
        SELECT p.id 
        FROM profiles p
        JOIN enrollments e ON e.kid_id = p.id
        WHERE e.course_id = courseid AND p.first_name = 'Tomáš'
        ORDER BY p.created_at ASC
    ) LOOP
        IF t_count <= 4 THEN
            -- Assign the letter (K., H., M., P.)
            UPDATE profiles SET last_name = desired_tomas[t_count] WHERE id = kid.id;
            t_count := t_count + 1;
        ELSE
            -- Delete any extra Tomáš profiles that exceed 4
            DELETE FROM kid_skills WHERE kid_id = kid.id;
            DELETE FROM enrollments WHERE kid_id = kid.id;
            DELETE FROM profiles WHERE id = kid.id;
        END IF;
    END LOOP;

    -- If there were less than 4, dynamically create the missing ones!
    WHILE t_count <= 4 LOOP
        WITH newkid AS (
            INSERT INTO profiles (id, role, first_name, last_name, flowcoins_balance, pin_code)
            VALUES (gen_random_uuid(), 'kid', 'Tomáš', desired_tomas[t_count], 0, lpad(floor(random()*90000 + 10000)::text, 5, '0'))
            RETURNING id
        )
        INSERT INTO enrollments (course_id, kid_id) SELECT courseid, id FROM newkid;
        t_count := t_count + 1;
    END LOOP;

    -- 4. RESOLVE "Kuba" (Target: exactly 2)
    FOR kid IN (
        SELECT p.id 
        FROM profiles p
        JOIN enrollments e ON e.kid_id = p.id
        WHERE e.course_id = courseid AND p.first_name = 'Kuba'
        ORDER BY p.created_at ASC
    ) LOOP
        IF k_count <= 2 THEN
            UPDATE profiles SET last_name = desired_kuba[k_count] WHERE id = kid.id;
            k_count := k_count + 1;
        ELSE
            DELETE FROM kid_skills WHERE kid_id = kid.id;
            DELETE FROM enrollments WHERE kid_id = kid.id;
            DELETE FROM profiles WHERE id = kid.id;
        END IF;
    END LOOP;

    WHILE k_count <= 2 LOOP
        WITH newkid AS (
            INSERT INTO profiles (id, role, first_name, last_name, flowcoins_balance, pin_code)
            VALUES (gen_random_uuid(), 'kid', 'Kuba', desired_kuba[k_count], 0, lpad(floor(random()*90000 + 10000)::text, 5, '0'))
            RETURNING id
        )
        INSERT INTO enrollments (course_id, kid_id) SELECT courseid, id FROM newkid;
        k_count := k_count + 1;
    END LOOP;

    -- 5. RESOLVE STRICT SINGLES (Only exactly 1 of each allowed)
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
                -- Reset any stray last name to empty (as desired globally)
                UPDATE profiles SET last_name = '' WHERE id = kid.id;
                sn_count := sn_count + 1;
            ELSE
                -- Cleanly delete duplicate
                DELETE FROM kid_skills WHERE kid_id = kid.id;
                DELETE FROM enrollments WHERE kid_id = kid.id;
                DELETE FROM profiles WHERE id = kid.id;
            END IF;
        END LOOP;

        IF sn_count = 1 THEN
            -- Child is missing entirely, create them!
            WITH newkid AS (
                INSERT INTO profiles (id, role, first_name, last_name, flowcoins_balance, pin_code)
                VALUES (gen_random_uuid(), 'kid', sn, '', 0, lpad(floor(random()*90000 + 10000)::text, 5, '0'))
                RETURNING id
            )
            INSERT INTO enrollments (course_id, kid_id) SELECT courseid, id FROM newkid;
        END IF;
    END LOOP;

    -- 6. REMOVE ALL UNWANTED KIDS FROM THIS COURSE
    -- If they don't match the final list, remove them from the course.
    FOR kid IN (
        SELECT p.id 
        FROM profiles p
        JOIN enrollments e ON e.kid_id = p.id
        WHERE e.course_id = courseid AND p.first_name NOT IN (
            'Jirka', 'Masťa', 'Kiki', 'Jonáš', 'František', 'Dominik', 'David', 'Sára', 'Tomáš', 'Kuba'
        )
    ) LOOP
        -- Remove enrollment
        DELETE FROM enrollments WHERE course_id = courseid AND kid_id = kid.id;
        
        -- Delete profile if orphaned
        -- Doing it dynamically using a subquery to see if they belong to any other courses
        DELETE FROM profiles WHERE id = kid.id AND id NOT IN (SELECT kid_id FROM enrollments);
    END LOOP;

END $$;
