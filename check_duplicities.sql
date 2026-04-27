-- ==========================================
-- Check for Duplicities
-- ==========================================

-- CHECK 1: Identical database profiles enrolled multiple times in the same course
-- If this returns rows, it means the exact same kid account is mathematically linked to the course twice.
SELECT 
    c.name as course_name, 
    p.first_name, 
    p.last_name, 
    COUNT(e.id) as number_of_enrollments,
    'Duplicate Enrollment' as issue_type
FROM enrollments e
JOIN profiles p ON p.id = e.kid_id
JOIN courses c ON c.id = e.course_id
GROUP BY c.name, p.first_name, p.last_name, p.id
HAVING COUNT(e.id) > 1;

-- CHECK 2: Different database profiles with the EXACT same name in the same course
-- If this returns rows, it means two completely separate accounts with the same name were added to the course.
SELECT 
    c.name as course_name, 
    p.first_name, 
    p.last_name,
    COUNT(p.id) as occurrences,
    array_agg(p.pin_code) as pins,
    'Different Profiles with Same Name' as issue_type
FROM enrollments e
JOIN profiles p ON p.id = e.kid_id
JOIN courses c ON c.id = e.course_id
GROUP BY c.name, p.first_name, p.last_name
HAVING COUNT(p.id) > 1;
