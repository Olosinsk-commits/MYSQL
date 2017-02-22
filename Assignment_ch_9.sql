/*Olga Osinskaya*/
/*------------------------------------1-----------------------------------
Write a SELECT statement that returns these columns from the Products table:
-The list_price column
-The discount_percent column
-A column named discount_amount that uses the previous two columns to 
calculate the discount amount and uses the 
ROUND function to round the result so it has 2 decimal digits
------------------------------------------------------------------------*/
SELECT 
    list_price,
    discount_percent,
    ROUND(list_price * discount_percent / 100,2) AS discount_amount
FROM
    products;
/*------------------------------------2-----------------------------------
Write a SELECT statement that returns these columns from the Orders table:
-The order_date column -A column that uses the DATE_FORMAT function to return 
the four-digit year that’s stored in the order_date column

A column that uses the DATE_FORMAT function to return the order_date column 
in this format: Mon-DD-YYYY. 
In other words, use abbreviated months and separate each date component with dashes.

A column that uses the DATE_FORMAT function to return the order_date 
column with only the hours and minutes on a 12-hour clock with an am/pm indicator

A column that uses the DATE_FORMAT function to return the order_date 
column in this format: MM/DD/YY HH:mm. 

In other words, use two-digit months,days, and years and separate them by slashes. 

Use 2-digit hours and minutes on a 24-hour clock. 
And use leading zeros for all date/time components. 
------------------------------------------------------------------------*/
SELECT 
    DATE_FORMAT(order_date, '%Y') AS first_format,
    DATE_FORMAT(order_date, '%b-%e-%Y') AS second_format,
    DATE_FORMAT(order_date, '%l-%i-%p') AS third_format,
    DATE_FORMAT(order_date, '%m/%e/%y %H:%i') AS fourth_formay
FROM
    orders;
/*------------------------------------3-----------------------------------
Write a SELECT statement that returns these columns from the Orders table:
-The card_number column
-The length of the card_number column
-The last four digits of the card_number column
When you get that working right, add the columns that follow to the result set. 
This is more difficult because these columns require the use of functions within functions.
A column that displays the last four digits of the card_number 
column in this format: XXXX-XXXX-XXXX-1234. 
In other words, use Xs for the first 12 digits of the card number and 
actual numbers for the last four digits of the number.

A column that returns the third word in the product_name in the 
products table. If there is no third word, it should return an empty string. 
You can do this using IF and SUBSTRING_INDEX. Hint, this is complicated, 
the idea is that you write expression2 using SUBSTRING_INDEX that will 
return the 1st word if there is only one word, or the 2nd word if there are 2 words. 
------------------------------------------------------------------------*/
SELECT 
    o.card_number,
    LENGTH(o.card_number),
    RIGHT(o.card_number, 4) AS last_four_digits,
    INSERT(RIGHT(o.card_number, 4),
        1,
        0,
        'XXXX-XXXX-XXXX-') AS xx_format,
    IF((SUBSTRING_INDEX(SUBSTRING_INDEX(p.product_name, ' ', 2),
                ' ',
                - 1)) != SUBSTRING_INDEX(SUBSTRING_INDEX(p.product_name, ' ', 3),
                ' ',
                - 1),
        SUBSTRING_INDEX(SUBSTRING_INDEX(p.product_name, ' ', 3),
                ' ',
                - 1),
        '') AS third_name
FROM
    orders o
        INNER JOIN
    order_items oi ON o.order_id = oi.order_id
        INNER JOIN
    products p ON p.product_id = oi.product_id
ORDER BY o.card_number;

/*------------------------------------4-----------------------------------
Write a SELECT statement that returns these columns from the Orders table:
-The order_id column 
-The order_date column in format yyyy-mm-dd
-A column named approx_ship_date that’s calculated by adding 2 days to the
order_date column in format yyyy-mm-dd 
The ship_date column 
A column named days_to_ship that shows the number of days between the order date
and the ship date
When you have this working, 
add a WHERE clause that retrieves just the orders for March 2015. 
------------------------------------------------------------------------*/

SELECT 
    order_id,
    DATE_FORMAT(order_date, '%Y-%m-%e') AS order_date,
    DATE_FORMAT(DATE_ADD(order_date, INTERVAL 2 DAY),
            '%Y-%m-%e') AS approx_ship_date,
    ship_date,
    DATEDIFF(ship_date, order_date) AS days_to_ship
FROM
    orders
WHERE
EXTRACT(MONTH FROM order_date) = 3;
