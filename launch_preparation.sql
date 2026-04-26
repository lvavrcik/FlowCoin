-- ==========================================
-- FlowCoins Launch Preparation Script (Updated)
-- ==========================================

-- 1. CLEAR ALL COMPLETED SKILLS (Dovednosti)
-- This removes any finished skills for all kids, so they can be marked manually by coaches.
DELETE FROM kid_skills;

-- 2. CLEAR ALL TRANSACTIONS AND PURCHASES HISTORY
-- Since we are going live and starting fresh, we should also clear the history 
-- of past test purchases and transactions so the timeline is clean.
DELETE FROM purchases;
DELETE FROM transactions;

-- 3. RESET EVERY KID'S BALANCE TO 0
-- Ensures that every kid starts with exactly 0 FlowCoins.
UPDATE profiles
SET flowcoins_balance = 0
WHERE role = 'kid';

-- 4. DELETE DUPLICATE ENROLLMENTS
-- Ensures a kid is only mathematically enrolled in a specific course once.
-- This does NOT look at names, it only ensures the same database profile doesn't show up twice in the same course.
DELETE FROM enrollments
WHERE id IN (
  SELECT id FROM (
    SELECT id, ROW_NUMBER() OVER(PARTITION BY course_id, kid_id ORDER BY created_at ASC) as rnum
    FROM enrollments
  ) t
  WHERE t.rnum > 1
);
