DO $$
DECLARE
    v_kid_id UUID;
    v_course_id UUID;
    v_activity_id UUID;
    v_transaction_id UUID;
BEGIN
    -- 1. Find the course
    SELECT id INTO v_course_id FROM courses WHERE name = 'Jedovnice PreFlow/Flow (Pondělí)' LIMIT 1;
    
    -- 2. Find the kid Natálie in that course
    SELECT p.id INTO v_kid_id 
    FROM profiles p
    JOIN enrollments e ON e.kid_id = p.id
    WHERE p.first_name = 'Natálie' AND e.course_id = v_course_id
    LIMIT 1;

    -- 3. Find the activity ID for "Účast" (attendance)
    SELECT id INTO v_activity_id FROM activities WHERE name = 'Účast' LIMIT 1;

    -- 4. Find the latest 5 coin transaction for this kid and activity
    SELECT id INTO v_transaction_id
    FROM transactions
    WHERE kid_id = v_kid_id AND activity_id = v_activity_id AND amount = 5
    ORDER BY created_at DESC
    LIMIT 1;

    -- 5. Delete the transaction and update balance if found
    IF v_transaction_id IS NOT NULL THEN
        DELETE FROM transactions WHERE id = v_transaction_id;
        
        -- Also deduct 5 from her profile since we don't have an ON DELETE trigger
        UPDATE profiles
        SET flowcoins_balance = flowcoins_balance - 5
        WHERE id = v_kid_id;
    END IF;
END $$;
