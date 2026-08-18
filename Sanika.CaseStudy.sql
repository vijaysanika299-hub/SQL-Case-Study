use classicmodels;

-- ------------------------------------------------- Q1 ----------------------------------------------------
-- A
-- SELECT clause with WHERE, AND, DISTINCT, Wild Card (LIKE)
-- Fetch the employee number, first name and last name of those employees who are 
-- working as Sales Rep reporting to employee with employeenumber 1102 (Refer employee table)

select * from employees;

select employeeNumber, firstName, lastName
from employees
where jobTitle = 'Sales Rep'
and reportsTo = 1102;

-- B
-- Show the unique productline values containing the word cars at the end from the products table.

select * from products;

select distinct productLine
from products
where productLine like '%Cars';

-- -------------------------------------------- Q2 ----------------------------------------------------------------
-- . a. Using a CASE statement, segment customers into three categories based on their country:(Refer Customers table)
-- 	"NorthAmerica" for customers from USA or Canada
--  "Europe" for customers from UK, France, or Germany
-- "Other" for all remaining countries


select * from customers;

select customerNumber,customerName,
case
when country in ('USA', 'Canada') then 'North America'
when country in ('UK', 'France', 'Germany') then 'Europe'
else 'Other'
end as CustomerSegment
from customers;

-- -------------------------------------------------------- Q3 ---------------------------------------------------------
-- A
-- Group By with Aggregation functions and Having clause, Date and Time functions
-- Using the OrderDetails table, identify the top 10 products (by productCode) 
-- with the highest total order quantity across all orders.

select * from orderdetails;

select productcode, sum(quantityOrdered) as 'TotalQuantity'
from orderdetails
group by productcode
Order by TotalQuantity desc
limit 10;

-- B
-- Company wants to analyse payment frequency by month. 
-- Extract the month name from the payment date to count the total number of payments for each month 
-- and include only those months with a payment count exceeding 20.
-- Sort the results by total number of payments in descending order.  (Refer Payments table). 

select * from payments;

select monthname(paymentDate) as payment_month,
count(*) as num_payments
from payments
group by month(paymentDate), monthname(paymentDate)
having count(*) > 20
order by num_payments desc;

-- ----------------------------------------------------- Q4 ------------------------------------------------------
/*
Create a new database named and Customers_Orders and add the following tables as per the description

a.	Create a table named Customers to store customer information. Include the following columns:

customer_id: This should be an integer set as the PRIMARY KEY and AUTO_INCREMENT.
first_name: This should be a VARCHAR(50) to store the customer's first name.
last_name: This should be a VARCHAR(50) to store the customer's last name.
email: This should be a VARCHAR(255) set as UNIQUE to ensure no duplicate email addresses exist.
phone_number: This can be a VARCHAR(20) to allow for different phone number formats.

Add a NOT NULL constraint to the first_name and last_name columns to ensure they always have a value. */

create database if not exists Customers_Orders;

use customers_orders;
drop table if exists orders;
drop table if exists Customers;
create table Customers
(
customer_id int primary key auto_increment,
first_name varchar(50) not null,
last_name varchar(50) not null,
email varchar(50),
phone_number varchar(50)
);

select * from customers;

-- B
/*
Create a table named Orders to store information about customer orders. Include the following columns:

order_id: This should be an integer set as the PRIMARY KEY and AUTO_INCREMENT.
customer_id: This should be an integer referencing the customer_id in the Customers table  (FOREIGN KEY).
order_date: This should be a DATE data type to store the order date.
total_amount: This should be a DECIMAL(10,2) to store the total order amount.
     	
Constraints:
a)	Set a FOREIGN KEY constraint on customer_id to reference the Customers table.
b)	Add a CHECK constraint to ensure the total_amount is always a positive value.
*/

create table orders
(
order_id int primary key auto_increment,
customer_id int,
order_date date not null,
total_amount decimal(10,2) not null,
constraint fk_customer
foreign key(customer_id) references	Customers(customer_id),
constraint total_amount check (total_amount > 0)
);

-- -------------------------------------------------------- Q5 --------------------------------------------------------
-- Joins
-- A
/*
a. List the top 5 countries (by order count) that Classic Models ships to. 
(Use the Customers and Orders tables) */

use classicmodels;
select * from customers;
select * from orders;

select c.country,
count(customerName) as "Total_Orders"
from customers c
Join orders o
on c.customerNumber = o.customerNumber
group by c.country
order by Total_Orders desc
limit 5;

-- -------------------------------------------------------- Q6 --------------------------------------------
-- SELF JOIN
-- A
/*Create a table project with below fields.
●	EmployeeID : integer set as the PRIMARY KEY and AUTO_INCREMENT.
●	FullName: varchar(50) with no null values
●	Gender : Values should be only ‘Male’  or ‘Female’
●	ManagerID: integer 
*/
use classicmodels;

/*Find out the names of employees and their related managers.*/

create table project
(
EmployeeID int primary key auto_increment,
FullName varchar(50) not null,
Gender varchar(6) check (Gender in ('Male', 'Female')),
ManagerID int
);


Insert into project
(FullName,Gender,ManagerID)
values
("Pranaya","Male",3),
("Priyanka","Female",1),
("Preety","Female",Null),
("Anurag","Male",1),
("Sambit","Male",1),
("Rajesh","Male",3),
("Hina","Female",3);


select * from project;

select p1.FullName"Employee_Name",p2.FullName"Manager_name"
from project p1
join project p2
on p1.EmployeeID = p2.ManagerID;

-- -------------------------------------------------- Q7 --------------------------------------------------
-- DDL Commands: Create, Alter, Rename
/*Create table facility. Add the below fields into it.
●	Facility_ID
●	Name
●	State
●	Country

i) Alter the table by adding the primary key and auto increment to Facility_ID column.
ii) Add a new column city after name with data type as varchar which should not accept any null values.*/

create table facility 
(
Facility_ID int,
Name varchar(100),
State varchar(100),
Country varchar(100)
);


alter table facility
modify Facility_ID int primary key auto_increment;

alter table facility
add city varchar(100) not null after Name;

describe facility;

-- -------------------------------------- Q8 ----------------------------------------------
-- VIEW IN SQL
/*a. Create a view named product_category_sales that provides insights into sales performance by product category. 
This view should include the following information:
productLine: The category name of the product (from the ProductLines table).

total_sales: The total revenue generated by products within that category
(calculated by summing the orderDetails.quantity * orderDetails.priceEach for each product in the category).

number_of_orders: The total number of orders containing products from that category.

(Hint: Tables to be used: Products, orders, orderdetails and productlines) */
use classicmodels;
select * from products;
select * from orders;
select * from orderdetails;
select * from productlines;


create view sales as
select pl.productLine,
       sum(od.quantityOrdered * od.priceEach) as "total sales",
       count(distinct o.orderNumber) as "No of Orders"
from productlines pl
join products p
     on pl.productLine = p.productLine
join orderdetails od
     on p.productCode = od.productCode
join orders o
     on od.orderNumber = o.orderNumber
group by pl.productLine;

select * from sales;

-- -------------------------------------------- Q9 -------------------------------------------------------
-- Stored Procedures in SQL with parameters
/*. Create a stored procedure Get_country_payments which takes in year and 
country as inputs and gives year wise, country wise total amount as an output. 
Format the total amount to nearest thousand unit (K)
Tables: Customers, Payments */
use classicmodels;

select * from Customers;
select * from Payments;

USE `classicmodels`;
DROP procedure IF EXISTS `Country_payments`;

DELIMITER $$
USE `classicmodels`$$
CREATE PROCEDURE `Country_payments` (In in_year int, IN country varchar(50))
BEGIN
    select year(p.paymentDate) as Year, c.country,
	concat(round(sum(p.amount)/1000), 'K') as Total_Amount
    from customers c
    join payments p
	on c.customerNumber = p.customerNumber
    where year(p.paymentDate) = in_year
	and c.country = country
    group by year(p.paymentDate), c.country;
END$$

DELIMITER ;

call Country_payments(2003, 'France');

-- -------------------------------------------- Q10 -------------------------------------------------------
-- Window functions - Rank, dense_rank, lead and lag
/* a) Using customers and orders tables, rank the customers based on their order frequency */

select * from customers;
select * from orders;

select 
c.customerName,
count(o.orderNumber) as order_count,
dense_rank() over (order by count(o.orderNumber) desc) as frequency
from
    customers c
join
    orders o
on
    c.customerNumber = o.customerNumber
group by c.customerName
order by frequency;

/*b) Calculate year wise, month name wise count of orders and year over year (YoY) percentage change. 
Format the YoY values in no decimals and show in % sign.
Table: Orders */

select * from orders;

select
year (orderDate) as "year",
monthname (orderDate) as "Month",
count(orderNumber) as "Total Orders",
concat(round(((count(orderNumber)-(lag(count(orderNumber),1,0) over(order by year(orderdate))))
/(lag(count(orderNumber),1,0) over(order by year(orderdate))))*100),"") "%YoY change"
from orders
group by year(orderDate), monthname (orderDate), month (orderdate)
order by year(orderDate), month (orderdate);

-- -------------------------------------------- Q11 -------------------------------------------------------
-- Subqueries and their applications
/*Find out how many product lines are there for which the buy price value is greater than the average of buy price value. 
Show the output as product line and its count.*/
select * from products;

select productline, count(*) as product_count
from products
where buyPrice > (select avg(buyPrice) from products)
group by productline;

-- -------------------------------------------- Q12 -------------------------------------------------------
-- ERROR HANDLING in SQL

/*Create the table Emp_EH. Below are its fields.
●	EmpID (Primary Key)
●	EmpName
●	EmailAddress
Create a procedure to accept the values for the columns in Emp_EH. 
Handle the error using exception handling concept. Show the message as “Error occurred” in case of anything wrong.*/

USE classicmodels;
create table Emp_EH
(
EmpID int primary key,
EmpName Varchar (50),
EmailAddress varchar (50)
);

select * from Emp_EH;

USE `classicmodels`;
DROP procedure IF EXISTS `InsertEmployee_EH`;

DELIMITER $$
USE `classicmodels`$$
CREATE PROCEDURE InsertEmployee_EH (IN p_EmpID INT,IN p_EmpName VARCHAR(100),IN p_EmailAddress VARCHAR(150))
BEGIN
declare exit handler for SQLEXCEPTION
Begin
select 'Error occurred' as Message;
end;
insert into EMP_EH (EmpID, EmpName, EmailAddress)
values(p_EmpID, p_EmpName, p_EmailAddress);

select 'Record inserted successfully' as Message;
END$$

DELIMITER ;


-- Successful insert
call InsertEmployee_EH(1, 'Harshad Londhe', 'harshad3992@gmail.com');

-- Fails due to duplicate EmpID
call InsertEmployee_EH(1, 'Harshad Londhe', 'harshad3992@gmail.com');

select * from Emp_EH;

-- -------------------------------------------- Q13 -------------------------------------------------------
-- TRIGGERS
/*Create before insert trigger to make sure any new value of Working_hours, 
if it is negative, then it should be inserted as positive*/

create table Emp_BIT
(
Name Varchar(20),
Occupation Varchar(20),
Working_date date,
Working_hours Int
);

INSERT INTO Emp_BIT VALUES
('Robin', 'Scientist', '2020-10-04', 12),  
('Warner', 'Engineer', '2020-10-04', 10),  
('Peter', 'Actor', '2020-10-04', 13),  
('Marco', 'Doctor', '2020-10-04', 14),  
('Brayden', 'Teacher', '2020-10-04', 12),  
('Antonio', 'Business', '2020-10-04', 11);  

USE `classicmodels`;

DELIMITER $$

USE `classicmodels`$$
DROP TRIGGER IF EXISTS `classicmodels`.`before_insert_Emp_BIT` $$
DELIMITER ;
DROP TRIGGER IF EXISTS `classicmodels`.`emp_bit_BEFORE_INSERT`;

DELIMITER $$
USE `classicmodels`$$
CREATE DEFINER = CURRENT_USER TRIGGER `classicmodels`.`emp_bit_BEFORE_INSERT` BEFORE INSERT ON `emp_bit` FOR EACH ROW
BEGIN
If new.working_hours < 0
then
set new.working_hours = abs(new.working_hours);
end if;
END$$
DELIMITER ;


insert into Emp_BIT values ('Harshad', 'Data Analyst', '2025-09-05', -9);

insert into Emp_BIT values ('Namrata', 'Data Analyst', '2025-09-05', -20);


select * from Emp_BIT where Name='Namrata';

select * from Emp_BIT;












