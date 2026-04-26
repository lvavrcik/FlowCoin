-- ==========================================
-- Final Post-Test Reset Script
-- ==========================================

-- 1. CLEAR TRANSACTIONS AND PURCHASES
-- This deletes all the dummy activities (like Vyrušování/Účast) you just tested with Tomáš
DELETE FROM purchases;
DELETE FROM transactions;

-- 2. CLEAR COMPLETED SKILLS
-- This resets all skills back to an uncompleted state for everyone, including Tomáš.
DELETE FROM kid_skills;

-- 3. RESET BALANCES
-- Sets Tomáš (and ensures all other kids) start exactly at 0 FlowCoins.
UPDATE profiles
SET flowcoins_balance = 0
WHERE role = 'kid';
