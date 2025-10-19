# Data Cleaning 
select *
from layoffs;

# 1. Remove Duplicates
# 2. Standardize the Data
# 3. Null Values or blank values 
# 4. Remove any unncessary columns 

#Creating a duplicate to work on 
create table layoffs_staging
like layoffs;

insert layoffs_staging
select *
from layoffs;

select *
from layoffs_staging;

# 1. Removing duplicates
select *,
row_number() over(
partition by company, industry, total_laid_off, percentage_laid_off, `date`) as row_num
from layoffs_staging;

with duplicate_cte as
(
select *,
row_number() over(
partition by company, industry, total_laid_off, percentage_laid_off, `date`, stage
, country, funds_raised_millions) as row_num
from layoffs_staging
)
select *
from duplicate_cte
where row_num > 1;

# There are no duplicates in dataset. 
# 2. Standardizing Data

select company, trim(company)
from layoffs_staging;

#Disabling safe mode
SET SQL_SAFE_UPDATES = 0;

update layoffs_staging
set company = trim(company);

select distinct industry
from layoffs_staging
order by 1;

select distinct location 
from layoffs_staging
order by 1;

select distinct country, trim(trailing '.' from country)
from layoffs_staging
where country like 'United States%'
order by 1;

update layoffs_staging
set country = trim(trailing '.' from country)
where country like 'United States%';

select distinct country
from layoffs_staging
where country like 'United States%'
order by 1;

# working on date format since date is a text format 
select `date`,
str_to_date(`date`, '%m/%d/%Y')
from layoffs_staging;

update layoffs_staging
set `date` = str_to_date(`date`, '%m/%d/%Y');

alter table layoffs_staging
modify column `date` date;

# Working on Null and Blank Values 
