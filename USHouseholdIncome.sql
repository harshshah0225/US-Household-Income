# US Household Income Data Cleaning 
SELECT *
FROM us_household_income;

SELECT *
FROM us_household_income_statistics;

# Renaming the field name
ALTER TABLE us_household_income_statistics RENAME COLUMN `ï»¿id` TO `id`;

# Counting the number of rows to check table import
SELECT COUNT(id)
FROM us_household_income;

SELECT COUNT(id)
FROM us_household_income_statistics;

# Identifying and removing duplicates

-- SELECT id, COUNT(id)
-- FROM us_household_income_statistics
-- GROUP BY id
-- HAVING COUNT(id) > 1;

SELECT id, COUNT(id)
FROM us_household_income
GROUP BY id
HAVING COUNT(id) > 1;

DELETE FROM us_household_income
WHERE row_id IN (
	SELECT row_id
	FROM (
		SELECT row_id, id,
		ROW_NUMBER() OVER(PARTITION BY id ORDER BY id) row_num
		FROM us_household_income) duplicates
	WHERE row_num > 1); 
    
# Fixing typos in State_Name
UPDATE us_household_income
SET State_Name = "Georgia"
WHERE State_Name = "georia";   

UPDATE us_household_income
SET State_Name = "Alabama"
WHERE State_Name = "alabama";  

SELECT DISTINCT State_Name
FROM us_household_income; 

# Filling in the missing Place value
UPDATE us_household_income
SET Place = "Autaugaville"
WHERE County = "Autauga County"
	AND City = "Vinemont";
    
SELECT *
FROM us_household_income
WHERE Place = "";

# Fixing typos in Type
UPDATE us_household_income
SET Type = "Borough"
WHERE Type = "Boroughs";

SELECT Type, COUNT(Type)
FROM us_household_income
GROUP BY Type;

# US Household Income Exploratory Data Analysis
SELECT State_Name, County, City Aland, AWater
FROM us_household_income;

# Top 10 largest states by land area
SELECT State_Name, SUM(ALand)
FROM us_household_income
GROUP BY State_Name
ORDER BY 2 DESC
LIMIT 10;

# Top 10 largest states by water area
SELECT State_Name, SUM(AWater)
FROM us_household_income
GROUP BY State_Name
ORDER BY 2 DESC
LIMIT 10;

# Joining two tables
SELECT *
FROM us_household_income u
JOIN us_household_income_statistics us
	ON u.id = us.id
WHERE Mean <> 0;

# Finding states with lowest mean household income
SELECT u.State_Name, ROUND(AVG(Mean),2), ROUND(AVG(Median),2)
FROM us_household_income u
JOIN us_household_income_statistics us
	ON u.id = us.id
WHERE Mean <> 0
GROUP BY u.State_Name
ORDER BY 2 
LIMIT 10;

# Finding states with highest mean household income
SELECT u.State_Name, ROUND(AVG(Mean),2), ROUND(AVG(Median),2)
FROM us_household_income u
JOIN us_household_income_statistics us
	ON u.id = us.id
WHERE Mean <> 0
GROUP BY u.State_Name
ORDER BY 2 DESC
LIMIT 10;

# Finding states with lowest median household income
SELECT u.State_Name, ROUND(AVG(Mean),2), ROUND(AVG(Median),2)
FROM us_household_income u
JOIN us_household_income_statistics us
	ON u.id = us.id
WHERE Mean <> 0
GROUP BY u.State_Name
ORDER BY 3
LIMIT 10;

# Finding states with highest median household income
SELECT u.State_Name, ROUND(AVG(Mean),2), ROUND(AVG(Median),2)
FROM us_household_income u
JOIN us_household_income_statistics us
	ON u.id = us.id
WHERE Mean <> 0
GROUP BY u.State_Name
ORDER BY 3 DESC
LIMIT 10;

# Analyzing income levels in several categories
SELECT Type, COUNT(Type), ROUND(AVG(Mean), 2), ROUND(AVG(Median), 2)
FROM us_household_income u 
JOIN us_household_income_statistics us
	ON u.id = us.id
WHERE Mean <> 0
GROUP BY 1
ORDER BY 4 DESC;

# Top 10 cities with highest mean incomes
SELECT u.State_Name, City, ROUND(AVG(Mean), 2)
FROM us_household_income u 
JOIN us_household_income_statistics us
	ON u.id = us.id
WHERE Mean <> 0
GROUP BY 1, 2
ORDER BY 3 DESC
LIMIT 10;