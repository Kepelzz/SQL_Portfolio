🇺🇸 US Household Income Data Cleaning & Analysis (MySQL)

This project performs both data cleaning and exploratory data analysis (EDA) on U.S. household income data using pure SQL.
It demonstrates how to transform raw, inconsistent demographic data into an analysis-ready dataset and extract key insights about income distribution, geography, and regional trends.

🧹 1. Data Cleaning Process
Before analysis, the project focuses on data integrity, consistency, and accuracy using structured SQL operations. Key Cleaning Steps:
- Duplicate Detection & Removal
- Identifies duplicate records in both USHouseholdIncome and USHouseholdIncome_Statistics tables using ROW_NUMBER() with PARTITION BY id.
- Deletes duplicates safely via subqueries:


Spelling Corrections:
- Fixes common typos in state names (e.g., 'georia' → 'Georgia', 'alabama' → 'Alabama')
- Standardizing Categorical Data

Normalizing inconsistent “Type” values:
- 'Boroughs' → 'Borough'
- 'CPD' → 'CDP'

Ensuring consistent naming across counties, cities, and places.
Null and Zero Checks.
Detecting missing or invalid land/water area data.
Cross-table Consistency
Joins income and statistics tables on id to validate relationships and ensure data completeness.

📊 2. Exploratory Data Analysis (EDA)
After cleaning, the project runs several analytical SQL queries to uncover demographic and economic patterns across U.S. states and cities.

Key Analyses:

Largest States by Land and Water Area

SELECT state_name, SUM(aland), SUM(awater)
FROM USHouseholdIncome
GROUP BY state_name
ORDER BY SUM(aland) DESC
LIMIT 10;


→ Reveals which states dominate geographically (e.g., Alaska, Texas, California).

Top States by Mean & Median Income

SELECT u.state_name, ROUND(AVG(mean),1), ROUND(AVG(median),1)
FROM USHouseholdIncome u
JOIN USHouseholdIncome_Statistics us ON u.id = us.id
WHERE mean <> 0
GROUP BY u.state_name
ORDER BY 2 DESC
LIMIT 5;


→ Shows the wealthiest states by average income.

Income by Type of Area

SELECT u.type, COUNT(type), ROUND(AVG(mean),1), ROUND(AVG(median),1)
FROM USHouseholdIncome u
JOIN USHouseholdIncome_Statistics us ON u.id = us.id
WHERE mean <> 0
GROUP BY u.type
ORDER BY 2 DESC
LIMIT 10;


→ Compares average incomes by settlement type (e.g., city, CDP, borough).

Top Cities by Average Income

SELECT u.state_name, city, ROUND(AVG(mean),1), ROUND(AVG(median),1)
FROM USHouseholdIncome u
JOIN USHouseholdIncome_Statistics us ON u.id = us.id
GROUP BY u.state_name, city
ORDER BY ROUND(AVG(mean),1) DESC
LIMIT 10;


→ Lists the most affluent U.S. cities by household income.

💡 Insights
States like Maryland, New Jersey, and California consistently rank highest in household income. Larger land area doesn’t always correlate with higher income — economic density plays a key role. Household income varies sharply between urban centers and rural areas. The dataset reveals clear income stratification by geography and development type.

🛠 Tech Stack
Language: SQL
Database: MySQL
Techniques: Data Cleaning, Window Functions, Aggregation, Joins, and Statistical Summarization.
