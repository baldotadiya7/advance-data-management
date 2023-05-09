SELECT TOP (100) [SalesOrderID]
      ,[RevisionNumber]
      ,[OrderDate]
      ,[DueDate]
      ,[ShipDate]
      ,[Status]
      ,[OnlineOrderFlag]
      ,[SalesOrderNumber]
      ,[PurchaseOrderNumber]
      ,[AccountNumber]
      ,[CustomerID]
      ,[SalesPersonID]
      ,[TerritoryID]
      ,[BillToAddressID]
      ,[ShipToAddressID]
      ,[ShipMethodID]
      ,[CreditCardID]
      ,[CreditCardApprovalCode]
      ,[CurrencyRateID]
      ,[SubTotal]
      ,[TaxAmt]
      ,[Freight]
      ,[TotalDue]
      ,[Comment]
      ,[rowguid]
      ,[ModifiedDate]
  FROM [AdventureWorks2017].[Sales].[SalesOrderHeader];

   WITH QuaSales AS (
    SELECT 
        DATEPART(YEAR, OrderDate) AS OrderYear,
        DATEPART(QUARTER, OrderDate) AS OrderQuarter,
        SUM(TotalDue) AS TSales
    FROM Sales.SalesOrderHeader
    GROUP BY DATEPART(YEAR, OrderDate), DATEPART(QUARTER, OrderDate)
),
AnnualSales AS (
    SELECT 
        OrderYear,
        SUM(TSales) AS YearlyTotal
    FROM QuaSales
    GROUP BY OrderYear
)
SELECT 
    RIGHT(CONCAT('          ',QuaSales.OrderYear),12) as OrderYear,
    RIGHT(CONCAT('          ',FORMAT(CONVERT(INT, SUM(CASE WHEN QuaSales.OrderQuarter = 1 THEN QuaSales.TSales ELSE NULL END)),'#,###')),12) AS '1st Quarter',
    RIGHT(CONCAT('          ',SUM(CASE WHEN QuaSales.OrderQuarter = 1 THEN QuaSales.TSales ELSE NULL END) / AnnualSales.YearlyTotal * 100),12) AS 'Annual%',
    RIGHT(CONCAT('          ',FORMAT(CONVERT(INT, SUM(CASE WHEN QuaSales.OrderQuarter = 1 THEN QuaSales.TSales ELSE NULL END) - LAG(SUM(CASE WHEN QuaSales.OrderQuarter = 4 THEN QuaSales.TSales ELSE NULL END), 1) OVER (ORDER BY QuaSales.OrderYear)),'#,###')),12) AS '4 to 1 Change',
    RIGHT(CONCAT('          ',FORMAT(CONVERT(INT, SUM(CASE WHEN QuaSales.OrderQuarter = 2 THEN QuaSales.TSales ELSE NULL END)),'#,###')),12) AS '2nd Quarter',
    RIGHT(CONCAT('          ',SUM(CASE WHEN QuaSales.OrderQuarter = 2 THEN QuaSales.TSales ELSE NULL END) / AnnualSales.YearlyTotal * 100),12) AS 'Annual%',
    RIGHT(CONCAT('          ',FORMAT(CONVERT(INT, SUM(CASE WHEN QuaSales.OrderQuarter = 2 THEN QuaSales.TSales ELSE NULL END) - SUM(CASE WHEN QuaSales.OrderQuarter = 1 THEN QuaSales.TSales ELSE NULL END)),'#,###')),12) AS '1 to 2 Change',
	RIGHT(CONCAT('          ',FORMAT(CONVERT(INT, SUM(CASE WHEN QuaSales.OrderQuarter = 3 THEN QuaSales.TSales ELSE NULL END)),'#,###')),12) AS '3rd Quarter',
	RIGHT(CONCAT('          ',SUM(CASE WHEN QuaSales.OrderQuarter = 3 THEN QuaSales.TSales ELSE NULL END) / AnnualSales.YearlyTotal * 100),12) AS 'Annual%',
	RIGHT(CONCAT('          ',FORMAT(CONVERT(INT, SUM(CASE WHEN QuaSales.OrderQuarter = 3 THEN QuaSales.TSales ELSE NULL END) - SUM(CASE WHEN QuaSales.OrderQuarter = 2 THEN QuaSales.TSales ELSE NULL END)),'#,###')),12) AS '2 to 3 Change',
	RIGHT(CONCAT('          ',FORMAT(CONVERT(INT, SUM(CASE WHEN QuaSales.OrderQuarter = 4 THEN QuaSales.TSales ELSE NULL END)),'#,###')),12) AS '4th Quarter',
	RIGHT(CONCAT('          ',SUM(CASE WHEN QuaSales.OrderQuarter = 4 THEN QuaSales.TSales ELSE NULL END) / AnnualSales.YearlyTotal * 100),12) AS 'Annual%',
	RIGHT(CONCAT('          ',FORMAT(CONVERT(INT, SUM(CASE WHEN QuaSales.OrderQuarter = 4 THEN QuaSales.TSales ELSE NULL END) - SUM(CASE WHEN QuaSales.OrderQuarter = 3 THEN QuaSales.TSales ELSE NULL END)),'#,###')),20) AS '3 to 4 Change',
    RIGHT(CONCAT('          ',FORMAT(CONVERT(INT, AnnualSales.YearlyTotal),'#,###')),12) as AnnualSales
FROM QuaSales
JOIN AnnualSales ON QuaSales.OrderYear = AnnualSales.OrderYear
GROUP BY QuaSales.OrderYear, AnnualSales.YearlyTotal
ORDER BY QuaSales.OrderYear;