#!/bin/bash

# Function to generate random noise between `bias` and `bias + scale_factor` (in seconds)
generate_random_noise() {
  precision=2
  bias=-0.25
  scale_factor=0.5
  normalization_factor=$((2**15-1))
  echo "$(bc -l <<< "scale=$precision; $bias + $scale_factor * $RANDOM / $normalization_factor")"
}

# Define an array of course fields
course_fields=(
  archive_time
  avg_rating
  buyable_object_type
  completion_ratio
  context_info
  created
  enrollment_time
  estimated_content_length
  favorite_time
  features
  headline
  image_240x135
  image_480x270
  is_for_practice_test_course
  is_paid
  is_practice_test_course
  is_private
  is_published
  last_accessed_time
  last_update_date
  num_collections
  num_lectures
  num_quizzes
  num_reviews
  num_subscribers
  primary_category
  primary_subcategory
  published_title
  purchase_date
  status_label
  title
  tracking_id
  url
  visible_instructors
)

# Static variables
fields_course=$(IFS=,; echo "${course_fields[*]}") # construct the string param value `fields[course]` by joining the elements of array `fields_course` with commas
fields_user="@all"
page_size=1

# Function to construct the URL with dynamic variables
construct_page_url() {
  local page_num=$1

  local base_url="https://www.udemy.com/api-2.0/users/me/subscribed-courses-collections/"
  local params="fields[course]=$fields_course&fields[user_has_subscribed_courses_collection]=$fields_user&page_size=$page_size&page=$page_num"

  echo "$base_url?$params"
}

# Prompt the user for an access token
read -p "Enter your Udemy account access token: " access_token

# Check if the access token is empty
if [ -z "$access_token" ]; then
  echo "Access token cannot be empty. Exiting."
  exit 1
fi

# Initialize variables
timestamp=$(date +%s)
output_file="udemy_lists_$timestamp.json"
page_num=1
page_url=$(construct_page_url "$page_num")

# Initialize an empty array to store results
all_results=()

# Function to fetch and append results to the array with a delay
fetch_results() {
  json_data=$(curl -s --location --globoff "$page_url" --header "Authorization: Bearer $access_token")
  if [ $? -ne 0 ]; then
    echo "Failed to download JSON data. Exiting."
    exit 1
  fi

  results="$(echo "$json_data" | jq '.results[]')"
  all_results+=("$results")

  # Get the next page URL or exit if no more pages
  page_url=$(echo "$json_data" | jq -r '.next')

  # Delay subsequent request, using `base_time + random_noise` to vary the between-requests delay time
  random_noise=$(generate_random_noise)
  base_time=8 # seconds
  sleep $(bc -l <<< "$base_time + $random_noise")
}

# Loop to fetch results and paginate until no more pages
while [ "$page_url" != "null" ]; do
  ((page_num++))
  page_url=$(construct_page_url "$page_num")
  fetch_results
done

# Save the combined JSON to the output file using jq to format it and sort by "title"
echo "${all_results[@]}" | jq -s 'sort_by(.title)' > "$output_file"

echo "Combined JSON data saved to $output_file"
