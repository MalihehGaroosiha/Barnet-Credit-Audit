


-- Use the target database
USE bank;

-- Step 1: Preview merged data from all sources
SELECT * FROM PCard1
UNION
SELECT * FROM PCard3
UNION
SELECT Service_Area, Account_Description, Creditor, JV_Date AS Journal_Date, JV_Reference AS Journal_Reference, JV_Value AS Total
FROM PCard2;

-- Step 2: Create unified table for combined data
CREATE TABLE PCard (
    Service_Area NVARCHAR(50),
    Account_Description NVARCHAR(50),
    Creditor NVARCHAR(50),
    Journal_Date DATE,
    Journal_Reference SMALLINT,
    Total FLOAT
);

-- Step 3: Insert merged data
INSERT INTO PCard(Service_Area, Account_Description, Creditor, Journal_Date, Journal_Reference, Total)
SELECT Service_Area, Account_Description, Creditor, Journal_Date, Journal_Reference, Total FROM PCard1
UNION
SELECT Service_Area, Account_Description, Creditor, Journal_Date, Journal_Reference, Total FROM PCard3
UNION
SELECT Service_Area, Account_Description, Creditor, JV_Date, JV_Reference, JV_Value FROM PCard2;

-- Step 4: Remove duplicates and NULL rows
SELECT DISTINCT * INTO PCard_copy FROM PCard;

-- Step 5: Create clean, standardized view with valid data only
CREATE VIEW PCard_Cleaned AS
SELECT
    UPPER(LTRIM(RTRIM(Service_Area))) AS Service_Area,
    UPPER(LTRIM(RTRIM(Account_Description))) AS Account_Description,
    UPPER(LTRIM(RTRIM(Creditor))) AS Creditor,
    CONVERT(DATE, Journal_Date) AS Journal_Date,
    Journal_Reference,
    Total
FROM PCard_copy
WHERE
    Service_Area IS NOT NULL
    AND Account_Description IS NOT NULL
    AND Creditor IS NOT NULL
    AND Journal_Date IS NOT NULL
    AND Journal_Reference IS NOT NULL
    AND Total IS NOT NULL;

-- Step 6: Validate cleaned data order by Journal Reference
SELECT * FROM PCard_Cleaned
ORDER BY Journal_Reference;

-- Step 7: Aggregate positive transactions with detailed statistics by Service Area and Month to identify trends and outliers
SELECT
    Service_Area,
    YEAR(Journal_Date) AS Year,
    MONTH(Journal_Date) AS Month,
    COUNT(*) AS Transaction_Count,
    ROUND(SUM(Total), 2) AS Sum_Transaction,
    ROUND(AVG(Total), 2) AS Avg_Transaction,
    ROUND(MAX(Total), 2) AS Maximum_Transaction,
    ROUND(MIN(Total), 2) AS Minimum_Transaction,
    ROUND(MAX(Total) - MIN(Total), 2) AS Transaction_Range
FROM PCard_Cleaned
WHERE Total > 0
GROUP BY Service_Area, YEAR(Journal_Date), MONTH(Journal_Date)
ORDER BY Service_Area, Year, Month;

-- Step 8: Create table for refund transactions for further analysis
SELECT * INTO Refunds FROM PCard_Cleaned WHERE Total < 0;

-- Step 9: Analyze refunds by Service Area and Month using window functions
SELECT
    Service_Area,
    YEAR(Journal_Date) AS Year,
    MONTH(Journal_Date) AS Month,
    Total AS Refund,
    COUNT(*) OVER (PARTITION BY Service_Area, YEAR(Journal_Date), MONTH(Journal_Date)) AS RefundCountByServiceMonth,
    ROUND(SUM(Total) OVER (PARTITION BY Service_Area, YEAR(Journal_Date), MONTH(Journal_Date)), 2) AS RefundTotalByServiceMonth
FROM PCard_Cleaned
WHERE Total < 0
ORDER BY RefundCountByServiceMonth DESC, Service_Area, Year, Month;

-- Step 10: Generate multi-dimensional aggregate report with subtotals and grand totals using GROUP BY CUBE
SELECT
    Service_Area,
    Account_Description,
    ROUND(SUM(Total), 2) AS Total_Sum
FROM PCard_Cleaned
WHERE Total > 0
GROUP BY CUBE(Service_Area, Account_Description)
ORDER BY Service_Area, Account_Description;
