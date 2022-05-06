# Faculty-Analyzer
This project will use R to discover the gap between the faculty’s resume and the program course descriptions and maximize the compatibility of each course and its instructors

## Use Case
This application will provide a webpage to upload a resume and a data file of course descriptions. It will produce a report on resume similarity to course descriptions to advise the user on the best courses to assign to the faculty member. The resume is supposed to be a txt file. The course description file should be the CSV file only contains two columns with the "title" (Note the case) header and the "description" header. These will allow the algorithm to read that column. Users can enter the course name and instructor name, which will be automatically saved in the report. The user can then click the "Compute" button, and the system will automatically report resume similarity to course descriptions. Users should wait patiently for a few seconds, and the results will be displayed on their screen. Based on the results, users can compare the similarity scores to select the most suitable course. If the user needs to save the results, they will download them by clicking on the "Download Scoring Result" button at the end of the results.

The system main functions are listed below:

1. Users need to convert their resume into text file before uploading.
2. Users need to covert the course description file into CSV format and make sure there are title and description to columns with lowercase for the algorithm to read.
3. Upload the source files.
4. Click the "Compute" button
5. Click the "Download Scoring Result" button, and the system will automatically download the report, including date, course name, similarity score, and percentage.
