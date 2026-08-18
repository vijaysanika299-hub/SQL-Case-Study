# ClassicModels Case Study – SQL Analysis

## Overview
This project is a comprehensive SQL case study built primarily on the `classicmodels` sample database (with a supporting `Customers_Orders` database created along the way). It covers core querying techniques through advanced SQL concepts — joins, views, stored procedures, window functions, subqueries, error handling, and triggers — based on the script `Sanika.CaseStudy.sql`.

## Databases
- **`classicmodels`** – the primary sample database (employees, customers, orders, orderdetails, products, productlines, payments, etc.)
- **`Customers_Orders`** – a new database created as part of Q4, containing custom `Customers` and `Orders` tables with constraints (PK, FK, UNIQUE, CHECK, NOT NULL)

## Contents

### Q1 – Basic SELECT, WHERE, DISTINCT, LIKE
- **A:** Employee number, first name, and last name of Sales Reps reporting to employee #1102.
- **B:** Unique `productLine` values ending in the word "Cars".

### Q2 – CASE Statements
Segments customers into `North America`, `Europe`, or `Other` based on country.
## Screeshot
<img width="1910" height="1068" alt="Screenshot 2026-08-18 153452" src="https://github.com/user-attachments/assets/8de0b01a-55f0-4084-a5d9-22061a76aa50" />


### Q3 – GROUP BY, Aggregates, HAVING, Date Functions
- **A:** Top 10 products by total quantity ordered (`orderdetails`).
- **B:** Monthly payment counts (by month name) where count exceeds 20, sorted descending.

### Q4 – Database & Table Design (DDL)
Creates the `Customers_Orders` database with:
- **`Customers`** table – `customer_id` (PK, auto-increment), `first_name`, `last_name` (NOT NULL), `email`, `phone_number`.
- **`Orders`** table – `order_id` (PK, auto-increment), `customer_id` (FK → Customers), `order_date`, `total_amount` (DECIMAL with CHECK > 0).

### Q5 – Joins
Top 5 countries by order count, joining `customers` and `orders`.

### Q6 – Self Join
Creates a `project` table (EmployeeID, FullName, Gender, ManagerID), inserts sample data, and self-joins to map employees to their managers.

### Q7 – DDL: CREATE, ALTER, RENAME
Creates a `facility` table, then:
- Adds PRIMARY KEY + AUTO_INCREMENT to `Facility_ID`.
- Adds a NOT NULL `city` column after `Name`.

### Q8 – Views
Creates a view (`sales`) summarizing sales performance by product line:
- `total sales` = sum of `quantityOrdered * priceEach`
- `No of Orders` = distinct order count per product line

### Q9 – Stored Procedures with Parameters
`Country_payments(in_year, country)` — returns year-wise, country-wise total payment amount, formatted in thousands (e.g., "125K").

### Q10 – Window Functions (RANK, DENSE_RANK, LAG)
- **A:** Ranks customers by order frequency using `DENSE_RANK()`.
- **B:** Year- and month-wise order counts with Year-over-Year (YoY) % change using `LAG()`, formatted as whole-number percentages.

### Q11 – Subqueries
Finds product lines where `buyPrice` exceeds the overall average `buyPrice`, with counts per line.

### Q12 – Error Handling
Creates `Emp_EH` table and a stored procedure `InsertEmployee_EH` using a `DECLARE EXIT HANDLER FOR SQLEXCEPTION` block to catch errors (e.g., duplicate primary key) and return "Error occurred" instead of failing silently.

### Q13 – Triggers
Creates `Emp_BIT` table and a `BEFORE INSERT` trigger (`emp_bit_BEFORE_INSERT`) that converts any negative `Working_hours` value to positive using `ABS()` before the row is inserted.


## Notes
- This script uses MySQL-specific syntax (`DELIMITER`, `AUTO_INCREMENT`, `CONCAT`, `MONTHNAME`, etc.).
- Q9's stored procedure is created as `Country_payments` but referenced in the prompt as `Get_country_payments` — naming was adjusted in implementation.
- Q12 demonstrates basic exception handling; re-running the duplicate `INSERT` intentionally triggers the error path for testing.
- Q13's trigger only affects new inserts (not existing rows) since it's a `BEFORE INSERT` trigger.
