/*Olga Osinskaya*/
/*------------------------------------1-----------------------------------
Write a script that creates and calls a stored procedure named 
insert_category. First, code a statement that creates a procedure 
that adds a new row to the Categories table. 
To do that, this procedure should have one parameter for the category name.
Code at least two CALL statements that test this procedure. 
(Note that this table doesn’t allow duplicate category names.)
------------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS insert_category;

DELIMITER //

CREATE PROCEDURE insert_category
(
var_category_id INT,
var_category_name varchar(50)
)
BEGIN
DECLARE sql_error TINYINT DEFAULT FALSE;
DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
SET sql_error = TRUE;
START TRANSACTION;
UPDATE categories 
SET 
    category_id = var_category_id
WHERE
    category_name = var_category_name;
IF sql_error = FALSE THEN
COMMIT;
ELSE
ROLLBACK;
END IF;
END//


DELIMITER ;

-- Test fail: 
call insert_category (3,'Basses');

-- Test pass: 
call insert_category (4,'Piano');

/*------------------------------------2-----------------------------------
Write a script that creates and calls a stored function named 
discount_price that calculates the discount price of an item in the 
Order_Items table (discount amount subtracted from item price). 
To do that, this function should accept one parameter for the item ID, 
and it should return the value of the discount price for that item.
------------------------------------------------------------------------*/

DROP FUNCTION IF EXISTS discount_price;

DELIMITER //
CREATE FUNCTION discount_price
(
item_id_param INT
)
RETURNS DECIMAL(9,2)
BEGIN
DECLARE discount_price_var DECIMAL(9,2);
SELECT item_price-discount_amount
INTO discount_price_var
FROM order_items
WHERE item_id= item_id_param;
RETURN discount_price_var;
END//

DELIMITER ;

-- Test pass: 
SELECT 
    DISCOUNT_PRICE(item_id) AS discount_price
FROM
    order_items
WHERE
    item_id = 3;

/*------------------------------------3-----------------------------------
Write a script that creates and calls a stored function named item_total 
that calculates the total amount of an item in the Order_Items table 
(discount price multiplied by quantity). To do that, this function 
should accept one parameter for the item ID, it should use the 
discount_price function that you created in assignment 2, 
and it should return the value of the total for that item.
------------------------------------------------------------------------*/

DROP FUNCTION IF EXISTS item_total;

DELIMITER //
CREATE FUNCTION item_total
(
item_id_par INT
)
RETURNS DECIMAL(9,2)
BEGIN
DECLARE item_total_var DECIMAL(9,2);
SELECT discount_price(item_id)*quantity
INTO item_total_var
FROM order_items
WHERE  item_id= item_id_par;
RETURN item_total_var;
END//


DELIMITER ;

SELECT 
    item_id,
    DISCOUNT_PRICE(item_id) AS discount_price,
    ITEM_TOTAL(item_id) AS item_total
FROM
    order_items
WHERE
    item_id = 5;
/*------------------------------------4-----------------------------------
Write a script that creates and calls a stored procedure named 
insert_products that inserts a row into the Products table. 
This stored procedure should accept five parameters, one for 
each of these columns: category_id, product_code, product_name, 
list_price, and discount_percent.
This stored procedure should set the description column to 
an empty string, and it should set the date_added column to the current date.
If the value for the list_price column is a negative number, 
the stored procedure should signal state indicating that this 
column doesn’t accept negative numbers. 
Similarly, the procedure 
should signal state if the value for the discount_percent 
column is a negative number.
Code at least two CALL statements that test this procedure.
------------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS insert_products;

DELIMITER //

CREATE PROCEDURE insert_products
(
par_product_id int,
var_category_id INT,
var_product_code varchar(50),
var_product_name varchar(50),
par_description VARCHAR(200),
var_list_price DECIMAL(9,2),
var_discount_percent DECIMAL(9,2),
var_date_added_par date
)
BEGIN
 DECLARE var_description VARCHAR(200) default ' ';
 DECLARE var_date_added  date;
 DECLARE var_product_id int;
 
 -- Validate paramater values
 IF (var_list_price < 0 or var_discount_percent<0) THEN
 SIGNAL SQLSTATE '22003'
 SET MESSAGE_TEXT = 'The value must be a positive number.',
 MYSQL_ERRNO = 1264;
 END IF;
 
 -- Set default values for parameters
IF par_description IS NULL THEN
SELECT var_description INTO par_description
FROM products WHERE category_id = var_category_id;
END IF; 
 
IF par_product_id IS NULL THEN
SELECT DISTINCTROW var_product_id INTO par_product_id
FROM products WHERE category_id = var_category_id;
ELSE
SET var_product_id = par_product_id;
END IF;
 
IF var_date_added_par IS NULL THEN
SELECT curdate() INTO var_date_added
FROM products WHERE product_id = var_product_id;
END IF;

 
INSERT INTO products
 (product_id, category_id, product_code,
 product_name, description, list_price, discount_percent, date_added)
 VALUES (par_product_id, var_category_id, var_product_code, var_product_name,
 par_description, var_list_price, var_discount_percent,curdate() );
END//
DELIMITER ;

CALL insert_products(11, 2, 'sgp880', 'test','',
 -3.666, 15.00,'2012-03-18');
 
SELECT 
    *
FROM
    products;

DELETE FROM products 
WHERE
    product_id >= 11; 
    
/*------------------------------------5-----------------------------------
Write a script that creates and calls a stored procedure named 
update_product_discount that updates the discount_percent 
column in the Products table. This procedure should have 
one parameter for the product ID and another for the discount percent.
If the value for the discount_percent column is a negative number, 
the stored procedure should signal state indicating that the 
value for this column must be a positive number.
Code at least two CALL statements that test this procedure.
------------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS update_product_discount;

DELIMITER //
CREATE PROCEDURE update_product_discount(
var_product_id int,
var_discount_percent DECIMAL(9,2)
)
BEGIN
IF (var_discount_percent<0) THEN
 SIGNAL SQLSTATE '22003'
 SET MESSAGE_TEXT = 'The value must be a positive number.',
 MYSQL_ERRNO = 1264;
else
UPDATE products
SET  discount_percent= var_discount_percent
WHERE  product_id= var_product_id;
 END IF;
 
END//

DELIMITER ;

call update_product_discount(1,20.00);

select * from products;
