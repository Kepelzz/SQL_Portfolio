# 🧹 SQL Data Cleaning Project — Layoffs Dataset (MySQL)

This project demonstrates a comprehensive SQL-based data cleaning workflow using MySQL.
It focuses on transforming a messy real-world dataset — containing company layoff information — into a clean, standardized, analysis-ready table.

# 🧱 Project Overview

The goal of this project is to walk through every major step of a data cleaning pipeline directly inside SQL, without the use of external tools like Python or Excel.
It simulates a real data engineer’s process for preparing data for analysis or storage in a production database.

# ⚙️ Key Steps in the Process:
1. Create a Staging Table
A duplicate of the raw table layoffs is created as layoffs_staging to safely perform transformations. This ensures the original data remains untouched and reusable for reference.

2. Remove Duplicates
Identifies potential duplicates using a ROW_NUMBER() window function. Rows with a rank greater than 1 (row_num > 1) are flagged as duplicates for removal or inspection.

3. Standardize Text Fields
Cleans up inconsistencies in text columns like company, industry, location, and country. Uses TRIM() and UPDATE to remove extra spaces or punctuation. Normalizes country names (e.g., converting "United States." → "United States").

4. Fix Date Formats
Converts text-based dates to proper SQL DATE data type. Ensures consistent formatting for time-based analysis.

5. Handle Null or Blank Values
Identifies missing or blank values for further treatment (e.g., imputation or deletion). The script establishes a structure to check and clean null data for key attributes like industry, stage, and total_laid_off.

6. Prepare Final Clean Table
After cleaning, the dataset in layoffs_staging becomes standardized, free of duplicates, and ready for exploratory analysis or visualization.


📈 Outcome:
After running this SQL pipeline:
All string inconsistencies are fixed (extra spaces, punctuation, casing).
Dates are properly formatted for filtering and aggregation.
Duplicates are removed safely.
The table is now standardized for accurate reporting or visualization in BI tools (e.g., Power BI, Tableau, or Python notebooks).


🛠 Tech Stack
Database: MySQL
Techniques: Window Functions, Data Cleaning, Type Conversion, Text Normalization
Goal: Produce a fully cleaned and standardized dataset for further analysis
