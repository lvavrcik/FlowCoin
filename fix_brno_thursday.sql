-- ==========================================
-- Bruteforce Roster Fix for 'Brno Freestyle Academy (Čtvrtek)'
-- ==========================================
-- This script strictly enforces the roster of 8 kids provided.
-- It ensures exactly two "Filip"s exist (with no last names) 
-- and exactly one of all the others, physically cleaning any extras or strays.

DO $$ 
DECLARE
    courseid UUID;
    kid RECORD;
    f_count INT := 1;
    single_names TEXT[] := ARRAY['Petr', 'Daniel', 'Kuba', 'Pavel', 'Olda', 'Martin'];
    sn TEXT;
    sn_count INT;
BEGIN
    -- 1. Identify the Thursday Course
    SELECT id INTO courseid FROM courses WHERE name = 'Brno Freestyle Academy (Čtvrtek)' LIMIT 1;
    IF courseid IS NULL THEN
        RAISE NOTICE 'Course not found.';
        RETURN;
    END IF;

    -- 2. Clear known collided last names inside this course to start fresh for Filip
    UPDATE profiles 
    SET last_name = '' 
    WHERE id IN (SELECT kid_id FROM enrollments WHERE course_id = courseid)
      AND first_name = 'Filip';

    -- 3. RESOLVE "Filip" (Target: exactly 2, no last names needed)
    FOR kid IN (
        SELECT p.id 
        FROM profiles p
        JOIN enrollments e ON e.kid_id = p.id
        WHERE e.course_id = courseid AND p.first_name = 'Filip'
        ORDER BY p.created_at ASC
    ) LOOP
        IF f_count <= 2 THEN
            -- Ensure last name is empty
            UPDATE profiles SET last_name = '' WHERE id = kid.id;
            f_count := f_count + 1;
        ELSE
            -- Delete any extra Filip profiles
            DELETE FROM kid_skills WHERE kid_id = kid.id;
            DELETE FROM enrollments WHERE kid_id = kid.id;
            DELETE FROM profiles WHERE id = kid.id;
        END IF;
    END LOOP;

    WHILE f_count <= 2 LOOP
        WITH newkid AS (
            INSERT INTO profiles (id, role, first_name, last_name, flowcoins_balance, pin_code)
            VALUES (gen_random_uuid(), 'kid', 'Filip', '', 0, lpad(floor(random()*90000 + 10000)::text, 5, '0'))
            RETURNING id
        )
        INSERT INTO enrollments (course_id, kid_id) SELECT courseid, id FROM newkid;
        f_count := f_count + 1;
    END LOOP;

    -- 4. RESOLVE STRICT SINGLES (exactly 1 of each)
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
                -- Reset any stray last name to empty
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

    -- 5. REMOVE ALL UNWANTED KIDS FROM THIS COURSE
    FOR kid IN (
        SELECT p.id 
        FROM profiles p
        JOIN enrollments e ON e.kid_id = p.id
        WHERE e.course_id = courseid AND p.first_name NOT IN (
            'Petr', 'Daniel', 'Kuba', 'Pavel', 'Olda', 'Martin', 'Filip'
        )
    ) LOOP
        DELETE FROM enrollments WHERE course_id = courseid AND kid_id = kid.id;
        DELETE FROM profiles WHERE id = kid.id AND id NOT IN (SELECT kid_id FROM enrollments);
    END LOOP;

END $$;
