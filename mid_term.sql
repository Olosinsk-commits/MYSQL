/*Olga Osinskaya*/

/*------------------------------------1-----------------------------------
Find all Motorcycles that do not have the scale numbers 1:18.
Include Bike name, scale, and description into the result.
Name the columns as in the screenshot below.
Sort ascending by Scale and then Bike Name. Query returns 11 rows. Hint:
all information is in the the table products. No join is required
------------------------------------------------------------------------*/
SELECT 
    productName AS 'Bike Name',
    productScale AS 'Scale',
    productDescription AS 'Description'
FROM
    products
WHERE
    productScale != '1:18'
        AND productLine = 'Motorcycles'
ORDER BY productScale , productName ASC;

/*------------------------------------2-----------------------------------
Find 
-first name, 
-last name and 
-e-mails of all sales representatives (as a job title)
responsible for territories “Japan”, ”EMEA”, and “APAC”.
Include country, city and territory into the resulting table. 
Sort by territory in ascending, then by country in descending, 
then by city in ascending order, then by last name ascending, and 
then by first name ascending. Returns 11 rows. See screenshot below. 
Hint: you will need to join two tables
------------------------------------------------------------------------*/
SELECT 
    e.firstName,
    e.lastName,
    e.email,
    o.country,
    o.city,
    o.territory
FROM
    employees as e
        INNER JOIN
    offices as o ON e.officeCode = o.officeCode
WHERE
    o.territory IN ('Japan' , 'EMEA', 'APAC')
ORDER BY o.territory ASC , o.country DESC , o.city ASC , e.lastName ASC , e.firstName ASC;
/*------------------------------------3-----------------------------------
Find US and German customers who have not placed any orders. Retrieve
customer number and customer name. Sort by customer name. Returns 11 rows.
Hint: use an outer join. 
------------------------------------------------------------------------*/

SELECT DISTINCT
    c.customerName, c.customerNumber
FROM
    customers AS c
        LEFT OUTER JOIN
    orders AS o ON c.customerNumber = o.customerNumber
WHERE
    c.country IN ('Germany' , 'USA')
        AND c.customerNumber NOT IN (SELECT 
            customerNumber
        FROM
            orders)
ORDER BY c.customerName;

/*------------------------------------4-----------------------------------
Find 
-customer names and 
-order details of all the non-US and non-Australia
customers whose order status is not ‘shipped’ and not ‘resolved’. 
Include the following columns: customerName, country, status, productName, 
and quantityOrdered. 
Sort by country then productName. Returns 104 rows.  
See screenshot below. Hint: you will need to join 4 tables. 

------------------------------------------------------------------------*/
SELECT 
    c.customerName,
    c.country,
    o.status,
    p.productName,
    od.quantityOrdered
FROM
    customers AS c
        INNER JOIN
    orders o ON c.customerNumber = o.customerNumber
        INNER JOIN
    orderdetails od ON o.orderNumber = od.orderNumber
        INNER JOIN
    products p ON p.productCode = od.productCode
WHERE
    c.country NOT IN ('USA' , 'Australia')
        AND o.status NOT IN ('Shipped' , 'Resolved')
ORDER BY c.country , p.productName;

/*------------------------------------5-----------------------------------
Find out how many orders were made by customers with names starting from
letters ‘A’, ‘D’, ‘E’ or ‘L’. Retrieve only those who made at least 4 orders. 
The resulting table should have 2 columns: customerName and orderCount 
(number of orders made). 
Sort descending by orderCount. 
There must be 9 rows in the result. See screenshot below. 
Hint: You will need to use GROUP BY and HAVING
------------------------------------------------------------------------*/
SELECT 
    c.customerName, COUNT(o.orderNumber) AS orderCount
FROM
    customers AS c
        INNER JOIN
    orders AS o ON c.customerNumber = o.customerNumber
WHERE
    customerName REGEXP '^[A,D,E,L]'
GROUP BY c.customerName
HAVING orderCount >= 4
order by orderCount desc; 

/*------------------------------------6-----------------------------------
Find out the total value customers in the USA ordered from the productLine
‘Classic Cars’. The total value is the sum quantityOrdered * priceEach. 
Order by total value descending. There must be 33 rows in the result. 
See screenshot below. Hint: use HAVING and WHERE, and join 4 tables
------------------------------------------------------------------------*/
SELECT 
    c.customerName,
    c.country,
    ROUND(SUM(od.quantityOrdered * priceEach), 2) as Total_Value
FROM
    customers AS c
        INNER JOIN
    orders o ON c.customerNumber = o.customerNumber
        INNER JOIN
    orderdetails od ON od.orderNumber = o.orderNumber
        INNER JOIN
    products p ON od.productCode = p.productCode
WHERE
    c.country = 'USA'
        AND p.productLine = 'Classic Cars'
        group by c.customerName
        order by Total_Value desc;


/*------------------------------------7-----------------------------------
For the two productLines 
i. ‘Classic Cars’ 
ii. ‘Vintage Cars’ 
find the COUNT(*) and the sum of 
the quantityOrdered * priceEach AS sumTotalPrice for
i. status = ‘Cancelled’ 
ii. status = ‘Disputed’ 
Order by sumTotalPrice descending. See the screenshot below. 
Hint: you will need to use UNION to combine the results from status = ‘Cancelled’ 
with the results from status = ‘Disputed’
------------------------------------------------------------------------*/

SELECT 
    p.productLine,
    o.status,
    COUNT(*),
    ROUND(SUM(od.quantityOrdered * od.priceEach),
            2) AS sumTotalPrice
FROM
    products p
        INNER JOIN
    orderdetails od ON p.productCode = od.productCode
        INNER JOIN
    orders o ON o.orderNumber = od.orderNumber
WHERE
    p.productLine IN ('Classic Cars' , 'Vintage Cars')
        AND o.status = 'Disputed'
GROUP BY p.productLine 
UNION SELECT 
    p.productLine,
    o.status,
    COUNT(*),
    ROUND(SUM(od.quantityOrdered * od.priceEach),
            2) AS sumTotalPrice
FROM
    products p
        INNER JOIN
    orderdetails od ON p.productCode = od.productCode
        INNER JOIN
    orders o ON o.orderNumber = od.orderNumber
WHERE
    p.productLine IN ('Classic Cars' , 'Vintage Cars')
        AND o.status = 'Cancelled'
GROUP BY p.productLine
ORDER BY sumTotalPrice DESC;


/*------------------------------------8-----------------------------------
Find all employees who work in ‘Paris’ office.
i. Write correlated subquery to get the results (10 points)
ii. Write the same query using JOIN (3 points) 
Return columns in the screenshot below. Hint: Returns 5 rows. 
------------------------------------------------------------------------*/
SELECT 
    CONCAT(firstName, ' ', lastName) AS full_name
FROM
    employees e
WHERE
    officeCode IN (SELECT 
            officeCode
        FROM
            offices
        WHERE
            city = 'Paris'); 
            
SELECT 
    CONCAT(e.firstName, ' ', e.lastName) AS full_name
FROM
    employees e
        INNER JOIN
    offices o ON e.officeCode = o.officeCode
WHERE
    o.city = 'Paris'    
            


