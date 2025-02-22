 Automated_Flat_File_Importer_and_Processor_into_Database__Using_Advanced_SQL_Project

This project is an advanced-SQL-based solution designed to import and process flat files into a SQL Server database . The primary aim is to automate the loading of data from multiple flat files (CSV, TXT) into structured tables within a SQL database. Additionally, the project handles basic data cleaning to remove unwanted characters and ensures the proper creation of tables based on the structure of the incoming flat files. It also contains** job to automatically schedule execution at midnight (12 A.M)**

->Flat File Import: Uses xp_cmdshell to list flat files from a specified directory and loads them into a temporary table.

->Dynamic Table Creation: For each flat file, a corresponding table is created dynamically with column names inferred from the data in the first record of the file.
Data Cleaning: The imported data is processed to remove non-alphanumeric and special characters that may interfere with further processing.
Efficient Data Insertion: The program processes the records and inserts them into the newly created tables, matching the appropriate structure and ensuring integrity.

Steps taken for implementation:

1)Place the Flat Files: Place all your flat files in the designated directory (e.g., C:\Users\HP\Desktop\sql_proj\Flat_files).

2)Run the Script: Execute the provided SQL script to start the data import process. The script will:

->List all files in the directory.

->Create necessary tables based on the file names.

->Insert the data into the corresponding tables.

->Clean up any unwanted characters from the data.

3)Data Access: After the data import is complete, you can access the data in your tables using SELECT queries.
