-- Create List Table
CREATE TABLE List (
  id INT PRIMARY KEY,
  title VARCHAR(255),
  description TEXT
);

-- Create Course Table
CREATE TABLE Course (
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

-- Create Instructor Table
CREATE TABLE Instructor (
  id INT PRIMARY KEY,
  name VARCHAR(255),
  display_name VARCHAR(255),
  job_title VARCHAR(255),
  image_50x50 TEXT,
  image_100x100 TEXT,
  initials VARCHAR(10),
  url TEXT
);

-- Create Category Table
CREATE TABLE Category (
  id INT PRIMARY KEY,
  title VARCHAR(255),
  title_cleaned VARCHAR(255),
  url TEXT,
  icon_class VARCHAR(255)
);

-- Create Subcategory Table
CREATE TABLE Subcategory (
  id INT PRIMARY KEY,
  title VARCHAR(255),
  title_cleaned VARCHAR(255),
  url TEXT,
  icon_class VARCHAR(255)
);

-- Create Topic Table
CREATE TABLE Topic (
  id INT PRIMARY KEY,
  title VARCHAR(255),
  url TEXT
);

-- Create Course_List Relationship Table
CREATE TABLE Course_List (
  course_id INT REFERENCES Course(id),
  list_id INT REFERENCES List(id),
  PRIMARY KEY (course_id, list_id)
);

-- Create Course_Instructor Relationship Table
CREATE TABLE Course_Instructor (
  course_id INT REFERENCES Course(id),
  instructor_id INT REFERENCES Instructor(id),
  PRIMARY KEY (course_id, instructor_id)
);

-- Create Course_Category Relationship Table
CREATE TABLE Course_Category (
  course_id INT REFERENCES Course(id),
  category_id INT REFERENCES Category(id),
  PRIMARY KEY (course_id, category_id)
);

-- Create Course-Subcategory Relationship
CREATE TABLE Course_Subcategory (
  course_id INT REFERENCES Course(id),
  subcategory_id INT REFERENCES Subcategory(id),
  PRIMARY KEY (course_id, subcategory_id)
);

-- Create Course-Topic Relationship
CREATE TABLE Course_Topic (
  course_id INT REFERENCES Course(id),
  topic_id INT REFERENCES Topic(id),
  PRIMARY KEY (course_id, topic_id)
);
