/*Olga Osinskaya*/


/*------------------------------------1-----------------------------------
Write a SELECT statement that returns one column from the Customers table
named full_name that joins the last_name and first_name columns.
Format this column with the last name, a comma, a space, and
the first name like this:
Doe, John
Sort the result set by last name in ascending sequence.
Return only the customers whose last name begins with letters from M to Z.
------------------------------------------------------------------------*/

SELECT 
    CONCAT(last_name, ', ', first_name) AS full_name
FROM
    customers
WHERE
    last_name REGEXP '^[M-Z]'
ORDER BY last_name ASC;

/*------------------------------------2-----------------------------------
Write a SELECT statement that returns these columns from the Products table:

-product_name The product_name column
-list_price The list_price column 
-date_added The date_added column

Return only the rows with a
list price that’s greater than 500 and less than 2000. 
Sort the result set in descending sequence by the date_added column.
------------------------------------------------------------------------*/

SELECT 
    product_name AS 'The product name',
    list_price AS 'The list price',
    date_added AS 'The date added'
FROM
    products
WHERE
    (list_price > 500)
        AND (list_price < 2000)
ORDER BY date_added DESC;

/*------------------------------------3-----------------------------------
Write a SELECT statement that returns these column names and data from the Products table:

-product_name The product_name column
-list_price The list_price column
-discount_percent The discount_percent column
-discount_amount A column that’s calculated from the previous two columns 
-discount_price A column that’s calculated from the previous three columns

Roundthe discount_amount and discount_price columns to 2 decimal places. 
Sort the result set by discount price in descending sequence.
Use the LIMIT clause so the result set contains only the first 5 rows.
------------------------------------------------------------------------*/

SELECT 
    product_name AS 'The product name',
    list_price AS 'The list price',
    discount_percent AS 'The discount percent',
    ROUND(list_price * (discount_percent / 100), 2) AS 'The discount amount',
    ROUND(list_price - list_price * (discount_percent / 100),
            2) AS 'The discount price'
FROM
    products
ORDER BY (list_price - list_price * (discount_percent / 100)) DESC
LIMIT 5;


/*------------------------------------4-----------------------------------
Write a SELECT statement that returns these column names and data from the Order_Items table:

-item_id The item_id column
-item_price The item_price column
-discount_amount The discount_amount column
-quantity The quantity column
-price_total A column that’s calculated by multiplying the item price by the quantity
-discount_total A column that’s calculated by multiplying the discount amount by the quantity
-item_total A column that’s calculated by subtracting the discount
amount from the item price and then multiplying by the quantity.

Only return rows where the item_total is greater than 500.
Sort the result set by item total in descending sequence.
------------------------------------------------------------------------*/

SELECT 
    item_id AS 'The item id',
    item_price AS 'The item price',
    discount_amount AS 'The discount amount',
    quantity AS 'The quantity',
    (item_price * quantity) AS 'The price total',
    (discount_amount * quantity) AS 'The discount_total',
    ((item_price - discount_amount) * quantity) AS 'The item total'
FROM
    order_items
WHERE
    ((item_price - discount_amount) * quantity) > 500
ORDER BY ((item_price - discount_amount) * quantity) DESC;

/*------------------------------------5-----------------------------------
Write a SELECT statement that returns these columns from the Orders table:
-order_id The order_id column
-order_date The order_date column
-ship_date The ship_date column
Return only the rows where the ship_date column contains a null value.
------------------------------------------------------------------------*/

SELECT 
    order_id AS 'The order id',
    order_date AS 'The order date',
    ship_date AS 'The ship date'
FROM
    orders
WHERE
    ship_date IS NULL;


/*------------------------------------6-----------------------------------
Write a SELECT statement without a FROM clause that uses the NOW function to create a row with these columns:

-today_unformatted The NOW function unformatted
-today_formatted The NOW function in this format:DD-Mon-YYYY

This displays a number for the day, an abbreviation for the month, and a four-digit year.
------------------------------------------------------------------------*/

SELECT 
    NOW() AS 'today_unformatted',
    DATE_FORMAT(NOW(), '%d-%b-%Y') AS 'today_formatted';

/*------------------------------------7-----------------------------------
Write a SELECT statement without a FROM clause that creates a row with these columns:

-price 100 (dollars)
-tax_rate .07 (7 percent)
-tax_amount The price multiplied by the tax
-total The price plus the tax 

To calculate the fourth column, add the expressions you used for the first and third
------------------------------------------------------------------------*/

SELECT 
    100 AS price,
    0.07 AS tax_rate,
    100 * 0.07 AS tax_amount,
    100 + 0.07 * 100 AS total;
