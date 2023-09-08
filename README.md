# Parser for Udemy Account Courses List

## Overview

A semi-automated, scripts-based approach to downloading courses data for an authenticated Udemy user account.

## Prereqs

Intended for Unix-based systems (drafted on Ubuntu 22.04). Additional external dependencies are as follows:
  * [`jq`](https://jqlang.github.io/jq/) command-line utility for JSON parsing
  * (***optional***) Node.js v.16+
  * (***optional***) Postgres v.13+

***N.B.*** ***optional*** dependencies only required for JSON to SQL conversion.

## Steps for Use

***N.B.*** All terminal commands in this section assume a reference location of the top-level repo directory (i.e., `.../udemy-my-courses-data-parser/`).

### 1. Authentication

To download the JSON payload containing the lists and courses data, first you must authenticate into your Udemy user account. Do this most simply via the [Udemy website](https://www.udemy.com) itself.

Once authenticated, retrieve your `access_token` via browser developer tools or equivalent. Using Google Chrome Developer Tools as a representative example, this can be accomplished as follows:

<center>
<img src="./assets/access-token.png">
</center>

***N.B.*** The `access_token` value is an alphanumeric string, approximately 40 total alphanumeric characters in length.

### 2. Downloading Data as JSON

To download all lists and their constituent courses as a flattened JSON array (i.e., of general form `[ { list1 }, { list2 }, ...]`), run the parsing script from the command line as follows:

```bash
./udemy-list-parser.sh
```

At the terminal prompt `Enter your Udemy account access token: `, provide the `access_token` value from the previous step and then press `ENTER` to run the script.

***N.B.*** The script has dynamically set parameters, which can be adjusted accordingly to your preference. These are set here to run with relatively "slow delay" (ca. 8 +/- 0.25 s, going by page size `1` and page count `1`) to ensure full data download and no corresponding prematurely canceled requests. Correspondingly, this may take a few minutes to run.

On successful completion of the script, the following message will appear in the terminal:

```bash
Combined JSON data saved to udemy_lists_<timestamp>.json
```

where `<timestamp>` is the corresponding [Unix timestamp](https://www.unixtimestamp.com/) taken on initial run of the script.

### 3. (***Optional***) Transform JSON Payload to SQL Tables

If desired, the resulting JSON payload from the previous step can be transformed to SQL tables for additional querying, transformation, etc.

To do this, connect to a live Postgres server instance, and create tables using the script provided in `create_tables.sql`. This will define tables as follows:

| Table Name | Entity or Join Table Type|
|:--:|:--:|
| `list` | entity |
| `course` | entity |
| `instructor` | entity |
| `category` | entity |
| `subcategory` | entity |
| `topic` | entity |
| `course_list` | join |
| `course_instructor` | join |
| `course_category` | join |
| `course_subcategory` | join | 
| `course_topic` | join |

***N.B.*** In general, there is a many-to-many relationship between `course` and the other entities, which in turn is captured via the respective join tables accordingly.

With the tables created, to create the seed data to populate the tables from the downloaded JSON payload in the previous step, run the generator script `create-seed.js` via Node.js from the command line as follows:

```bash
node create-seed.js udemy_lists_<timestamp>.json
```
 where `udemy_lists_<timestamp>.json` is the JSON payload file generated in the previous step.

On successful completion of the script, the following message will appear in the terminal:

```bash
Entity SQL insert statements have been generated and saved to seed_data_<timestamp>.sql
Join SQL insert statements have been generated and saved to seed_data_<timestamp>.sql
```

where `<timestamp>` is the corresponding [Unix timestamp](https://www.unixtimestamp.com/) taken on initial run of the script.

Furthermore, as this message suggests, this creates a new file `seed_data_<timestamp>.sql` which provides the corresponding `INSERT ...` statements to populate the tables.

### 4. Updating the Data

To repeat this process (i.e., to update the existing data with new/live data from Udemy), re-run the script in step `2` for regenerating the JSON payload. Furthermore, to reseed the database data, run the script in `truncate_tables.sql`, and then repeat step `3`. 
