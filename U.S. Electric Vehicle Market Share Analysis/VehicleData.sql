-- U.S. Electric Vehicle Market Share

select *
from vehicledata;
-- checking datatypes 
describe vehicledata;
-- converting datatype to correct data types
alter table vehicledata
modify COLUMN `Electric (EV)` DECIMAL(15,2),
modify column `Plug-In Hybrid Electric (PHEV)` DECIMAL(15,2),
MODIFY COLUMN `Hybrid Electric (HEV)` DECIMAL(15,2),
MODIFY COLUMN `Gasoline` DECIMAL(15,2),
modify column `Biodiesel` decimal(15,2),
modify column `Ethanol/Flex (E85)` decimal(15,2),
modify column `Compressed Natural Gas (CNG)` decimal(15,2),
modify column `Propane` decimal(15,2),
modify column `Hydrogen` decimal(15,2),
modify column `Methanol` decimal(15,2),
modify column `Diesel` decimal(15,2),
modify column `Unknown Fuel` decimal(15,2)
;

-- Data Cleaning Part
-- Checking for null values 

select 
    count(*) as total_rows,
    sum(case when state is null then 1 else 0 end) as missing_state,
    sum(case when `Electric (EV)` is null then 1 else 0 end) as missing_ev,
    sum(case when `Plug-In Hybrid Electric (PHEV)` is null then 1 else 0 end) as missing_phev,
    sum(case when `Hybrid Electric (HEV)` is null then 1 else 0 end) as missing_hev,
    sum(case when `Biodiesel` is null then 1 else 0 end) as missing_biodiesel,
    sum(case when `Gasoline` is null then 1 else 0 end) as missing_gasoline
from vehicledata;

-- checking for zero values

select 
    count(*) as total_rows,
    sum(case when state = 0 then 1 else 0 end) as missing_state,
    sum(case when `Electric (EV)` = 0 then 1 else 0 end) as missing_ev,
    sum(case when `Plug-In Hybrid Electric (PHEV)` = 0 then 1 else 0 end) as missing_phev,
    sum(case when `Hybrid Electric (HEV)` = 0 then 1 else 0 end) as missing_hev,
    sum(case when `Biodiesel` = 0 then 1 else 0 end) as missing_biodiesel,
    sum(case when `Gasoline` = 0 then 1 else 0 end) as missing_gasoline
from vehicledata;


select *
from vehicledata
where `Compressed Natural Gas (CNG)` REGEXP '[^0-9.]';

-- Insights:
-- There are no missing values, in Compressed Natural Gas(CNG), there are 10 zero entries only, and there are 0 negative values

-- Checking for inconsistencies 
select
distinct state 
from vehicledata
order by state;

select 
replace(format(`Gasoline`, 3), ',','.') as gasoline_eu
from vehicledata;

-- Insights: there are no inconsistencies and all the data is standardized

-- Market Share Analysis
-- Calculating the percentage of EVs, PHEVs, HEVs, and Gasoline vehicles for each state.
select 
    state,
    `Electric (EV)`,
    `Plug-In Hybrid Electric (PHEV)`,
    `Hybrid Electric (HEV)`,
    `Gasoline`,
    (`Electric (EV)` + `Plug-In Hybrid Electric (PHEV)` + `Hybrid Electric (HEV)` + `Gasoline`) as total_selected,
    round((`Electric (EV)` / (`Electric (EV)` + `Plug-In Hybrid Electric (PHEV)` + `Hybrid Electric (HEV)` + `Gasoline`)) * 100, 2) AS pct_ev,
    round((`Plug-In Hybrid Electric (PHEV)` / (`Electric (EV)` + `Plug-In Hybrid Electric (PHEV)` + `Hybrid Electric (HEV)` + `Gasoline`)) * 100, 2) AS pct_phev,
    round((`Hybrid Electric (HEV)` / (`Electric (EV)` + `Plug-In Hybrid Electric (PHEV)` + `Hybrid Electric (HEV)` + `Gasoline`)) * 100, 2) AS pct_hev,
    round((`Gasoline` / (`Electric (EV)` + `Plug-In Hybrid Electric (PHEV)` + `Hybrid Electric (HEV)` + `Gasoline`)) * 100, 2) AS pct_gasoline
from vehicledata
where (`Electric (EV)` + `Plug-In Hybrid Electric (PHEV)` + `Hybrid Electric (HEV)` + `Gasoline`) > 0
order by pct_ev desc;

-- identifying the top 5 states with the highest EV adoption rate (EVs as a % of all registered vehicles)
select
    State,
    `Electric (EV)`,
    (`Electric (EV)` + `Plug-In Hybrid Electric (PHEV)` + `Hybrid Electric (HEV)` + 
     `Biodiesel` + `Ethanol/Flex (E85)` + `Compressed Natural Gas (CNG)` + 
     `Propane` + `Hydrogen` + `Methanol` + `Gasoline` + `Diesel` + `Unknown Fuel`) AS total_vehicles,
    ROUND((`Electric (EV)` / 
           (`Electric (EV)` + `Plug-In Hybrid Electric (PHEV)` + `Hybrid Electric (HEV)` + 
            `Biodiesel` + `Ethanol/Flex (E85)` + `Compressed Natural Gas (CNG)` + 
            `Propane` + `Hydrogen` + `Methanol` + `Gasoline` + `Diesel` + `Unknown Fuel`)
          ) * 100, 3) AS ev_adoption_rate
from vehicledata
where (`Electric (EV)` + `Gasoline`) > 0
order by ev_adoption_rate DESC
limit 5;


-- Comparing EV adoption in California vs. other large states (e.g., Texas, Florida, New York).
select
    State,
    `Electric (EV)`,
    (`Electric (EV)` + `Plug-In Hybrid Electric (PHEV)` + `Hybrid Electric (HEV)` +
     `Biodiesel` + `Ethanol/Flex (E85)` + `Compressed Natural Gas (CNG)` +
     `Propane` + `Hydrogen` + `Methanol` + `Gasoline` + `Diesel` + `Unknown Fuel`) AS total_vehicles,
    round((`Electric (EV)` /
           (`Electric (EV)` + `Plug-In Hybrid Electric (PHEV)` + `Hybrid Electric (HEV)` +
            `Biodiesel` + `Ethanol/Flex (E85)` + `Compressed Natural Gas (CNG)` +
            `Propane` + `Hydrogen` + `Methanol` + `Gasoline` + `Diesel` + `Unknown Fuel`)
          ) * 100, 2) AS ev_adoption_rate
from vehicledata
where State IN ('California', 'Texas', 'Florida', 'New York')
order by ev_adoption_rate DESC;

-- Trend & insights 
-- highlighting which alternative fuels (biodiesel, ethanol, hydrogen) have meaningful presence vs. niche usage.

select 
    State,
    `Biodiesel`,
    `Ethanol/Flex (E85)`,
    `Hydrogen`,
    (`Electric (EV)` + `Plug-In Hybrid Electric (PHEV)` + `Hybrid Electric (HEV)` +
     `Biodiesel` + `Ethanol/Flex (E85)` + `Compressed Natural Gas (CNG)` +
     `Propane` + `Hydrogen` + `Methanol` + `Gasoline` + `Diesel` + `Unknown Fuel`) AS total_vehicles,
    round((`Biodiesel` /
           (`Electric (EV)` + `Plug-In Hybrid Electric (PHEV)` + `Hybrid Electric (HEV)` +
            `Biodiesel` + `Ethanol/Flex (E85)` + `Compressed Natural Gas (CNG)` +
            `Propane` + `Hydrogen` + `Methanol` + `Gasoline` + `Diesel` + `Unknown Fuel`)
          ) * 100, 2) AS biodiesel_pct,
    round((`Ethanol/Flex (E85)` /
           (`Electric (EV)` + `Plug-In Hybrid Electric (PHEV)` + `Hybrid Electric (HEV)` +
            `Biodiesel` + `Ethanol/Flex (E85)` + `Compressed Natural Gas (CNG)` +
            `Propane` + `Hydrogen` + `Methanol` + `Gasoline` + `Diesel` + `Unknown Fuel`)
          ) * 100, 2) AS ethanol_pct,
    round((`Hydrogen` /
           (`Electric (EV)` + `Plug-In Hybrid Electric (PHEV)` + `Hybrid Electric (HEV)` +
            `Biodiesel` + `Ethanol/Flex (E85)` + `Compressed Natural Gas (CNG)` +
            `Propane` + `Hydrogen` + `Methanol` + `Gasoline` + `Diesel` + `Unknown Fuel`)
          ) * 100, 3) AS hydrogen_pct
FROM Vehicledata
ORDER BY ethanol_pct DESC;

-- Insights: 
-- Ethanol (E85) - Meaningful in Midwest (Iowa, Minnesota, Illinois) and it is supported by agricultural fuel blending programs.
-- Biodiesel - it has moderate presence in farm and trucking-heavy states (Texas, Iowa, Illinois). It is still small share overall, but relevant in logistics fleets.
-- Hydrogen - Extremely niche — only visible in California due to pilot hydrogen fueling network, practically zero elsewhere.
