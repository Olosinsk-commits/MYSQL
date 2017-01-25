/*Olga Osinskaya*/
/*------------------------------------1-----------------------------------
Write a SELECT statement that returns these columns:
- The count of the number of orders in the Orders table
- The sum of the tax_amount columns in the Orders table
------------------------------------------------------------------------*/
SELECT 
    COUNT(order_id), SUM(tax_amount)
FROM
    orders;

/*------------------------------------2-----------------------------------
Write a SELECT statement that returns one row for each
category that has products with these columns:
-The category_name column from the Categories table 
-The count of the products in the Products table 
-The list price of the most expensive product in the Products table
Sort the result set so the category with the most products appears first.
------------------------------------------------------------------------*/

SELECT 
    c.category_name,
    COUNT(p.product_id) AS count,
    MAX(p.list_price)
FROM
    categories AS c
        INNER JOIN
    products p ON c.category_id = p.category_id
GROUP BY c.category_name
ORDER BY count DESC;

/*------------------------------------3-----------------------------------
Write a SELECT statement that returns one row for each customer that 
has orders with these columns:
-The email_address column from the Customers table
-The sum of the item price in the Order_Items table multiplied by the quantity in the Order_Items table
-The sum of the discount amount column in the Order_Items table multiplied by the quantity in the Order_Items table
Sort the result set in descending sequence by the item price total for each customer.
------------------------------------------------------------------------*/

SELECT 
    c.email_address,
    SUM(o.item_price) * COUNT(o.item_id) AS first_sum_by_count,
    SUM(o.discount_amount) * COUNT(o.item_id) AS second_sum_by_count
FROM
    customers AS c
        INNER JOIN
    orders AS ord ON c.customer_id = ord.customer_id
        INNER JOIN
    order_items AS o ON o.order_id = ord.order_id
GROUP BY c.customer_id
ORDER BY SUM(o.item_price) DESC;

/*------------------------------------4-----------------------------------
Write a SELECT statement that returns one row for each customer that has 
orders with these columns:
-The email_address from the Customers table
-A count of the number of orders
-The total amount for each order (Hint: First, subtract the discount amount from the price. 
Then, multiply by the quantity.)
Return only those rows where the customer has more than 1 order. 
Sort the result set in descending sequence by the sum of the line item amounts.
------------------------------------------------------------------------*/
SELECT 
    c.email_address,
    COUNT(o.order_id) AS count,
    SUM(o.item_price - o.discount_amount) * COUNT(o.order_id) AS total_amount
FROM
    customers AS c
        INNER JOIN
    orders AS ord ON c.customer_id = ord.customer_id
        INNER JOIN
    order_items AS o ON o.order_id = ord.order_id
GROUP BY c.customer_id
HAVING count > 1
ORDER BY total_amount DESC;

/*------------------------------------5-----------------------------------
Modify the solution to exercise 4 so it only counts and totals line items that have an item_price
value that’s greater than 400.
------------------------------------------------------------------------*/
SELECT 
    c.email_address,
    COUNT(o.order_id) AS count,
    SUM(o.item_price - o.discount_amount) * COUNT(o.order_id) AS total_amount
FROM
    customers AS c
        INNER JOIN
    orders AS ord ON c.customer_id = ord.customer_id
        INNER JOIN
    order_items AS o ON o.order_id = ord.order_id 
where o.item_price>400
GROUP BY c.customer_id
HAVING count > 1
ORDER BY total_amount DESC;

/*------------------------------------6-----------------------------------
Write a SELECT statement that answers this question: What is the total amount
ordered for each product? Return these columns:
-The product name from the Products table
-The total amount for each product in the Order_Items (Hint: You can calculate the total amount by
subtracting the discount amount from the item price and then multiplying it
by the quantity) 
Use the WITH ROLLUP operator to include a row that gives the grand total.
------------------------------------------------------------------------*/

SELECT 
    COALESCE(p.product_name, 'Grand Total') AS 'Product Name',
    SUM(o.item_price - o.discount_amount) * COUNT(o.item_id) as 'Total Amount'
FROM
    products p
        LEFT JOIN
    order_items o ON p.product_id = o.product_id
GROUP BY p.product_name WITH ROLLUP;

/*------------------------------------7-----------------------------------
Write a SELECT statement that answers this question: Which customers have ordered more than
one product? Return these columns:
-The email address from the Customers table
-The count of distinct products from the customer’s orders
------------------------------------------------------------------------*/
SELECT 
    c.email_address, COUNT(DISTINCT oi.product_id) AS count
FROM
    customers AS c
        INNER JOIN
    orders o ON c.customer_id = o.customer_id
        INNER JOIN
    order_items oi ON o.order_id = oi.order_id
GROUP BY c.email_address
HAVING count > 1;
