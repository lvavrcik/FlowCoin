-- 1. Create Coach Verča
INSERT INTO public.profiles (id, role, first_name, last_name, flowcoins_balance)
VALUES ('22222222-2222-2222-2222-222222222223', 'coach', 'Verča', 'Coach', 0)
ON CONFLICT (id) DO NOTHING;

-- 2. Create Kid Jakub (PIN: 3333)
INSERT INTO public.profiles (id, role, first_name, last_name, flowcoins_balance, pin_code)
VALUES ('33333333-3333-3333-3333-333333333333', 'kid', 'Jakub', 'Rider', 50, '3333')
ON CONFLICT (id) DO NOTHING;

-- 3. Create Thursday Course
INSERT INTO public.courses (id, name, season_id)
VALUES (
  '44444444-4444-4444-4444-444444444442', 
  'Marianske PreFlow/Flow (Thursday)', 
  '11111111-1111-1111-1111-111111111111'  -- Existing Season ID
)
ON CONFLICT (id) DO NOTHING;

-- 4. Assign Coach Verča to Thursday Course
INSERT INTO public.course_coaches (course_id, coach_id)
VALUES (
  '44444444-4444-4444-4444-444444444442',  -- Thursday Course
  '22222222-2222-2222-2222-222222222223'  -- Verča
)
ON CONFLICT DO NOTHING;

-- 5. Enroll Jakub in Thursday Course
INSERT INTO public.enrollments (course_id, kid_id)
VALUES (
  '44444444-4444-4444-4444-444444444442', -- Thursday Course
  '33333333-3333-3333-3333-333333333333'  -- Jakub
)
ON CONFLICT (course_id, kid_id) DO NOTHING;
