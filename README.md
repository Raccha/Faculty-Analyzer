# Faculty-Analyzer
This project will use R to discover the gap between the faculty’s resume and the program course descriptions and maximize the compatibility of each course and its instructors

## Use Case
This application will provide a webpage to upload a resume and course descriptions file in text and csv format. It will generate a report on resume similarity to course descriptions and recommend the user on the best courses to assign to the faculty member. 

The system main functions are listed below:

1. Users need to convert their resume into text file before uploading.
2. Users need to covert the course description file into CSV format and make sure there are 'title' and 'description' to columns with lowercase for the algorithm to read.
3. Upload the source files.
4. Click the "Compute" button
5. Click the "Download Scoring Result" button, and the system will automatically download the report, including date, course name, similarity score, and percentage.
