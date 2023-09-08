const fs = require('fs');

// Check if a JSON file path is provided as a command-line argument
if (process.argv.length !== 3) {
  console.error('Usage: node parse-json.js <json_file_path>');
  process.exit(1); // Exit with an error code
}

// Get the JSON file path from the command-line arguments
const jsonFile = process.argv[2];

// Generate a Unix timestamp as a suffix for the output SQL file
const timestamp = Math.floor(Date.now() / 1000); // Convert milliseconds to seconds

// Output SQL file with a timestamp suffix
const sqlFile = `seed_data_${timestamp}.sql`;

/**
 * Function to escape single quotes in `<entries>` intended for
 * SQL `INSERT <columns> VALUES <entries>` statements.
 * @param {*} value input value
 * @returns `'null'` or single-quoted string
 */
const escapeQuotes = (value) => {
  if (value === null || value === undefined) {
    return 'null'; // Return 'null' for null or undefined values
  }
  return `'${value.replace(/'/g, "''")}'`;
}

// Load JSON data from the file
fs.readFile(jsonFile, 'utf8', (err, data) => {
  if (err) {
    console.error('Error reading JSON file:', err);
    return;
  }

  const jsonData = JSON.parse(data);

  // Create sets to track unique primary IDs for each entity
  const courseIds = new Set();
  const instructorIds = new Set();
  const categoryIds = new Set();
  const subcategoryIds = new Set();
  const topicIds = new Set();

  // Create arrays to store SQL insert statements for entities and joins
  const entityInsertStatements = [];
  const joinInsertStatements = [];

  // Generate SQL insert statements for the "List" table
  jsonData.forEach((list) => {
    const listId = list.id;
    const listTitle = escapeQuotes(list.title);
    const listDescription = escapeQuotes(list.description);

    entityInsertStatements.push(`INSERT INTO Student.List (id, title, description) VALUES (${listId}, ${listTitle}, ${listDescription});`);

    // Generate SQL insert statements for the "Course" table and relationships
    list.courses.forEach((course) => {
      const courseId = course.id;

      // Generate SQL insert statement for the "Course_List" join table
      /* 
       * N.B. Perform this join insert BEFORE course id uniqueness check (which is used downstream
       * for entity `Course` and related joins Course_<...>), because in general 1 course : M lists
       */
      joinInsertStatements.push(`INSERT INTO Student.Course_List (course_id, list_id) VALUES (${courseId}, ${listId});`);

      // Ensure course id is unique
      if (courseIds.has(courseId)) {
        return; // Skip duplicate course
      }
      courseIds.add(courseId);

      const courseTitle = escapeQuotes(course.title);
      const courseUrl = escapeQuotes(course.url);
      const isPaid = course.is_paid;
      const image240x135 = escapeQuotes(course.image_240x135);
      const isPracticeTestCourse = course.is_practice_test_course;
      const image480x270 = escapeQuotes(course.image_480x270);
      const publishedTitle = escapeQuotes(course.published_title);
      const trackingId = escapeQuotes(course.tracking_id);
      const headline = escapeQuotes(course.headline);
      const numSubscribers = course.num_subscribers;
      const avgRating = course.avg_rating;
      const numReviews = course.num_reviews;
      const favoriteTime = escapeQuotes(course.favorite_time);
      const archiveTime = escapeQuotes(course.archive_time);
      const completionRatio = course.completion_ratio;
      const numQuizzes = course.num_quizzes;
      const numLectures = course.num_lectures;
      const isPrivate = course.is_private;
      const statusLabel = escapeQuotes(course.status_label);
      const created = escapeQuotes(course.created);
      const estimatedContentLength = course.estimated_content_length;
      const buyableObjectType = escapeQuotes(course.buyable_object_type);
      const lastAccessedTime = escapeQuotes(course.last_accessed_time);
      const enrollmentTime = escapeQuotes(course.enrollment_time);
      const lastUpdateDate = escapeQuotes(course.last_update_date);
      const isPublished = course.is_published;

      // Generate SQL insert statement for the "Course" entity
      entityInsertStatements.push(`INSERT INTO Student.Course (id, title, url, is_paid, image_240x135, is_practice_test_course, image_480x270, published_title, tracking_id, headline, num_subscribers, avg_rating, num_reviews, favorite_time, archive_time, completion_ratio, num_quizzes, num_lectures, is_private, status_label, created, estimated_content_length, buyable_object_type, last_accessed_time, enrollment_time, last_update_date, is_published) VALUES (${courseId}, ${courseTitle}, ${courseUrl}, ${isPaid}, ${image240x135}, ${isPracticeTestCourse}, ${image480x270}, ${publishedTitle}, ${trackingId}, ${headline}, ${numSubscribers}, ${avgRating}, ${numReviews}, ${favoriteTime}, ${archiveTime}, ${completionRatio}, ${numQuizzes}, ${numLectures}, ${isPrivate}, ${statusLabel}, ${created}, ${estimatedContentLength}, ${buyableObjectType}, ${lastAccessedTime}, ${enrollmentTime}, ${lastUpdateDate}, ${isPublished});`);

      // Generate SQL insert statements for the "Instructor" table and relationships
      course.visible_instructors.forEach((instructor) => {
        const instructorId = instructor.id;

        // Generate SQL insert statement for the "Course_Instructor" join table
        /* 
         * N.B. Perform this join insert BEFORE instructor id uniqueness check (which is used downstream
         * for entity `Instructor`), because in general 1 course : M instructors
         */
        joinInsertStatements.push(`INSERT INTO Student.Course_Instructor (course_id, instructor_id) VALUES (${courseId}, ${instructorId});`);

        // Ensure instructor id is unique
        if (instructorIds.has(instructorId)) {
          return; // Skip duplicate instructor
        }
        instructorIds.add(instructorId);

        const instructorName = escapeQuotes(instructor.name);
        const instructorDisplayName = escapeQuotes(instructor.display_name);
        const jobTitle = escapeQuotes(instructor.job_title);
        const image50x50 = escapeQuotes(instructor.image_50x50);
        const image100x100 = escapeQuotes(instructor.image_100x100);
        const initials = escapeQuotes(instructor.initials);
        const instructorUrl = escapeQuotes(instructor.url);

        // Generate SQL insert statement for the "Instructor" entity
        entityInsertStatements.push(`INSERT INTO Student.Instructor (id, name, display_name, job_title, image_50x50, image_100x100, initials, url) VALUES (${instructorId}, ${instructorName}, ${instructorDisplayName}, ${jobTitle}, ${image50x50}, ${image100x100}, ${initials}, ${instructorUrl});`);
      });

      // Generate SQL insert statements for the "Category" table and relationships
      const primaryCategory = course?.primary_category;
      const primarySubcategory = course?.primary_subcategory;

      const primaryCategoryId = primaryCategory?.id;
      const primarySubcategoryId = primarySubcategory?.id;

      if (primaryCategoryId) {
        joinInsertStatements.push(`INSERT INTO Student.Course_Category (course_id, category_id) VALUES (${courseId}, ${primaryCategoryId});`);
      }

      // Ensure category id is unique
      if (primaryCategory && primaryCategoryId && !categoryIds.has(primaryCategoryId)) {
        categoryIds.add(primaryCategoryId);

        // Generate SQL insert statements for the "Category" entity
        entityInsertStatements.push(`INSERT INTO Student.Category (id, title, title_cleaned, url, icon_class) VALUES (${primaryCategoryId}, ${escapeQuotes(primaryCategory.title)}, ${escapeQuotes(primaryCategory.title_cleaned)}, ${escapeQuotes(primaryCategory.url)}, ${escapeQuotes(primaryCategory.icon_class)});`);
      }

      if (primarySubcategoryId) {
        joinInsertStatements.push(`INSERT INTO Student.Course_Subcategory (course_id, subcategory_id) VALUES (${courseId}, ${primarySubcategoryId});`);
      }

      // Ensure subcategory id is unique
      if (primarySubcategory && primarySubcategoryId && !subcategoryIds.has(primarySubcategoryId)) {
        subcategoryIds.add(primarySubcategoryId);

        // Generate SQL insert statements for the "Subcategory" entity
        entityInsertStatements.push(`INSERT INTO Student.Subcategory (id, title, title_cleaned, url, icon_class) VALUES (${primarySubcategoryId}, ${escapeQuotes(primarySubcategory.title)}, ${escapeQuotes(primarySubcategory.title_cleaned)}, ${escapeQuotes(primarySubcategory.url)}, ${escapeQuotes(primarySubcategory.icon_class)});`);
      }

      // Generate SQL insert statements for the "Topic" table and relationships
      const contextInfo = course?.context_info;
      const catTopicId = contextInfo?.label?.id;
      const subCatTopicId = contextInfo?.subcategory?.id;

      // Generate SQL insert statement for the "Course_Topic" join table (label)
      if (catTopicId) {
        joinInsertStatements.push(`INSERT INTO Student.Course_Topic (course_id, topic_id) VALUES (${courseId}, ${contextInfo.label.id});`);
      }

      // Ensure topic id (via category) is unique
      if (!topicIds.has(catTopicId)) {
        topicIds.add(catTopicId);

        if (contextInfo && contextInfo?.label && contextInfo.label !== null && contextInfo.label?.id !== null) {
          const { label: { id, title, url } } = contextInfo;

          // Generate SQL insert statement for the "Topic" entity (label)
          entityInsertStatements.push(`INSERT INTO Student.Topic (id, title, url) VALUES (${id}, ${escapeQuotes(title)}, ${escapeQuotes(url)});`);
        }
      }

      // Generate SQL insert statement for the "Course_Topic" join table (subcategory)
      if (subCatTopicId) {
        joinInsertStatements.push(`INSERT INTO Student.Course_Topic (course_id, topic_id) VALUES (${courseId}, ${contextInfo.subcategory.id});`);
      }

      // Ensure topic id (via subcategory) is unique
      if (!topicIds.has(subCatTopicId)) {
        topicIds.add(subCatTopicId);

        if (contextInfo && contextInfo.subcategory && contextInfo.subcategory !== null && contextInfo.subcategory.id !== null) {
          const { subcategory: { id, title, url } } = contextInfo;

          // Generate SQL insert statement for the "Topic" entity (subcategory)
          entityInsertStatements.push(`INSERT INTO Student.Topic (id, title, url) VALUES (${id}, ${escapeQuotes(title)}, ${escapeQuotes(url)});`);
        }
      }
    });
  });

  /**
   * Write a newline separator character to the output file `sqlFile`.
   */
  const writeNewlineSeparator = () => {
    fs.writeFile(sqlFile, '\n', { flag: 'a' }, (err) => {
      if (err) {
        console.error('Error writing newline separator to SQL file');
        return;
      }
    });
  }

  /**
   * Perform post-processing on input array containing SQL `INSERT` statements, such that output has
   * unique-row entries and is sorted lexicographically (simple sort on entire `INSERT` statement).
   * @param {*} arrInsertStatements input array of entity- or join-table `INSERT` statements
   * @returns post-processed array for writing to output SQL file
   */
  const postProcessing = (arrInsertStatements) => arrInsertStatements.sort().filter((val, i, arr) => arr.indexOf(val) === i).join('\n');

  // Write SQL insert statements for entities tables to the output SQL file
  fs.writeFile(sqlFile, postProcessing(entityInsertStatements), { flag: 'w' }, (err) => {
    if (err) {
      console.error('Error writing to SQL file for entities:', err);
      return;
    }

    console.log(`Entity SQL insert statements have been generated and saved to ${sqlFile}`);
  });

  writeNewlineSeparator();

  // Write SQL insert statements for joins tables to the output SQL file
  fs.writeFile(sqlFile, postProcessing(joinInsertStatements), { flag: 'a' }, (err) => {
    if (err) {
      console.error('Error writing to SQL file for joins:', err);
      return;
    }

    console.log(`Join SQL insert statements have been generated and saved to ${sqlFile}`);
  });

  writeNewlineSeparator();
});
