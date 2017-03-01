/*Olga Osinskaya*/
/*------------------------------------1-----------------------------------
Create a view named customer_addresses that shows the shipping 
and billing addresses for each customer.
This view should return these columns from the Customers table: 
customer_id, 
email_address, 
last_name and first_name.
This view should return these columns from the Addresses table: 
bill_line1, 
bill_line2, 
bill_city, 
bill_state, 
bill_zip, 
ship_line1, 
ship_line2, 
ship_city, 
ship_state, 
and ship_zip.
Hint: you will need to join to addresses table twice, once for 
billing address, and once for shipping address  (5 points)
------------------------------------------------------------------------*/
CREATE OR REPLACE VIEW customer_addresses AS
    SELECT 
        c.customer_id,
        c.email_address,
        c.first_name,
        c.last_name,
        a1.line1 AS bill_line1,
        a1.line2 AS bill_line2,
        a1.city AS bill_city,
        a1.state AS bill_state,
        a1.zip_code AS bill_zip,
        a2.line1 AS ship_line1,
        a2.line2 AS ship_line2,
        a2.city AS ship_city,
        a2.state AS ship_state,
        a2.zip_code AS ship_zip
    FROM
        customers AS c
            INNER JOIN
        addresses AS a1 ON c.customer_id = a1.customer_id
            AND c.billing_address_id = a1.address_id
            INNER JOIN
        addresses AS a2 ON c.customer_id = a2.customer_id
            AND c.shipping_address_id = a2.address_id;

/*------------------------------------2-----------------------------------
Write a SELECT statement that returns these columns from the 
customer_addresses view that you created in exercise 1: 
customer_id, last_name, first_name, bill_line1. (1 points)
------------------------------------------------------------------------*/
SELECT 
    customer_id, last_name, first_name, bill_line1
FROM
    customer_addresses;
/*------------------------------------3-----------------------------------
Write an UPDATE statement that updates the Customers table using 
the customer_addresses view
you created in exercise 1. Set the first line of the shipping address 
to “1990 Westwood Blvd.” for the
customer with an ID of 8. (2 points)
------------------------------------------------------------------------*/

UPDATE customer_addresses 
SET 
    ship_line1 = '1990 Westwood Blvd.'
WHERE
    customer_id = 8;
/*------------------------------------4-----------------------------------
Create a view named order_item_products that returns columns from 
the Orders, Order_Items, and Products tables.
This view should return these columns from the Orders table: 
order_id, order_date, tax_amount, and ship_date.
This view should return these columns from the Order_Items table: 
item_price, discount_amount, final_price (the discount amount 
subtracted from the item price), quantity, and item_total 
(the calculated total for the item).
This view should return the product_name column from the Products table. (6 points)
------------------------------------------------------------------------*/
CREATE OR REPLACE VIEW order_item_products AS
    SELECT 
        o.order_id,
        o.order_date,
        o.tax_amount,
        o.ship_date,
        oi.item_price,
        oi.discount_amount,
        (oi.item_price - oi.discount_amount) AS final_price,
        oi.quantity,
        (oi.item_price - oi.discount_amount) * oi.quantity as item_total,
        p.product_name
    FROM
        orders o
            INNER JOIN
        order_items oi ON o.order_id = oi.order_id
            INNER JOIN
        products p ON oi.product_id = p.product_id;
    
select * from   order_item_products;  

/*------------------------------------5-----------------------------------
Create a view named product_summary that uses the view you created in exercise 
4. This view should return summary information about each product.
Each row should include product_name, order_count (the number of 
times the product has been ordered) and order_total (the total 
sales for the product). (5 points)  
------------------------------------------------------------------------*/
CREATE OR REPLACE VIEW product_summary AS
    SELECT 
        product_name,
        COUNT(order_id) AS order_count,
        SUM(item_total) AS order_total
    FROM
        order_item_products
    GROUP BY product_name;

select * from product_summary;
/*------------------------------------6-----------------------------------
Write a SELECT statement that uses the view that you created in 
exercise 5 to get the sum of the order_total for the five best 
selling products. Hint: use a sub-query.  (6 points)
------------------------------------------------------------------------*/

SELECT 
    SUM(order_total)
FROM
    (SELECT 
        order_total
    FROM
        product_summary
    ORDER BY order_total DESC
    LIMIT 5) AS t1; 




