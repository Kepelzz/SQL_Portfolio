-- Automated Data Cleaning 

DELIMITER $$
DROP PROCEDURE IF EXISTS Copy_and_clean_data;
CREATE PROCEDURE Copy_and_clean_data()
BEGIN
-- Creating table
    CREATE TABLE IF NOT EXISTS `USHouseholdIncome_Cleaned` (
      `row_id` int NOT NULL,
      `id` int NOT NULL,
      `State_Code` int NOT NULL,
      `State_Name` varchar(20) NOT NULL,
      `State_ab` varchar(2) NOT NULL,
      `County` varchar(33) NOT NULL,
      `City` varchar(22) NOT NULL,
      `Place` varchar(36) DEFAULT NULL,
      `Type` varchar(12) NOT NULL,
      `Primary` varchar(5) NOT NULL,
      `Zip_Code` int NOT NULL,
      `Area_Code` varchar(3) NOT NULL,
      `ALand` bigint NOT NULL,
      `AWater` bigint NOT NULL,
      `Lat` decimal(10,7) NOT NULL,
      `Lon` decimal(12,7) NOT NULL,
      `TimeStamp` TIMESTAMP DEFAULT NULL
    ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
    
-- COPY DATA TO NEW TABLE 

    INSERT INTO USHouseholdIncome_Cleaned
    SELECT *, current_timestamp
    from ushouseholdincome; 
    
-- DATA CLEANING STEPS 

    -- 1. Remove Duplicates 
    delete from USHouseholdIncome_Cleaned
    where 
        row_id in (
        select row_id
        from (
            select
                row_id,
                id,
                row_number() over(partition by id order by id) row_num
                from USHouseholdIncome
                ) duplicates
            where row_num > 1);
            
    -- 2. Standarisation 
    Update ushouseholdincome_cleaned
    set state_name = 'Georgia'
    where state_name = 'georia';
    
    update ushouseholdincome_cleaned
    set County = UPPER(County);
    
    update ushouseholdincome_cleaned
    set city = Upper(City);
    
    update ushouseholdincome_cleaned
    set place = Upper(Place);
    
    update ushouseholdincome_cleaned
    set state_name = upper(state_name);
    
    update ushouseholdincome_cleaned
    set `Type` = 'CDP'
    WHERE `Type` = 'CPD';
    
    update ushouseholdincome_cleaned 
    set `Type` = 'Borough'
    where `Type` = 'Borouhgs';
END $$
DELIMITER ;

call Copy_and_clean_data();

-- DEBUGGING OR CHECKING THAT STORED PROCEDURE WORKS 

select 
    row_id,
    id,
    row_num 
from (
    select row_id,
    id,
    row_number() over(partition by id order by id) as row_num
    from ushouseholdincome_cleaned) duplicates
where row_num > 1;

select count(row_id)
from ushouseholdincome;

select state_name, count(state_name)
from ushouseholdincome
group by state_name;


-- CREATING EVENT 
Create event run_data_cleaning
    on schedule every 2 minute 
    do call copy_and_clean_data();
