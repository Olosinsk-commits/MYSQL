/*Olga Osinskaya*/
/*------------------------------------1-----------------------------------
Write a script that creates and calls a stored procedure named test. 
This stored procedure should declare a variable and set it to the 
count of all products in the Products table. If the count is 
greater than or equal to 7, the stored procedure should display 
a message that says, “The number of products is greater than 
or equal to 7”. Otherwise, it should say, 
“The number of products is less than 7”.
------------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS test;

DELIMITER //
create procedure test()
BEGIN
DECLARE count_of_7 DECIMAL(10,2);

select count(product_id) 
into count_of_7
from products;
IF count_of_7 >= 7 THEN
	SELECT 'The number of products is greater than or equal to 7' AS message;
ELSE
	SELECT 'The number of products is less than 7' AS message;
end if;
end//

call test();

/*------------------------------------2-----------------------------------
Write a script that creates and calls a stored procedure named test. 
This stored procedure should use two variables to store
(1) the count of all of the products in the Products table and 
(2) the average list price for those products. 
If the product count is greater than or 
equal to 7, the stored procedure should display a result set that 
displays the values of both variables. Otherwise, the procedure 
should display a result set that displays a message that says, 
“The number of products is less than 7”.
------------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS test;

DELIMITER //
create procedure test()
BEGIN
DECLARE count_of_7 DECIMAL(10,2);
DECLARE average_price int;

select count(product_id),avg(list_price) 
into count_of_7,average_price
from products;
IF count_of_7 >= 7 THEN
	SELECT concat('The number of products is greater than or equal to 7, ',' Average price is ', average_price)
    AS message;
    
ELSE
	SELECT 'The number of products is less than 7' AS message;
end if;
end//

call test();

/*------------------------------------3-----------------------------------
Write a script that creates and calls a stored procedure named test. 
This procedure should calculate the common factors between 10 and 20. 
To find a common factor, you can use the modulo operator (%) 
to check whether a number can be evenly divided into both numbers. 
Then, this procedure should display a string that displays the common factors like this:
Common factors of 10 and 20: 1 2 5
------------------------------------------------------------------------*/

DROP PROCEDURE IF EXISTS test;

DELIMITER //
create procedure test()
BEGIN
DECLARE fact_var1 int;
DECLARE fact_var2 int;
DECLARE i int;
DECLARE common_var VARCHAR(400) DEFAULT 'Common factors of 10 and 20: ';

set fact_var1=10;
set fact_var2=20;
SET i = 1;

  WHILE (i < fact_var1) DO
    
      IF (fact_var1%i = 0 and fact_var2%i=0) THEN
            SET common_var = CONCAT(common_var, i, ' ');
        END IF;
        set i=i+1;
  END WHILE;
  select common_var as message;
end//

call test();
/*------------------------------------4-----------------------------------
Write a script that creates and calls a stored procedure named test. 
This stored procedure should create a cursor for a result set that consists 
of the product_name and list_price columns for each
product with a list price that’s greater than $700. The rows in this 
result set should be sorted in
descending sequence by list price. Then, the procedure should display a 
string variable that includes the product_name and list price for each 
product so it looks something like this:
"Gibson SG","2517.00"|"Gibson Les Paul","1199.00"|
Here, each value is enclosed in double quotes ("), each column is 
separated by a comma (,) and each row is separated by a pipe character (|).
------------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS test;

DELIMITER //

CREATE PROCEDURE test()
BEGIN
DECLARE product_name_var VARCHAR(50);
DECLARE list_price_var DECIMAL(9,2);
DECLARE row_not_found TINYINT DEFAULT FALSE;
DECLARE s_var VARCHAR(400) DEFAULT '';

DECLARE invoice_cursor CURSOR for
	SELECT 
		product_name,
		list_price
	FROM
		products
	WHERE
		list_price > 700
	ORDER BY list_price DESC;
    
DECLARE CONTINUE HANDLER FOR NOT FOUND
	SET row_not_found = TRUE;

OPEN invoice_cursor;

FETCH invoice_cursor INTO product_name_var, list_price_var;
WHILE row_not_found = FALSE DO
    SET s_var = CONCAT(s_var,' " ', product_name_var,' " , " ',list_price_var,'" |');
	FETCH invoice_cursor INTO product_name_var, list_price_var;
END WHILE;

SELECT s_var AS message;
END//

call test();

/*------------------------------------5-----------------------------------
Write a script that creates and calls a stored procedure named test. This procedure
should attempt to insert a new category named “Guitars” into the Categories table. If
the insert is successful, the procedure should display this message:
1 row was inserted.
If the update is unsuccessful, the procedure should display this message:
Row was not inserted - duplicate entry.
------------------------------------------------------------------------*/
use my_guitar_shop;
DROP PROCEDURE IF EXISTS test;

DELIMITER //
CREATE PROCEDURE test()
BEGIN
DECLARE duplicate_entry_for_key TINYINT DEFAULT FALSE;
BEGIN
DECLARE EXIT HANDLER FOR 1062
SET duplicate_entry_for_key = TRUE;
INSERT INTO categories VALUES (default, 'Guitars');
SELECT '1 row was inserted.' AS message;
END;
IF duplicate_entry_for_key = TRUE THEN
SELECT 'Row was not inserted - duplicate entry.' AS message;
END IF;
END//

call test();





