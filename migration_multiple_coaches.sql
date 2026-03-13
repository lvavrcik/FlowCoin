-- Migration Script: Multiple Coaches per Course

-- 1. Create the new mapping table
CREATE TABLE IF NOT EXISTS public.course_coaches (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    course_id UUID REFERENCES public.courses(id) ON DELETE CASCADE NOT NULL,
    coach_id UUID REFERENCES public.profiles(id) ON DELETE CASCADE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(course_id, coach_id) -- Prevent duplicate assignments
);

-- 2. Migrate existing data
-- We need to move the current coach_id from courses into the new mapping table
INSERT INTO public.course_coaches (course_id, coach_id)
SELECT id, coach_id FROM public.courses
WHERE coach_id IS NOT NULL
ON CONFLICT DO NOTHING;

-- 3. Now we can safely remove the old coach_id column from the courses table
ALTER TABLE public.courses DROP COLUMN coach_id;

-- 4. Add Coach Standa (since he's new!)
INSERT INTO public.profiles (id, role, first_name, last_name, flowcoins_balance)
VALUES ('22222222-2222-2222-2222-222222222222', 'coach', 'Standa', 'Coach', 0)
ON CONFLICT (id) DO NOTHING;

-- 5. Assign both Lukáš AND Standa to the Monday course
-- Assuming the Monday course has ID '44444444-4444-4444-4444-444444444441' from our seed
INSERT INTO public.course_coaches (course_id, coach_id)
VALUES 
  ('44444444-4444-4444-4444-444444444441', '22222222-2222-2222-2222-222222222221'), -- Lukáš
  ('44444444-4444-4444-4444-444444444441', '22222222-2222-2222-2222-222222222222')  -- Standa (id ending in 2)
ON CONFLICT DO NOTHING;
