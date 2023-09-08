-- Truncate entity tables
TRUNCATE TABLE Udemy.List CASCADE;
TRUNCATE TABLE Udemy.Course CASCADE;
TRUNCATE TABLE Udemy.Instructor CASCADE;
TRUNCATE TABLE Udemy.Category CASCADE;
TRUNCATE TABLE Udemy.Subcategory CASCADE;
TRUNCATE TABLE Udemy.Topic CASCADE;

-- Truncate join tables
TRUNCATE TABLE Udemy.Course_Instructor CASCADE;
TRUNCATE TABLE Udemy.Course_Category CASCADE;
TRUNCATE TABLE Udemy.Course_Subcategory CASCADE;
TRUNCATE TABLE Udemy.Course_Topic CASCADE;
