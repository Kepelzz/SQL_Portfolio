This SQL project automates the process of cleaning and standardizing raw data using a stored procedure and event scheduler in MySQL.
It’s designed to copy raw data, fix inconsistencies, remove duplicates, and maintain an up-to-date cleaned dataset — all automatically.

🚀 Key Features:
- Stored Procedure (Copy_and_clean_data) — encapsulates the entire cleaning workflow into a single callable process.
- Automated Execution — uses a MySQL event scheduler to run the cleaning job every 2 minutes.
- Duplicate Detection — removes redundant rows via a ROW_NUMBER() window function.
- Text Standardization — fixes capitalization, trims spaces, and corrects known typos (e.g. georia → Georgia, CPD → CDP).
- Categorical Corrections — normalizes inconsistent values in state, place, and type columns.
-Timestamp Tracking — logs when each cleaning cycle was executed for audit and traceability.

🧠 Purpose:
The goal of this project is to demonstrate how data engineering automation can be implemented purely within SQL — ensuring clean, consistent, and reliable datasets without external scripts.

⚙️ Tech Stack:
Database: MySQL
Techniques: Stored Procedures, Window Functions, Event Scheduler, Data Normalization
