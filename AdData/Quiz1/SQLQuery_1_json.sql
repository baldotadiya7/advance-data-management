SELECT
YEAR(salorhead.OrderDate) AS Year,
(
SELECT TOP 2
         s.BusinessEntityID,
           Person.Person.LastName,
           Person.Person.FirstName,
(
SELECT TOP 2
salorhead.SalesOrderID,
CAST(salorhead.TotalDue AS INT) AS OrderAmount
FROM
sales.salorhead AS salorhead
INNER JOIN sales.SalesPerson AS s ON salorhead.SalesPersonID = s.BusinessEntityID
WHERE
YEAR(salorhead.OrderDate) = YEAR(salorhead.OrderDate) AND
s.BusinessEntityID = salorhead.SalesPersonID
ORDER BY salorhead.TotalDue DESC,
              salorhead.SalesOrderID ASC
FOR JSON PATH
)
 AS Top2Orders
FROM
sales.SalesOrderDetail AS SalesOrderDetail
        INNER JOIN sales.salorhead AS salorhead ON SalesOrderDetail.SalesOrderID = salorhead.SalesOrderID
    INNER JOIN sales.SalesPerson AS s ON salorhead.SalesPersonID = s.BusinessEntityID
     INNER JOIN Person.Person ON s.BusinessEntityID = Person.Person.BusinessEntityID
WHERE


YEAR(salorhead.OrderDate) = YEAR(salorhead.OrderDate)
GROUP BY    s.BusinessEntityID,
Person.Person.LastName,
Person.Person.FirstName
ORDER BY

s.BusinessEntityID ASC
FOR JSON PATH, INCLUDE_NULL_VALUES
) AS Top2SalesPersons
FROM
sales.salorhead AS salorhead
FOR JSON PATH