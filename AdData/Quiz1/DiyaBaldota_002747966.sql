SELECT
YEAR(SOH.OrderDate) AS Year,
(
SELECT TOP 2
SUM(SOD.LineTotal) AS TotalSalesAmount,
SP.BusinessEntityID,
Person.Person.FirstName,
Person.Person.LastName,
(
SELECT TOP 2
SOH.SalesOrderID,
SOH.TotalDue AS OrderAmount
FROM
Sales.SalesOrderHeader AS SOH
INNER JOIN Sales.SalesPerson AS SP ON SOH.SalesPersonID = SP.BusinessEntityID
WHERE
YEAR(SOH.OrderDate) = YEAR(SOH.OrderDate) AND
SP.BusinessEntityID = SOH.SalesPersonID
ORDER BY
SOH.TotalDue DESC,
SOH.SalesOrderID ASC
FOR JSON PATH
) AS Top2Orders
FROM
Sales.SalesOrderDetail AS SOD
INNER JOIN Sales.SalesOrderHeader AS SOH ON SOD.SalesOrderID = SOH.SalesOrderID
INNER JOIN Sales.SalesPerson AS SP ON SOH.SalesPersonID = SP.BusinessEntityID
INNER JOIN Person.Person ON SP.BusinessEntityID = Person.Person.BusinessEntityID
WHERE
YEAR(SOH.OrderDate) = YEAR(SOH.OrderDate)
GROUP BY
SP.BusinessEntityID,
Person.Person.FirstName,
Person.Person.LastName
ORDER BY
TotalSalesAmount DESC,
SP.BusinessEntityID ASC
FOR JSON PATH, INCLUDE_NULL_VALUES
) AS Top2SalesPersons
FROM
Sales.SalesOrderHeader AS SOH
FOR JSON PATH



CREATE TABLE columnar.orders_by_territory (
    territory_id bigint,
    order_date date,
    order_value float,
    sales_order_id uuid,
    territory_name text,
    PRIMARY KEY (territory_id, order_date, order_value, sales_order_id)





    CREATE TABLE columnar.orders_by_customer (
    customer_id bigint,
    order_value float,
    order_date date,
    sales_order_id uuid,
    customer_name text,
    PRIMARY KEY (customer_id, order_value, order_date, sales_order_id)


SELECT territory_id, territory_name, order_date, order_value, sales_order_id FROM columnar.orders_by_territory
            ... WHERE territory_id = 1
            ... ORDER BY order_date DESC, order_value DESC, sales_order_id ASC;




SELECT customer_id, customer_name, order_value, order_date, sales_order_id FROM columnar.orders_by_customer
            ... WHERE customer_id = 12345
            ... ORDER BY order_value DESC, order_date DESC, sales_order_id ASC;

