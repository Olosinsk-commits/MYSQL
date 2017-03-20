/*Olga Osinskaya*/
/*------------------------------------1-----------------------------------
List:
-Territory
-CustomerName 
-Status 
-orderDate
for orders with orderDate in the year 2004 and status = ‘Cancelled’.
Order by orderDate. Hints: Join 4 tables. 
Returns 4 rows.
------------------------------------------------------------------------*/
SELECT 
    of.territory, c.customerName, o.status, o.orderDate
FROM
    customers c
        INNER JOIN
    employees e ON e.employeeNumber = c.salesRepEmployeeNumber
        INNER JOIN
    offices of ON e.officeCode = of.officeCode
        INNER JOIN
    orders o ON o.customerNumber = c.customerNumber
WHERE
    EXTRACT(YEAR FROM o.orderDate) = 2004
        AND o.status = 'Cancelled'
ORDER BY o.orderDate;

/*------------------------------------2-----------------------------------
 List 
 employee name (firstName lastName) and 
 the count of orders with bad comments. 
 A bad comment contains "reevaluate" or "cancel" or "concerned".  
 Order by the number of bad comments descending, lastName 
 ascending and firstName ascending. Include employees that have no bad comments. 
 Hint: use REGEXP and an OUTER (LEFT) JOIN. Returns 15 rows, seen screenshot below.
------------------------------------------------------------------------*/
SELECT 
    CONCAT(e.firstName, ' ', e.lastName) AS employee_name,
    COUNT(o.comments) AS CountBadComment
FROM
    employees e
        LEFT OUTER JOIN
    customers c ON c.salesRepEmployeeNumber = e.employeeNumber
        LEFT OUTER JOIN
    orders o ON o.customerNumber = c.customerNumber
WHERE
    o.comments REGEXP 'cancel|concerned|reevaluate'
        AND o.comments IS NOT NULL
GROUP BY employee_name
ORDER BY CountBadComment DESC , e.lastName ASC , e.firstName;

/*------------------------------------3-----------------------------------
For each productLine, find the MAX of the SUM of quantityOrdered 
for each productCode. Hint: Write a subquery that has three columns; 
productLine, productCode, and the SUM of quantityOrdered. 
GROUP BY productCode in the subquery. Use this subquery in the 
FROM statement of an outer query. The outer query should 
GROUP BY productLine. See screenshot below.
------------------------------------------------------------------------*/

SELECT 
    t.productLine, MAX(t.maxsum)
FROM
    (SELECT 
        p.productLine,
            p.productCode,
            sum(o.quantityOrdered) AS maxsum
    FROM
        products p
    INNER JOIN orderdetails o ON p.productCode = o.productCode
    GROUP BY p.productCode) t
GROUP BY t.productLine;

/*------------------------------------4-----------------------------------
Create a view called TRAIN_ORDERS that shows all the orders that were 
placed in 2003 and included models of trains (from ‘Trains’ product line). 
Include orderNumber, orderDate, shippedDate, and customerNumber fields into the view. 
Run         
SELECT * FROM TRAIN_ORDERS ORDER BY orderNumber; 
on the view. 
------------------------------------------------------------------------*/

CREATE OR REPLACE VIEW TRAIN_ORDERS AS 
SELECT  distinct o.orderNumber,  o.orderDate,  o.shippedDate, o.customerNumber
FROM orders o
inner join orderdetails ord
on ord.orderNumber =o.orderNumber
inner join products p
on ord.productCode=p.productCode
where EXTRACT(YEAR FROM o.orderDate) = 2003
and p.productLine='Trains'; 

SELECT 
    *
FROM
    TRAIN_ORDERS
ORDER BY orderNumber; 

/*------------------------------------5-----------------------------------
HINT:
The next 3 questions are about writing stored procedures and functions. 
For each question, it is suggested that you to start with writing a query 
(or a set of queries) that perform the required actions. 
Then create the procedure or function, copy the query into procedure or 
function code, and modify the query (if necessary) to 
incorporate the procedure or function variables.

Create a procedure named DIRECT_SUBORDINATES that takes first and last 
name of an employee and returns all employees that reportsTo the 
given first and last name. The procedure should take two parameters of 
type VARCHAR(50). Call the procedure for the employee Mary Patterson. 
Hints: You will only need to use the employees table. 
------------------------------------------------------------------------*/

DROP PROCEDURE IF EXISTS DIRECT_SUBORDINATES;

DELIMITER //
create procedure DIRECT_SUBORDINATES(
par_firstName varchar(50),
par_lastName varchar(50)
)
BEGIN
select *
from employees
where reportsTo=(select employeeNumber from employees where par_firstName=firstName 
and  par_lastName=lastName);
end//

call DIRECT_SUBORDINATES('Mary', 'Patterson');

/*------------------------------------6-----------------------------------
Write a function named GET_NUMBER_ORDERS that calculates and returns 
the number of orders placed by a customer. 
The function takes customer number (INT) as a parameter and returns a 
value of type INT. Test your function: call the function to 
find the total amount of all orders placed by the customer 103.  
Include customer’s name into the output. See screenshot below for results. 
Hint: first write the query that finds the number of orders placed by 
customer 103, and then incorporate the query into a function 
(Replace the 103 with a parameter, of course).
------------------------------------------------------------------------*/
SELECT o.customerNumber,
    COUNT(o.orderNumber)
FROM
    orders o
WHERE
    o.customerNumber = 103;

DROP FUNCTION IF EXISTS GET_NUMBER_ORDERS;

DELIMITER //
CREATE FUNCTION GET_NUMBER_ORDERS
(
customerNumber_par INT
)
RETURNS int
BEGIN
DECLARE order_count int;
SELECT count(orderNumber)
INTO order_count
FROM orders 
WHERE  customerNumber= customerNumber_par;
RETURN order_count;
END//


DELIMITER ;

SELECT distinct
    o.customerNumber,
    c.customerName,
    GET_NUMBER_ORDERS(103) AS message
FROM
    orders o
        INNER JOIN
    customers c
    on c.customerNumber=o.customerNumber
    where o.customerNumber = 103;

/*------------------------------------7-----------------------------------
Create procedure called DELETE_ORDER that takes orderNumber as a parameter. 
The procedure should contain two SQL statements coded as a transaction. 
The statements should delete an order from the orders and orderdetails tables. 
If these statements execute successfully, commit, otherwise roll back. 
Delete orderNumber 10100 using the procedure you wrote. Use the queries 
below to check if the deletion happened. SELECT * FROM orders 
WHERE orderNumber = 10100; SELECT * FROM orderdetails 
WHERE orderNumber = 10100; CALL DELETE_ORDER(10100); 
SELECT * FROM orders WHERE orderNumber = 10100; 
SELECT * FROM orderdetails WHERE orderNumber = 10100; 
When you call DELETE_ORDER it will change the database. 
Re-run classicmodels.sql in order to restore the database to the original version.
------------------------------------------------------------------------*/
DROP PROCEDURE IF EXISTS DELETE_ORDER;
DELIMITER //
CREATE PROCEDURE DELETE_ORDER 
(
  param_orderNumber     INT
)
BEGIN  
  DECLARE sql_error TINYINT DEFAULT FALSE;
  DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
	SET sql_error = TRUE;
  START TRANSACTION;
  
  DELETE FROM orderdetails
	WHERE orderNumber = param_orderNumber;
	DELETE FROM orders
	WHERE orderNumber = param_orderNumber;
    
  IF sql_error = FALSE THEN
    COMMIT;
  ELSE
    ROLLBACK;
  END IF;
END//
DELIMITER ;

-- test before deletion
SELECT * FROM orders WHERE orderNumber = 10100; 
SELECT * FROM orderdetails WHERE orderNumber = 10100; 
-- call procedure 
CALL DELETE_ORDER(10100); 

-- test after deletion
SELECT * FROM orders WHERE orderNumber = 10100; 
SELECT * FROM orderdetails WHERE orderNumber = 10100;

/*------------------------------------8-----------------------------------
Write script that creates a database for a student enrollment application. 
Let’s call this database se. The database is used to keep track of
students who are enrolled in course in each quarter. 
You can use the following sample dataset to guide the design of your tables. 
You are asked to normalize the tables in the 3rd normal form. 
You will also need to identify primary keys and foreign keys for each table. 
Submit the script that creates the database se and the tables 
you designed along with the keys. Populate your tables with data 
from the following spreadsheet:
------------------------------------------------------------------------*/
drop database if exists se;
create database se;
use se;

DROP TABLE IF EXISTS students;
DROP TABLE IF EXISTS downloads;
DROP TABLE IF EXISTS enrollment;

CREATE TABLE IF NOT EXISTS students (
    student_id 	INT 			PRIMARY KEY		AUTO_INCREMENT,
    student_name 	VARCHAR(100) not null
) ENGINE = innoDB;

CREATE TABLE IF NOT EXISTS courses (
    course_id 	VARCHAR(45) not null PRIMARY KEY,
    course_name 	VARCHAR(45) not null
) ENGINE = innoDB;

CREATE TABLE IF NOT EXISTS enrollment (
    quarter_id INT PRIMARY KEY		AUTO_INCREMENT,
    student_id INT,
    course_id 	VARCHAR(45) not null,
    quarter_enrolled1 VARCHAR(45) NOT NULL,
    CONSTRAINT students_fk_enrollment FOREIGN KEY (student_id)
        REFERENCES students (student_id),
    CONSTRAINT courses_fk_enrollment FOREIGN KEY (course_id)
        REFERENCES courses (course_id)
) ENGINE = innoDB;

ALTER SCHEMA `se`  DEFAULT CHARACTER SET utf8 ;

INSERT INTO students VALUES 
(1,'John'), 
(2,'Jane'),
(3,'Hao');
INSERT INTO courses VALUES 
('ITAD138','SQL '), 
('ITAD280','Python '),
('ITAD123','C++ ');
INSERT INTO enrollment VALUES 
(1,1,'ITAD138','Winter2017'), 
(1,2,'ITAD280','Spring20172'),
(2,1,'ITAD123','Winter20172');

