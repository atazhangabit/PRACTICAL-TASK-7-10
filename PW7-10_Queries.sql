-- =====================================================================
-- Practical Work 7-10: SQL Queries and JOIN
-- University Educational Process database (from Practical Works 1-2)
-- Environment: SQLite (DB Browser for SQLite / SQLiteStudio)
-- How to run: open university.db and run the queries below,
--             (tables and data are already inside university.db)
-- =====================================================================


-- =====================================================================
-- PART 2. Introduction to SQL (Topic 8)
-- =====================================================================

-- 2.1 All records from the Students table
SELECT * FROM Students;

-- 2.2 Only student IDs, first names and last names
SELECT student_id, first_name, last_name
FROM Students;

-- 2.3 All records from the Groups table
SELECT * FROM Groups;

-- 2.4 Names of all subjects (our table is Courses)
SELECT course_name
FROM Courses;

-- =====================================================================
-- PART 3. SQL queries and aggregate functions (Topic 9)
-- =====================================================================

-- 3.1 Students of one group (WHERE) - group 21 = IS-23
SELECT *
FROM Students
WHERE group_id = 21;

-- 3.2 Students in alphabetical order (ORDER BY)
SELECT *
FROM Students
ORDER BY last_name ASC;

-- 3.3 Total number of students (COUNT)
SELECT COUNT(*) AS total_students
FROM Students;

-- 3.4 Number of students in each group (GROUP BY)
SELECT group_id, COUNT(*) AS student_count
FROM Students
GROUP BY group_id;

-- 3.5 Maximum grade (MAX)
SELECT MAX(grade_value) AS max_grade
FROM Grades;

-- 3.6 Minimum grade (MIN)
SELECT MIN(grade_value) AS min_grade
FROM Grades;

-- 3.7 Average grade (AVG)
SELECT ROUND(AVG(grade_value), 2) AS average_grade
FROM Grades;

-- =====================================================================
-- PART 4. Joining tables using JOIN (Topic 10)
-- =====================================================================

-- 4.1 Students with their group name (Students + Groups)
SELECT
    Students.student_id,
    Students.first_name,
    Students.last_name,
    Groups.group_name
FROM Students
INNER JOIN Groups
    ON Students.group_id = Groups.group_id
ORDER BY Groups.group_name, Students.last_name;

-- 4.2 Students and their grades (Students + Enrollments + Grades)
-- Grades are linked to Students through Enrollments
SELECT
    s.first_name,
    s.last_name,
    g.grade_value,
    g.grade_date
FROM Students s
INNER JOIN Enrollments e ON s.student_id = e.student_id
INNER JOIN Grades g      ON e.enrollment_id = g.enrollment_id
ORDER BY s.last_name, g.grade_date;

-- 4.3 Student names, subjects and grades (Students + Enrollments + Courses + Grades)
SELECT
    s.first_name,
    s.last_name,
    c.course_name,
    g.grade_value
FROM Students s
INNER JOIN Enrollments e ON s.student_id = e.student_id
INNER JOIN Courses c     ON e.course_id = c.course_id
INNER JOIN Grades g      ON e.enrollment_id = g.enrollment_id
ORDER BY s.last_name, c.course_name;

-- 4.4 INNER JOIN vs LEFT JOIN: enrollments with and without grades
SELECT
    e.enrollment_id,
    s.last_name,
    e.status,
    g.grade_value
FROM Enrollments e
INNER JOIN Students s ON e.student_id = s.student_id
LEFT JOIN Grades g    ON e.enrollment_id = g.enrollment_id
WHERE g.grade_id IS NULL;

-- 4.5 Row counts to compare JOIN results with the original tables
SELECT
    (SELECT COUNT(*) FROM Grades) AS grades_rows,
    (SELECT COUNT(*) FROM Enrollments) AS enrollment_rows,
    (SELECT COUNT(*) FROM Enrollments e INNER JOIN Grades g ON e.enrollment_id = g.enrollment_id) AS inner_join_rows,
    (SELECT COUNT(*) FROM Enrollments e LEFT JOIN Grades g ON e.enrollment_id = g.enrollment_id) AS left_join_rows;
