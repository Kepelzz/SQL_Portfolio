# Exploratory Data Analysis on World Life Expectancy (MySQL)

This project performs a complete data cleaning and exploratory analysis of the World Life Expectancy dataset using MySQL.
It focuses on transforming raw, inconsistent data into an analysis-ready format and uncovering relationships between GDP, BMI, mortality rates, and life expectancy across countries.

# 1. Data Cleaning & Preparation

Before analysis, the dataset undergoes a rigorous cleaning process to ensure accuracy and consistency:

* Duplicate Removal:
  Detects and deletes duplicate rows based on a combination of `country` and `year` using a `ROW_NUMBER()` window function.
* Missing Value Imputation:
  Fills missing life expectancy values by averaging the previous and following year for each country.
* Status Normalization:
  Standardizes country development status (`Developed` / `Developing`) using self-joins to fill blank records.
* Text and Data Integrity Checks:
  Ensures all numeric and categorical columns contain valid, non-empty values before analysis.


# 📊 2. Exploratory Data Analysis (EDA)

Once cleaned, the script dives into descriptive analytics and correlation exploration.

# Key analytical queries:

* Life Expectancy Growth (15-Year Change):
  Calculates the increase in average life expectancy per country over 15 years.
* Global Trends Over Time:
  Computes average life expectancy per year to visualize worldwide improvements.
* Economic Correlation:
  Explores the relationship between GDP and life expectancy, distinguishing between high- and low-GDP countries.
* BMI and Life Expectancy:
  Analyzes whether countries with higher average BMI also experience longer or shorter lifespans.
* Development Status Comparison:
  Compares average life expectancy across `Developed` vs `Developing` nations.
* Mortality Trends:
  Implements a **rolling total** of adult mortality to observe long-term decline patterns per country.


* Countries with higher GDP consistently show greater life expectancy.
* Average life expectancy has increased globally year-over-year, though unevenly across regions.
* The Developed vs Developing divide remains evident but is narrowing in recent decades.
* BMI levels have an observable (but not linear) relationship with life expectancy.
* Mortality trends show steady long-term improvement across most nations.


# ⚙️ Tech Stack

* **Database:** MySQL
* **Language:** SQL
* **Techniques:** Window functions, data cleaning, aggregation, conditional logic, time-series analysis



Would you like me to write a **short GitHub tagline (1-line)** version for your repository description too (for the top of the repo page)?
