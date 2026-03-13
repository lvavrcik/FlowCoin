-- FlowCoins Test Data Seed Script
-- Run this in your Supabase SQL Editor to instantly populate the app!

-- 1. Setup a Test Season
INSERT INTO public.seasons (id, name, is_active)
VALUES ('11111111-1111-1111-1111-111111111111', 'Spring 2024 (Test)', true)
ON CONFLICT (id) DO NOTHING;

-- 2. Create Profiles: Coaches & Kids
-- Coach: Lukáš
INSERT INTO public.profiles (id, role, first_name, last_name, flowcoins_balance)
VALUES ('22222222-2222-2222-2222-222222222221', 'coach', 'Lukáš', 'Coach', 0)
ON CONFLICT (id) DO NOTHING;

-- Coach: Standa
INSERT INTO public.profiles (id, role, first_name, last_name, flowcoins_balance)
VALUES ('22222222-2222-2222-2222-222222222222', 'coach', 'Standa', 'Coach', 0)
ON CONFLICT (id) DO NOTHING;

-- Coach: Verča
INSERT INTO public.profiles (id, role, first_name, last_name, flowcoins_balance)
VALUES ('22222222-2222-2222-2222-222222222223', 'coach', 'Verča', 'Coach', 0)
ON CONFLICT (id) DO NOTHING;

-- Kid 1: Tereza (PIN: 1111)
INSERT INTO public.profiles (id, role, first_name, last_name, flowcoins_balance, pin_code)
VALUES ('33333333-3333-3333-3333-333333333331', 'kid', 'Tereza', 'Rider', 50, '1111')
ON CONFLICT (id) DO NOTHING;

-- Kid 2: Matyáš (PIN: 2222)
INSERT INTO public.profiles (id, role, first_name, last_name, flowcoins_balance, pin_code)
VALUES ('33333333-3333-3333-3333-333333333332', 'kid', 'Matyáš', 'Rider', 50, '2222')
ON CONFLICT (id) DO NOTHING;

-- Kid 3: Jakub (PIN: 3333)
INSERT INTO public.profiles (id, role, first_name, last_name, flowcoins_balance, pin_code)
VALUES ('33333333-3333-3333-3333-333333333333', 'kid', 'Jakub', 'Rider', 50, '3333')
ON CONFLICT (id) DO NOTHING;


-- 3. Create the Course (Jedovnice PreFlow/Flow - Monday)
INSERT INTO public.courses (id, name, season_id)
VALUES (
  '44444444-4444-4444-4444-444444444441', 
  'Jedovnice PreFlow/Flow (Monday)', 
  '11111111-1111-1111-1111-111111111111'  -- Season ID
)
ON CONFLICT (id) DO NOTHING;

-- Assign Coaches to the Course
-- Coach Lukáš
INSERT INTO public.course_coaches (course_id, coach_id)
VALUES (
  '44444444-4444-4444-4444-444444444441',
  '22222222-2222-2222-2222-222222222221'
)
ON CONFLICT DO NOTHING;

-- Coach Standa
INSERT INTO public.course_coaches (course_id, coach_id)
VALUES (
  '44444444-4444-4444-4444-444444444441',
  '22222222-2222-2222-2222-222222222222'
)
ON CONFLICT DO NOTHING;


-- 4. Enroll the Kids in Monday's Course
-- Enroll Tereza
INSERT INTO public.enrollments (course_id, kid_id)
VALUES (
  '44444444-4444-4444-4444-444444444441', -- Monday Course
  '33333333-3333-3333-3333-333333333331'  -- Tereza
)
ON CONFLICT (course_id, kid_id) DO NOTHING;

-- Enroll Matyáš
INSERT INTO public.enrollments (course_id, kid_id)
VALUES (
  '44444444-4444-4444-4444-444444444441', -- Monday Course
  '33333333-3333-3333-3333-333333333332'  -- Matyáš
)
ON CONFLICT (course_id, kid_id) DO NOTHING;


-- 5. Set up some Default Activities for the Coach Action Panel
INSERT INTO public.activities (id, name, default_coins) VALUES
  (uuid_generate_v4(), 'Attendance & Active Riding', 10),
  (uuid_generate_v4(), 'Helping a teammate', 5),
  (uuid_generate_v4(), 'Winning the minigame', 15),
  (uuid_generate_v4(), 'Bad behavior / Swearing', -5);

-- 6. Set up some Merch for the Shop
INSERT INTO public.merch_items (id, name, cost, stock, image_url) VALUES
  (uuid_generate_v4(), 'FlowCoins Sticker', 20, 100, 'https://images.unsplash.com/photo-1572379374088-7254593e9701?w=400&h=400&fit=crop'),
  (uuid_generate_v4(), 'Bike Water Bottle', 150, 20, 'https://images.unsplash.com/photo-1601001815964-ce84b810d7ce?w=400&h=400&fit=crop'),
  (uuid_generate_v4(), 'Official Jersey', 500, 5, 'https://images.unsplash.com/photo-1555513511-645ca2b9f30e?w=400&h=400&fit=crop');
