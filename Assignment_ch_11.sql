/*Olga Osinskaya*/
/*------------------------------------1-----------------------------------
Write a script that adds an index to the my_guitar_shop database for 
the zip code field in the addresses table.  (2 points)
------------------------------------------------------------------------*/

use my_guitar_shop;
CREATE INDEX zip_index
ON addresses (zip_code);

/*------------------------------------2-----------------------------------
-Write a script that implements the following design in a database named my_web_db:
-In the Downloads table, the user_id and product_id columns are the foreign keys. 
-Include a statement to drop the database if it already exists. 
-Include statements to create and select the database. 
-Include any indexes that you think are necessary. 
-Specify the utf8 character set for all tables. 
-Specify the InnoDB storage engine for all tables.  (8 points)
------------------------------------------------------------------------*/
drop database if exists my_web_db;
create database my_web_db;
use my_web_db;

DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS downloads;
DROP TABLE IF EXISTS products;

CREATE TABLE IF NOT EXISTS users (
    user_id 	INT 			PRIMARY KEY		AUTO_INCREMENT,
    email_address 	VARCHAR(100) not null,
    first_name Varchar(45) not null,
    last_name 	VARCHAR(45) not null
) ENGINE = innoDB;

CREATE TABLE IF NOT EXISTS products (
    product_id 	INT PRIMARY KEY		AUTO_INCREMENT,
    product_name 	VARCHAR(45) not null
) ENGINE = innoDB;

CREATE TABLE IF NOT EXISTS downloads (
    download_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT NOT NULL,
    download_date DATETIME NOT NULL,
    filename VARCHAR(45) NOT NULL,
    product_id INT NOT NULL,
    CONSTRAINT users_fk_downloads FOREIGN KEY (user_id)
        REFERENCES users (user_id),
    CONSTRAINT products_fk_downloads FOREIGN KEY (product_id)
        REFERENCES products (product_id)
) ENGINE = innoDB;

ALTER SCHEMA `my_web_db`  DEFAULT CHARACTER SET utf8 ;
/*------------------------------------3-----------------------------------
Write a script that adds rows to the database that you created in exercise 2. 
Add two rows to the Users and Products tables.
Add three rows to the Downloads table: 
one row for user 1 and product 2; 
one row for user 2 and product 1; 
and one row for user 2 and product 2. 
Use the NOW function to insert the current date and time into 
the download_date column.  
------------------------------------------------------------------------*/
INSERT INTO users VALUES 
(1,'user1@address.ru','user1_first_name','user1_last_name'), 
(2,'user2@address.ru','user2_first_name','user2_last_name');

INSERT INTO products VALUES 
(1,'app1'), 
(2,'app2');

INSERT INTO downloads VALUES 
(1,1,NOW(),'door',2), 
(2,2,NOW(),'door',1),
(3,2,NOW(),'door',2);

/*------------------------------------4-----------------------------------
Write a SELECT statement that joins the three tables and retrieves the 
product_name, first_name, last_name. 
Sort by product_name, last_name, first_name.  
------------------------------------------------------------------------*/
SELECT 
    p.product_name, u.first_name, u.last_name
FROM
    users u
        INNER JOIN
    downloads d ON u.user_id = d.user_id
        INNER JOIN
    products p ON p.product_id = d.product_id
ORDER BY p.product_name , u.last_name , u.first_name;

/*------------------------------------5-----------------------------------
Write an ALTER TABLE statement that adds two new columns to the 
Products table created in exercise 2. Add one column for product price 
that provides for three digits to the left of the decimal point and two 
to the right. This column should have a default value of 9.99.
Add one column for the date and time that the product was added to the database.  
------------------------------------------------------------------------*/
ALTER TABLE products
ADD COLUMN
(
product_price DECIMAL(5,2) DEFAULT 9.99,
date_added DATETIME not null
);

/*------------------------------------6-----------------------------------
Write an ALTER TABLE statement that modifies the Users table created 
in exercise 2 so the first_name column cannot store NULL values and 
can store a maximum of 20 characters.
Code an UPDATE statement that attempts to insert a NULL value into this column. 
It should fail due to the NOT NULL constraint.
Code another UPDATE statement that attempts to insert a first name 
that’s longer than 20 characters.
It should fail.
------------------------------------------------------------------------*/
ALTER TABLE users
MODIFY first_name VARCHAR(20) not null;

Update users set first_name = NULL 
where user_id=1;

UPDATE users 
SET 
    first_name = '1234567891123456789012'
WHERE
    user_id = 1; 




