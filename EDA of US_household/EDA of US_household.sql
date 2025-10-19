-- US Household Cleaning Project 

-- Deleting duplicates

select id, count(id)
from USHouseholdIncome
group by id
having count(id) > 1
;

select *
from (
select
    row_id,
    id,
    row_number() over(partition by id order by id) row_num
from USHouseholdIncome) duplicates
where row_num > 1
;

delete from USHouseholdIncome
where row_id in (
    select row_id
    from (
        select
            row_id,
            id,
            row_number() over(partition by id order by id) row_num
            from USHouseholdIncome
            ) duplicates
        where row_num > 1)
;

-- Second table 
select
    id,
    count(id)
from ushouseholdincome_statistics
group by id
having count(id) > 1
;

-- Checking spelling
select distinct State_name,
    count(state_name)
from ushouseholdincome
group by state_name;

update ushouseholdincome
set state_name = 'Georgia'
where state_name = 'georia';

update ushouseholdincome
set state_name = 'Alabama'
where state_name = 'alabama';

select *
from ushouseholdincome
where County = 'Autauga County'
order by 1
;

update ushouseholdincome
set place = 'Autaugaville'
where county = 'Autauga County'
and city = 'Vinemont';

-- working on type column 
select type, count(type)
from ushouseholdincome
group by type;

update ushouseholdincome
set type = 'Borough'
where type = 'Boroughs';

update ushouseholdincome
set type = 'CDP'
where type = 'CPD';

-- checking Aland and Awater columns 
select
    aland,
    awater
from ushouseholdincome
where (awater = 0 or awater = '' or awater is null)
and (aland = 0 or aland = '' or aland is null);


-- Exploratory Data Analysis 
-- Looking at the biggest states by land and by water 
select 
    state_name,
    sum(aland),
    sum(awater)
from ushouseholdincome
group by state_name
order by 2 desc
;

select 
    state_name,
    sum(aland),
    sum(awater)
from ushouseholdincome
group by state_name
order by 2 desc
limit 10;

select 
    state_name,
    sum(aland),
    sum(awater)
from ushouseholdincome
group by state_name
order by 3 desc
limit 10;

-- Checking general information about household incomes in US 

select 
    u.state_name,
    round(avg(mean),1),
    round(avg(median),1)
from ushouseholdincome u
inner join ushouseholdincome_statistics us
    on u.id = us.id
    where mean <> 0
group by u.State_Name
order by 2 desc
limit 5
;
   
select 
    u.type,
    count(type),
    round(avg(mean),1),
    round(avg(median),1)
from ushouseholdincome u
inner join ushouseholdincome_statistics us
    on u.id = us.id
    where mean <> 0
group by u.type
order by 2 desc
limit 10
;

-- Checking averages per city 
select
    u.State_name,
    city, 
    round(avg(mean),1),
    round(avg(median),1)
from ushouseholdincome u
join ushouseholdincome_statistics us
    on u.id = us.id
group by u.State_name, city
order by round(avg(mean),1) desc
limit 10;


  
