-- Create schema

CREATE SCHEMA Udemy;

-- Create entities tables

CREATE TABLE Udemy.List (
  id INT PRIMARY KEY,
  title VARCHAR(255),
  description TEXT
);

CREATE TABLE Udemy.Course (
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

CREATE TABLE Udemy.Instructor (
  id INT PRIMARY KEY,
  name VARCHAR(255),
  display_name VARCHAR(255),
  job_title VARCHAR(255),
  image_50x50 TEXT,
  image_100x100 TEXT,
  initials VARCHAR(10),
  url TEXT
);

CREATE TABLE Udemy.Category (
  id INT PRIMARY KEY,
  title VARCHAR(255),
  title_cleaned VARCHAR(255),
  url TEXT,
  icon_class VARCHAR(255)
);

CREATE TABLE Udemy.Subcategory (
  id INT PRIMARY KEY,
  title VARCHAR(255),
  title_cleaned VARCHAR(255),
  url TEXT,
  icon_class VARCHAR(255)
);

CREATE TABLE Udemy.Topic (
  id INT PRIMARY KEY,
  title VARCHAR(255),
  url TEXT
);

-- Create joins tables

CREATE TABLE Udemy.Course_List (
  course_id INT REFERENCES Udemy.Course(id),
  list_id INT REFERENCES Udemy.List(id),
  PRIMARY KEY (course_id, list_id)
);

CREATE TABLE Udemy.Course_Instructor (
  course_id INT REFERENCES Udemy.Course(id),
  instructor_id INT REFERENCES Udemy.Instructor(id),
  PRIMARY KEY (course_id, instructor_id)
);

CREATE TABLE Udemy.Course_Category (
  course_id INT REFERENCES Udemy.Course(id),
  category_id INT REFERENCES Udemy.Category(id),
  PRIMARY KEY (course_id, category_id)
);

CREATE TABLE Udemy.Course_Subcategory (
  course_id INT REFERENCES Udemy.Course(id),
  subcategory_id INT REFERENCES Udemy.Subcategory(id),
  PRIMARY KEY (course_id, subcategory_id)
);

CREATE TABLE Udemy.Course_Topic (
  course_id INT REFERENCES Udemy.Course(id),
  topic_id INT REFERENCES Udemy.Topic(id),
  PRIMARY KEY (course_id, topic_id)
);
