-- Truncate entity tables
TRUNCATE TABLE Student.List CASCADE;
TRUNCATE TABLE Student.Course CASCADE;
TRUNCATE TABLE Student.Instructor CASCADE;
TRUNCATE TABLE Student.Category CASCADE;
TRUNCATE TABLE Student.Subcategory CASCADE;
TRUNCATE TABLE Student.Topic CASCADE;

-- Truncate join tables
TRUNCATE TABLE Student.Course_Instructor CASCADE;
TRUNCATE TABLE Student.Course_Category CASCADE;
TRUNCATE TABLE Student.Course_Subcategory CASCADE;
TRUNCATE TABLE Student.Course_Topic CASCADE;
