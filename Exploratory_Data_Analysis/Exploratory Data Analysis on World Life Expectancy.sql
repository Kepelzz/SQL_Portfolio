-- World Life Expectancy Project 


-- Cleaning
select *
from worldlifexpectancy
;


-- Turning off safemode
SET SQL_SAFE_UPDATES = 0;



-- Working on duplicates

-- Column Country 

select country, year, concat(country, year), count(concat(country, year))
from worldlifexpectancy
group by country, year, concat(country, year)
having count(concat(country, year)) > 1
;

select *
from (
select
    row_id,
    concat(country, year),
    row_number() over(partition by concat(country, year) order by concat(country, year)) as row_num
from worldlifexpectancy) row_table
where row_num > 1;


delete from worldlifexpectancy
where Row_ID in (
    select Row_ID
From (
    select
        row_id,
        concat(country, year),
        row_number() over(partition by concat(country, year) order by concat(country, year)) as row_num
    from worldlifexpectancy) as row_table
where row_num > 1
)
;

-- Column Status
Select distinct (Status)
from worldlifexpectancy
Where status <> '';

Select distinct(country)
from worldlifexpectancy
where status = 'Developing';

Update worldlifexpectancy table1
join worldlifexpectancy table2
    on table1.Country = table2.Country
Set table1.Status = 'Developing'
Where table1.Status = ''
and table2.Status <> ''
and table2.Status = 'Developing';

select *
from worldlifexpectancy
where country = 'United States of America'
;

Update worldlifexpectancy table1
join worldlifexpectancy table2
    on table1.Country = table2.Country
Set table1.Status = 'Developed'
Where table1.Status = ''
and table2.Status <> ''
and table2.Status = 'Developed';

Select * 
from worldlifexpectancy
where status is null;

-- Column life_expectancy

Select *
from worldlifexpectancy
where `Lifeexpectancy` = '';

select
    t1.country,
    t1.year,
    t1.`Lifeexpectancy`,
    t2.country,
    t2.year,
    t2.`Lifeexpectancy`,
    t3.country,
    t3.year,
    t3.`Lifeexpectancy`,
    round((t2.`Lifeexpectancy` + t3.`Lifeexpectancy`)/2,1)
from worldlifexpectancy t1
join worldlifexpectancy t2
    on t1.Country = t2.Country
    and t1.year = t2.year - 1
join worldlifexpectancy t3
    on t1.Country = t3.Country
    and t1.year = t3.year + 1
where t1.`Lifeexpectancy` = ''
;

update worldlifexpectancy t1
join worldlifexpectancy t2
    on t1.Country = t2.Country
    and t1.year = t2.year - 1
join worldlifexpectancy t3
    on t1.Country = t3.Country
    and t1.year = t3.year + 1
set t1.`Lifeexpectancy` = Round((t2.`Lifeexpectancy` + t3.`Lifeexpectancy`)/2,1)
where t1.`Lifeexpectancy` = '';

select country, year, `Lifeexpectancy`
from worldlifexpectancy
where `Lifeexpectancy` = '';

-- Exploratory Data Analysis

select
    country,
    min(`Lifeexpectancy`),
    max(`Lifeexpectancy`),
    round(max(`Lifeexpectancy`) - min(`Lifeexpectancy`),1) as life_Increase_15_Years
from worldlifexpectancy
group by country
having min(`Lifeexpectancy`) <> 0
and max(`Lifeexpectancy`) <> 0
order by life_increase_15_years
;

select
    year,
    round(avg(`Lifeexpectancy`),2)
from worldlifexpectancy
Where `Lifeexpectancy` <> 0
and `Lifeexpectancy` <> 0
group by year
order by year
;

select
    country,
    round(avg(`Lifeexpectancy`),1) as life_exp,
    round(avg(GDP)) as GDP
from worldlifexpectancy
group by country
having Life_exp > 0
and GDP > 0
order by GDP asc
;

-- Searching for correlations between high GDP and life expectancy and visa versa.
select
SUM(CASE WHEN GDP >= 1500 THEN 1 ELSE 0 END) High_GDP_Count,
AVG(CASE WHEN GDP >= 1500 THEN `Lifeexpectancy` ELSE NULL END) High_GDP_Life_Expectancy,
SUM(CASE WHEN GDP <= 1500 THEN 1 ELSE 0 END) Low_GDP_Count,
AVG(CASE WHEN GDP <= 1500 THEN `Lifeexpectancy` ELSE NULL END) Low_GDP_Life_Expectancy
From worldlifexpectancy
;

select
    status, 
    round(avg(`Lifeexpectancy`),1)
from worldlifexpectancy
group by status;

select
    status, 
    count(distinct country),
    round(avg(`Lifeexpectancy`),1)
from worldlifexpectancy
group by status;


-- Searching for correlation between BMI and life expectancy 
select 
    country,
    round(avg(`Lifeexpectancy`),1) as life_exp,
    round(avg(BMI),1) as BMI
from worldlifexpectancy
group by country
having life_exp > 0
and BMI > 0 
order by BMI desc
;

-- creating rolling total for mortality rates

select
    country, 
    year,
    `Lifeexpectancy`,
    `AdultMortality`,
    SUM(`AdultMortality`) OVER(PARTITION BY Country ORDER BY year) as Rolling_Total
from worldlifexpectancy
Where country Like 'United%'
;
