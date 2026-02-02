Implementation Guide
Step 1 – Environment Setup
Since Docker was already installed, PostgreSQL was started using a Docker container to ensure a reproducible and isolated environment.
Run PostgreSQL container
docker run --name tungsten-postgres \
  -e POSTGRES_PASSWORD=postgres \
  -e POSTGRES_DB=tungsten \
  -p 5432:5432 \
  -d postgres
Command explanation
docker run → start a container
--name tungsten-postgres → assign container name
POSTGRES_PASSWORD → database password
POSTGRES_DB → creates database named tungsten
-p 5432:5432 → expose port to local machine
-d postgres → run official image in background
GUI connection (DBeaver)
Host: localhost
Port: 5432
User: postgres
Password: postgres
Database: tungsten
Step 2 – Data Cleaning
Before importing, the dataset was cleaned to ensure consistency and quality.
Removed irrelevant columns
Standardized text formats
Converted uppercase values to readable format
Ensured clean, consistent structure for import
Step 3 – Data Import
Process
Original dataset contained multiple Excel sheets
Each sheet was exported into separate CSV files using a Python script
Each CSV imported individually using DBeaver
Import steps
Tables → Import Data → CSV → Select file
Note
Initial imports resulted in type and formatting errors.
After cleaning, the dataset was re-imported successfully.
Step 4 – Data Transformation & Enrichment
4.1 Rename columns to snake_case
Uppercase column names require quoting in PostgreSQL and reduce usability.
All columns were converted to lowercase snake_case.
ALTER TABLE customer RENAME COLUMN "CUST_NAME" TO cust_name;
ALTER TABLE customer RENAME COLUMN "CUST_ID" TO cust_id;
4.2 Generate synthetic salary data
Synthetic data was generated to simulate realistic business scenarios and enable meaningful analytics.
UPDATE employees
SET salary =
CASE
    WHEN job = 'President' THEN 150000
    WHEN job = 'Manager'   THEN 95000 + (random()*10000)
    WHEN job = 'Salesman'  THEN 60000 + (random()*10000)
    WHEN job = 'Cashier'   THEN 35000 + (random()*5000)
END;
4.3 Generate additional transactional data
Additional synthetic records were created to simulate real-world transaction volume.
Orders
INSERT INTO orders (ord_id, cust_id, ord_date, total_amt, emp_id)
SELECT
    generate_series(500016, 500080),
    (SELECT cust_id FROM customer ORDER BY random() LIMIT 1),
    DATE '2025-01-01' + (random()*180)::int,
    (random()*500 + 50)::numeric(10,2),
    (SELECT emp_id FROM employees ORDER BY random() LIMIT 1);
Balanced employee assignments:
WITH s AS (
  SELECT emp_id, ROW_NUMBER() OVER () rn
  FROM employees
  WHERE job = 'Salesman'
),
o AS (
  SELECT ord_id, ROW_NUMBER() OVER () rn
  FROM orders
)
UPDATE orders
SET emp_id = s.emp_id
FROM s, o
WHERE orders.ord_id = o.ord_id
AND (o.rn % 3) + 1 = s.rn;
Order Details
INSERT INTO orderdetails (orderdetail_id, order_id, product_id, quantity, price)
SELECT
    ROW_NUMBER() OVER () + (SELECT MAX(orderdetail_id) FROM orderdetails),
    o.ord_id,
    p.product_id,
    (ROW_NUMBER() OVER () % 5) + 1,
    ROUND((p.price)::numeric, 2)
FROM orders o
JOIN product p
  ON (p.product_id % 3) = (o.ord_id % 3)
LIMIT 180;
Step 5 – Constraints
Data integrity rules were enforced using constraints.
Primary Keys
ALTER TABLE customer
ADD CONSTRAINT customer_pkey PRIMARY KEY (cust_id);
Foreign Keys
ALTER TABLE employees
ADD CONSTRAINT fk_employee_department
FOREIGN KEY (dept_id) REFERENCES department(dept_id);
Unique Keys
ALTER TABLE customer
ADD CONSTRAINT unique_customer_email UNIQUE (email);
Check Constraints
ALTER TABLE product
ADD CONSTRAINT chk_price_positive CHECK (price > 0);
Step 6 – ER Diagram
The database schema was visualized using dbdiagram.io.
Primary key and foreign key definitions were imported to automatically generate the ERD.
Step 7 – Indexes
Indexes were added on foreign key and frequently joined columns to improve query performance by reducing full table scans and speeding up joins and filters.
CREATE INDEX idx_employee_dept_id
ON employees(dept_id);
Step 8 – Final Validation
Final checks ensured data accuracy and consistency.
Validated column data types
Converted mismatches (VARCHAR → DATE, FLOAT → NUMERIC)
Checked for null values
Exported DDL from DBeaver into SQL files
Step 9 – Analytics Queries
Analytical queries were created to validate schema correctness and demonstrate business insights.
Example – Monthly Revenue
SELECT
    TO_CHAR(DATE_TRUNC('month', o.order_date), 'YYYY-MM') AS month,
    SUM(p.price * od.quantity) AS revenue
FROM orders o
JOIN orderdetails od ON o.order_id = od.order_id
JOIN product p ON p.product_id = od.product_id
GROUP BY DATE_TRUNC('month', o.order_date)
ORDER BY DATE_TRUNC('month', o.order_date);
Step 10 – GitHub & Documentation
Created structured README
Added analytics examples
Documented implementation steps
Pushed project to GitHub for reproducibility and visibility