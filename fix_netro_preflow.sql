-- ==========================================
-- Bruteforce Roster Fix for 'Netro PreFlow (Úterý)'
-- ==========================================
-- This script guarantees the final roster exactly matches your requested 14 kids,
-- resolving missing initials for the two Richards, keeping both Edas intact,
-- and removing any accidental duplicities or incorrectly assigned kids.

DO $$ 
DECLARE
    courseid UUID;
    kid RECORD;
    r_count INT := 1;
    e_count INT := 1;
    desired_richard TEXT[] := ARRAY['M.', 'T.'];
    single_names TEXT[] := ARRAY['Samuel', 'Jirka', 'Eduard', 'Tigran', 'Theodor', 'Vilém', 'Vašek', 'Teo', 'Ragnar', 'Matěj'];
    sn TEXT;
    sn_count INT;
BEGIN
    -- 1. Identify the Netro PreFlow Course
    SELECT id INTO courseid FROM courses WHERE name = 'Netro PreFlow (Úterý)' LIMIT 1;
    IF courseid IS NULL THEN
        RAISE NOTICE 'Course not found.';
        RETURN;
    END IF;

    -- 2. Clear known collided last names inside this course to start fresh
    UPDATE profiles 
    SET last_name = '' 
    WHERE id IN (SELECT kid_id FROM enrollments WHERE course_id = courseid)
      AND first_name IN ('Richard');

    -- 3. RESOLVE "Richard" Collisions (Target: exactly 2 - 'M.' and 'T.')
    FOR kid IN (
        SELECT p.id 
        FROM profiles p
        JOIN enrollments e ON e.kid_id = p.id
        WHERE e.course_id = courseid AND p.first_name = 'Richard'
        ORDER BY p.created_at ASC
    ) LOOP
        IF r_count <= 2 THEN
            -- Assign the letter (M. or T.)
            UPDATE profiles SET last_name = desired_richard[r_count] WHERE id = kid.id;
            r_count := r_count + 1;
        ELSE
            -- Delete any extra Richard profiles that exceed 2
            DELETE FROM kid_skills WHERE kid_id = kid.id;
            DELETE FROM enrollments WHERE kid_id = kid.id;
            DELETE FROM profiles WHERE id = kid.id;
        END IF;
    END LOOP;

    WHILE r_count <= 2 LOOP
        WITH newkid AS (
            INSERT INTO profiles (id, role, first_name, last_name, flowcoins_balance, pin_code)
            VALUES (gen_random_uuid(), 'kid', 'Richard', desired_richard[r_count], 0, lpad(floor(random()*90000 + 10000)::text, 5, '0'))
            RETURNING id
        )
        INSERT INTO enrollments (course_id, kid_id) SELECT courseid, id FROM newkid;
        r_count := r_count + 1;
    END LOOP;

    -- 4. RESOLVE "Eda" (Target: exactly 2, no last names needed)
    FOR kid IN (
        SELECT p.id 
        FROM profiles p
        JOIN enrollments e ON e.kid_id = p.id
        WHERE e.course_id = courseid AND p.first_name = 'Eda'
        ORDER BY p.created_at ASC
    ) LOOP
        IF e_count <= 2 THEN
            -- Ensure last name is empty
            UPDATE profiles SET last_name = '' WHERE id = kid.id;
            e_count := e_count + 1;
        ELSE
            DELETE FROM kid_skills WHERE kid_id = kid.id;
            DELETE FROM enrollments WHERE kid_id = kid.id;
            DELETE FROM profiles WHERE id = kid.id;
        END IF;
    END LOOP;

    WHILE e_count <= 2 LOOP
        WITH newkid AS (
            INSERT INTO profiles (id, role, first_name, last_name, flowcoins_balance, pin_code)
            VALUES (gen_random_uuid(), 'kid', 'Eda', '', 0, lpad(floor(random()*90000 + 10000)::text, 5, '0'))
            RETURNING id
        )
        INSERT INTO enrollments (course_id, kid_id) SELECT courseid, id FROM newkid;
        e_count := e_count + 1;
    END LOOP;

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
    FOR kid IN (
        SELECT p.id 
        FROM profiles p
        JOIN enrollments e ON e.kid_id = p.id
        WHERE e.course_id = courseid AND p.first_name NOT IN (
            'Samuel', 'Jirka', 'Eduard', 'Tigran', 'Theodor', 'Vilém', 'Vašek', 'Teo', 'Ragnar', 'Matěj', 'Richard', 'Eda'
        )
    ) LOOP
        DELETE FROM enrollments WHERE course_id = courseid AND kid_id = kid.id;
        DELETE FROM profiles WHERE id = kid.id AND id NOT IN (SELECT kid_id FROM enrollments);
    END LOOP;

END $$;
