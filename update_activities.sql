-- ==========================================
-- Update General Actions (Activities)
-- ==========================================

-- 1. DELETE EXISTING ACTIONS
-- Because we cleared the transactions history earlier, we can safely delete the old dummy activities without any foreign key errors!
DELETE FROM activities;

-- 2. INSERT NEW ACTIONS
-- Insert the specific activities you requested for the Action Panel modal
INSERT INTO activities (name, default_coins)
VALUES 
  ('Účast', 5),
  ('Pomoc kamarádovi', 5),
  ('Výhra hry/výzvy', 5),
  ('Vyrušování', -5),
  ('Nadávání', -5);
