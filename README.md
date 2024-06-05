# US Household Income Data Cleaning and Analysis Project

## Overview

This project involves cleaning and analyzing datasets related to US household income. The primary tasks include identifying and removing duplicate records, correcting typos, filling in missing values, ensuring data consistency, and conducting exploratory data analysis (EDA) to uncover insights and patterns.

## Table of Contents

- [Overview](https://github.com/harshshah0225/US-Household-Income/tree/main#overview)
- [Datasets](https://github.com/harshshah0225/US-Household-Income/tree/main#datasets)
- [Exploratory Data Analysis](https://github.com/harshshah0225/US-Household-Income/tree/main#exploratory-data-analysis)
- [Usage](https://github.com/harshshah0225/US-Household-Income/tree/main#usage)
- [Conclusion](https://github.com/harshshah0225/US-Household-Income/tree/main#conclusion)

## Datasets

The datasets used in this project are:

- **USHouseholdIncome.csv**: Contains data about household income across various states and counties in the US.
- **USHouseholdIncome_Statistics.csv**: Provides statistical data on household income, such as mean and median income values.

## Data Cleaning Steps

1. Importing Data

```sql
SELECT *
FROM us_household_income;

SELECT *
FROM us_household_income_statistics;
```

2. Renaming Fields

```sql
ALTER TABLE us_household_income_statistics RENAME COLUMN `ï»¿id` TO `id`;
```

3. Counting Rows

```sql
SELECT COUNT(id)
FROM us_household_income;

SELECT COUNT(id)
FROM us_household_income_statistics;
```

4. Identifying and Removing Duplicates

```sql
-- Identifying duplicates
SELECT id, COUNT(id)
FROM us_household_income
GROUP BY id
HAVING COUNT(id) > 1;

-- Removing duplicates
DELETE FROM us_household_income
WHERE row_id IN (
    SELECT row_id
    FROM (
        SELECT row_id, id,
        ROW_NUMBER() OVER(PARTITION BY id ORDER BY id) row_num
        FROM us_household_income
    ) duplicates
    WHERE row_num > 1
);
```

5. Correcting Typos

```sql
-- Fixing typos in State_Name
UPDATE us_household_income
SET State_Name = "Georgia"
WHERE State_Name = "georia";

UPDATE us_household_income
SET State_Name = "Alabama"
WHERE State_Name = "alabama";

-- Fixing typos in Type
UPDATE us_household_income
SET Type = "Borough"
WHERE Type = "Boroughs";
```

6. Filling in Missing Values

```sql
UPDATE us_household_income
SET Place = "Autaugaville"
WHERE County = "Autauga County"
    AND City = "Vinemont";
```

## Exploratory Data Analysis (EDA)

1. Overview of Data

```sql
SELECT State_Name, County, City, Aland, AWater
FROM us_household_income;
```

2. Largest States by Land and Water Area

```sql
-- Top 10 largest states by land area
SELECT State_Name, SUM(ALand)
FROM us_household_income
GROUP BY State_Name
ORDER BY 2 DESC
LIMIT 10;

-- Top 10 largest states by water area
SELECT State_Name, SUM(AWater)
FROM us_household_income
GROUP BY State_Name
ORDER BY 2 DESC
LIMIT 10;
```

3. Joining Tables

```sql
SELECT *
FROM us_household_income u
JOIN us_household_income_statistics us
    ON u.id = us.id
WHERE Mean <> 0;
```

4. Analyzing Household Income

```sql
-- Finding states with lowest mean household income
SELECT u.State_Name, ROUND(AVG(Mean), 2), ROUND(AVG(Median), 2)
FROM us_household_income u
JOIN us_household_income_statistics us
    ON u.id = us.id
WHERE Mean <> 0
GROUP BY u.State_Name
ORDER BY 2 
LIMIT 10;

-- Finding states with highest mean household income
SELECT u.State_Name, ROUND(AVG(Mean), 2), ROUND(AVG(Median), 2)
FROM us_household_income u
JOIN us_household_income_statistics us
    ON u.id = us.id
WHERE Mean <> 0
GROUP BY u.State_Name
ORDER BY 2 DESC
LIMIT 10;

-- Finding states with lowest median household income
SELECT u.State_Name, ROUND(AVG(Mean), 2), ROUND(AVG(Median), 2)
FROM us_household_income u
JOIN us_household_income_statistics us
    ON u.id = us.id
WHERE Mean <> 0
GROUP BY u.State_Name
ORDER BY 3
LIMIT 10;

-- Finding states with highest median household income
SELECT u.State_Name, ROUND(AVG(Mean), 2), ROUND(AVG(Median), 2)
FROM us_household_income u
JOIN us_household_income_statistics us
    ON u.id = us.id
WHERE Mean <> 0
GROUP BY u.State_Name
ORDER BY 3 DESC
LIMIT 10;
```

5. Income Levels in Several Categories

```sql
SELECT Type, COUNT(Type), ROUND(AVG(Mean), 2), ROUND(AVG(Median), 2)
FROM us_household_income u 
JOIN us_household_income_statistics us
    ON u.id = us.id
WHERE Mean <> 0
GROUP BY Type
ORDER BY 4 DESC;
```

6. Top 10 Cities with Highest Mean Incomes

```sql
SELECT u.State_Name, City, ROUND(AVG(Mean), 2)
FROM us_household_income u 
JOIN us_household_income_statistics us
    ON u.id = us.id
WHERE Mean <> 0
GROUP BY u.State_Name, City
ORDER BY 3 DESC
LIMIT 10;
```

## Usage

1. Clone the repository:

```sh
git clone https://github.com/harshshah0225/US-Household-Income.git
cd US-Household-Income
```

2. Load the data into your SQL database:

Import the CSV files **USHouseholdIncome.csv** and **USHouseholdIncome_Statistics.csv** into your SQL database.

3. Run the SQL script:

Execute the **USHouseholdIncome.sql** script in your SQL database to perform data cleaning and analysis.

## Conclusion

This project provided valuable insights into the distribution and trends of household income across different states and counties in the US. Through meticulous data cleaning and comprehensive exploratory data analysis, we identified key patterns and anomalies, such as the states with the highest and lowest mean and median household incomes. This analysis can inform policymakers and stakeholders about economic disparities and help target interventions more effectively.
