
-- To avoid any errors, check missing value / null value 
SELECT * FROM ['Corona Virus Dataset$'] ORDER BY Date

-- Write a code to check NULL values
SELECT * from ['Corona Virus Dataset$'] WHERE Province is null
SELECT * from ['Corona Virus Dataset$'] WHERE [Country/Region] is null
SELECT * from ['Corona Virus Dataset$'] WHERE Latitude is null
SELECT * from ['Corona Virus Dataset$'] WHERE Longitude is null
SELECT * from ['Corona Virus Dataset$'] WHERE Date is null
SELECT * from ['Corona Virus Dataset$'] WHERE Confirmed is null
SELECT * from ['Corona Virus Dataset$'] WHERE Deaths is null
SELECT * from ['Corona Virus Dataset$'] WHERE Recovered is null


-- If NULL values are present, update them with zeros for all columns. 
UPDATE ['Corona Virus Dataset$'] SET Province = 0 WHERE Province is null
UPDATE ['Corona Virus Dataset$'] SET [Country/Region] = 0 WHERE [Country/Region] is null
UPDATE ['Corona Virus Dataset$'] SET Latitude = 0 WHERE Latitude is null
UPDATE ['Corona Virus Dataset$'] SET Longitude = 0 WHERE Longitude is null
UPDATE ['Corona Virus Dataset$'] SET Date = 0 WHERE Date is null
UPDATE ['Corona Virus Dataset$'] SET Confirmed = 0 WHERE Confirmed is null
UPDATE ['Corona Virus Dataset$'] SET Deaths = 0 WHERE Deaths is null
UPDATE ['Corona Virus Dataset$'] SET Recovered = 0 WHERE Recovered is null 

-- check total number of rows
SELECT COUNT(*) as row_count FROM ['Corona Virus Dataset$'] 

-- Check what is start_date and end_date
SELECT DISTINCT CAST(Date as date) AS start_date_and_end_date 
FROM ['Corona Virus Dataset$'] 
WHERE Date = (SELECT MIN(Date) FROM ['Corona Virus Dataset$']) 
OR Date = (SELECT MAX(Date) FROM ['Corona Virus Dataset$'])

-- Number of month present in dataset
SELECT COUNT(DISTINCT (MONTH(Date))) AS Number_of_Months 
FROM ['Corona Virus Dataset$'] 

-- Find monthly average for confirmed, deaths, recovered
SELECT 
MONTH(Date) as month_number,
AVG(confirmed) as confirmed_avg, 
AVG(deaths) as deaths_avg, 
AVG(recovered) as recovered_avg 
FROM ['Corona Virus Dataset$'] 
GROUP BY MONTH(Date)

-- Find most frequent value for confirmed, deaths, recovered each month

--Confirmed
WITH monthly_confirmed AS
(SELECT SUM(confirmed) AS total_confirmed, MONTH(Date) AS month_number
FROM ['Corona Virus Dataset$']
GROUP BY MONTH(Date))
SELECT TOP 1 total_confirmed, COUNT(total_confirmed) as Freq 
FROM monthly_confirmed
GROUP BY total_confirmed
ORDER BY Freq DESC, total_confirmed DESC


--Deaths 
WITH monthly_deaths AS
(SELECT SUM(deaths) AS total_deaths, MONTH(Date) AS month_number
FROM ['Corona Virus Dataset$']
GROUP BY MONTH(Date))
SELECT TOP 1 total_deaths, COUNT(total_deaths) as Freq 
FROM monthly_deaths
GROUP BY total_deaths
ORDER BY Freq DESC, total_deaths DESC

--Recovered
WITH monthly_recovered AS
(SELECT SUM(recovered) AS total_recovered, MONTH(Date) AS month_number
FROM ['Corona Virus Dataset$']
GROUP BY MONTH(Date))
SELECT TOP 1 total_recovered, COUNT(total_recovered) as Freq 
FROM monthly_recovered
GROUP BY total_recovered
ORDER BY Freq DESC, total_recovered DESC


-- Find minimum values for confirmed, deaths, recovered per year
SELECT 
YEAR(Date) AS Year,
MIN(confirmed) AS MIN_Confirmed,
MIN(deaths) AS MIN_Deaths,
MIN(recovered) AS MIN_Recovered
FROM ['Corona Virus Dataset$']
GROUP BY YEAR(Date)


-- Find maximum values of confirmed, deaths, recovered per year
SELECT 
YEAR(Date) AS Year,
MAX(confirmed) AS MIN_Confirmed,
MAX(deaths) AS MIN_Deaths,
MAX(recovered) AS MIN_Recovered
FROM ['Corona Virus Dataset$']
GROUP BY YEAR(Date)

-- The total number of case of confirmed, deaths, recovered each month
SELECT 
MONTH(date) AS Month_Date,
SUM(confirmed) AS Total_Confirmed,
SUM(deaths) AS Total_Deaths,
SUM(recovered) AS Total_Recovered
FROM ['Corona Virus Dataset$']
GROUP BY MONTH(date)

-- Check how corona virus spread out with respect to confirmed case
--      (Eg.: total confirmed cases, their average, variance & STDEV )
SELECT 
SUM(confirmed) AS TotalCases,
AVG(confirmed) AS AvgCases,
VAR(confirmed) AS Variance,
STDEV(confirmed) AS StdDeviation
FROM ['Corona Virus Dataset$']

-- Check how corona virus spread out with respect to death case per month
--      (Eg.: total confirmed cases, their average, variance & STDEV )
SELECT 
MONTH(Date) AS Month, 
SUM(Deaths) AS Total,
VAR(Deaths) AS Variance,
STDEV(Deaths) AS StdDeviation,
AVG(Deaths) AS AvgDeaths
FROM ['Corona Virus Dataset$']
GROUP BY MONTH(Date)
ORDER BY MONTH(Date)

-- Check how corona virus spread out with respect to recovered case
--      (Eg.: total confirmed cases, their average, variance & STDEV )
SELECT
SUM(Recovered) AS totalRecovered,
AVG(Recovered) AS AvgRecovered,
VAR(Recovered) AS Variance,
STDEV(Recovered) AS StdDeviation
FROM ['Corona Virus Dataset$']


-- Find Country having highest number of the Confirmed case
WITH total_confirmed AS
(SELECT [Country/Region], SUM(Confirmed) AS Total
FROM ['Corona Virus Dataset$'] 
GROUP BY [Country/Region])
SELECT TOP 1 [Country/Region]
FROM total_confirmed
ORDER BY Total DESC

-- Find Country having lowest number of the death case
WITH death_counts AS (
    SELECT [Country/Region], SUM(deaths) AS TotalDeaths
    FROM ['Corona Virus Dataset$']
    GROUP BY [Country/Region]
),
min_deaths AS (
    SELECT MIN(TotalDeaths) AS MinDeaths
    FROM death_counts
)
SELECT dc.[Country/Region], dc.TotalDeaths
FROM death_counts dc
JOIN min_deaths md
ON dc.TotalDeaths = md.MinDeaths;

-- Find top 5 countries having highest recovered case
WITH totalRecovered AS
(SELECT [Country/Region], SUM(Recovered) as Total
FROM ['Corona Virus Dataset$']
GROUP BY [Country/Region])
SELECT TOP 5 [Country/Region]
FROM totalRecovered
ORDER BY Total DESC

