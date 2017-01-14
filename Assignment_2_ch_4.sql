/*Olga Osinskaya*/


/*------------------------------------1-----------------------------------
Write a SELECT statement that inner joins the Categories
table to the Products table and returns these columns:
-category_name,
-product_name,
-list_price.
Sort the result set by category_name and then by product_name in ascending sequence.
------------------------------------------------------------------------*/
SELECT 
    c.category_name, p.product_name, p.list_price
FROM
    categories AS c
        INNER JOIN
    products AS p ON c.category_id = p.category_id
ORDER BY c.category_name, p.product_name ASC; 
/*------------------------------------2-----------------------------------
Write a SELECT statement that inner joins the Customers table to
the Addresses table and returns these columns:
-first_name,
-last_name, 
-line1, 
-city, 
-state, 
-zip_code.
Return one row for each address for the customer with an email address of allan.sherwood@yahoo.com.
------------------------------------------------------------------------*/
SELECT 
    c.first_name,
    c.last_name,
    a.line1,
    a.city,
    a.state,
    a.zip_code

FROM
    customers AS c
        INNER JOIN
    addresses AS a ON c.customer_id = a.customer_id
WHERE
    c.email_address = 'allan.sherwood@yahoo.com'; 

/*------------------------------------3-----------------------------------
Write a SELECT statement that inner joins the Customers table to
the Addresses table and returns these columns:
-first_name, 
-last_name, 
-line1, 
-city, 
-state,
-zip_code.
Return one row for each customer, but only return addresses that are the shipping address for a customer.
------------------------------------------------------------------------*/
SELECT 
    c.first_name,
    c.last_name,
    a.line1,
    a.city,
    a.state,
    a.zip_code
FROM
    customers AS c
        INNER JOIN
    addresses AS a ON c.customer_id = a.customer_id
WHERE
    (c.customer_id = a.customer_id)
        AND (c.shipping_address_id = a.address_id);

/*------------------------------------4-----------------------------------
Write a SELECT statement that inner joins the Customers,
Orders, Order_Items, and Products tables. This statement should return these columns:
-last_name, 
-first_name, 
-order_date, 
-product_name, 
-item_price, 
-discount_amount, 
-and quantity.
Use aliases for the tables. 
Sort the final result set by last_name, order_date, and product_name.
------------------------------------------------------------------------*/
SELECT 
    c.last_name,
    c.first_name,
    o.order_date,
    p.product_name,
    oi.item_price,
    oi.discount_amount,
    oi.quantity
FROM
    customers c
        INNER JOIN
    orders o ON c.customer_id = o.customer_id
        INNER JOIN
    order_items oi ON o.order_id = oi.order_id
        INNER JOIN
    products p ON oi.product_id = p.product_id
ORDER BY c.last_name , o.order_date , p.product_name;


/*------------------------------------5-----------------------------------
Write a SELECT statement that returns the product_name and list_price columns
from the Products table.
Return one row for each product that has the same list price as another product.
Hint: check that the product_id columns aren’t equal but the list_price columns are
equal.Sort the result set by product_name.
------------------------------------------------------------------------*/
SELECT 
    p1.product_name,
    p1.list_price
FROM
    products p1
        JOIN
    products p2 ON p1.product_id != p2.product_id
        AND p1.list_price = p2.list_price
ORDER BY p1.product_name ASC;

/*------------------------------------6-----------------------------------
Write a SELECT statement that returns these two columns:
-category_name The category_name column 
from the Categories table
-product_id The product_id column 
from the Products table
Return one row for each category that has never been used.
Hint: Use an outer join and only return rows where the product_id column contains a null value.
------------------------------------------------------------------------*/
SELECT 
    c.category_name, p.product_id
FROM
    categories c
        LEFT JOIN
    products p ON c.category_id = p.category_id
WHERE
    p.product_id IS NULL;

/*------------------------------------7-----------------------------------
Use the UNION operator to generate a result set consisting of three columns from the Orders table:
-ship_status A calculated column that contains a value of SHIPPED or NOT SHIPPED
-order_id The order_id column
-order_date The order_date column
If the order has a value in the ship_date column, the ship_status column should
contain a value of SHIPPED. Otherwise, it should contain a value of NOT SHIPPED.
Sort the final result set by order_date.
------------------------------------------------------------------------*/

SELECT 
    'SHIPPED' AS 'Ship Status',
    order_id AS 'The order id',
    order_date
FROM
    orders
WHERE
    ship_date IS NOT NULL 
UNION SELECT 
    'NOT SHIPPED' AS 'Ship Status',
    order_id AS 'The order id',
    order_date
FROM
    orders
WHERE
    ship_date IS NULL
ORDER BY order_date;