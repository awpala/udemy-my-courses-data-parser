-- Create schema

CREATE SCHEMA Student;

-- Create entities tables

CREATE TABLE Student.List (
  id INT PRIMARY KEY,
  title VARCHAR(255),
  description TEXT
);

CREATE TABLE Student.Course (
  id INT PRIMARY KEY,
  title VARCHAR(255),
  url TEXT,
  is_paid BOOLEAN,
  image_240x135 TEXT,
  is_practice_test_course BOOLEAN,
  image_480x270 TEXT,
  published_title VARCHAR(255),
  tracking_id VARCHAR(255),
  headline TEXT,
  num_subscribers INT,
  avg_rating FLOAT,
  num_reviews INT,
  favorite_time TIMESTAMP,
  archive_time TIMESTAMP,
  completion_ratio FLOAT,
  num_quizzes INT,
  num_lectures INT,
  is_private BOOLEAN,
  status_label VARCHAR(255),
  created TIMESTAMP,
  estimated_content_length INT,
  buyable_object_type VARCHAR(255),
  last_accessed_time TIMESTAMP,
  enrollment_time TIMESTAMP,
  last_update_date DATE,
  is_published BOOLEAN
);

CREATE TABLE Student.Instructor (
  id INT PRIMARY KEY,
  name VARCHAR(255),
  display_name VARCHAR(255),
  job_title VARCHAR(255),
  image_50x50 TEXT,
  image_100x100 TEXT,
  initials VARCHAR(10),
  url TEXT
);

CREATE TABLE Student.Category (
  id INT PRIMARY KEY,
  title VARCHAR(255),
  title_cleaned VARCHAR(255),
  url TEXT,
  icon_class VARCHAR(255)
);

CREATE TABLE Student.Subcategory (
  id INT PRIMARY KEY,
  title VARCHAR(255),
  title_cleaned VARCHAR(255),
  url TEXT,
  icon_class VARCHAR(255)
);

CREATE TABLE Student.Topic (
  id INT PRIMARY KEY,
  title VARCHAR(255),
  url TEXT
);

-- Create joins tables

CREATE TABLE Student.Course_List (
  course_id INT REFERENCES Student.Course(id),
  list_id INT REFERENCES Student.List(id),
  PRIMARY KEY (course_id, list_id)
);

CREATE TABLE Student.Course_Instructor (
  course_id INT REFERENCES Student.Course(id),
  instructor_id INT REFERENCES Student.Instructor(id),
  PRIMARY KEY (course_id, instructor_id)
);

CREATE TABLE Student.Course_Category (
  course_id INT REFERENCES Student.Course(id),
  category_id INT REFERENCES Student.Category(id),
  PRIMARY KEY (course_id, category_id)
);

CREATE TABLE Student.Course_Subcategory (
  course_id INT REFERENCES Student.Course(id),
  subcategory_id INT REFERENCES Student.Subcategory(id),
  PRIMARY KEY (course_id, subcategory_id)
);

CREATE TABLE Student.Course_Topic (
  course_id INT REFERENCES Student.Course(id),
  topic_id INT REFERENCES Student.Topic(id),
  PRIMARY KEY (course_id, topic_id)
);
