# Implementation Steps

## Step 1 – Setup: 
- Since I already have Docker, I ran Postgres on Docker container.

    In terminal, 
        docker run --name tungsten-postgres -e POSTGRES_PASSWORD=postgres -e POSTGRES_DB=tungsten -p 5432:5432 -d postgres
    #### Meaning: 
    docker run = Start a container
    
    --name tungsten-postgres = Give it a name (so you can restart later)
    
    -e POSTGRES_PASSWORD=postgres = Sets password = postgres
    
    -e POSTGRES_DB=tungsten = Creates database called tungsten
    
    -p 5432:5432 = Connect laptop → container
    
    -d postgres = Use official postgres image + run in background

- Installed GUI – I used DBeaver and gave connection
Host: localhost
Port: 5432
User: postgres
Password: postgres
Database: tungsten

---

## Step 2 – Cleaning Data:
-	Removed irrelevant columns and standardized text formats to ensure clean, consistent data before import.
-	Some data is also completely upper case. I have changed it to normal names. 
Now the data is ready to be imported

---

## Step 3 – Import Data:
-	I have the data in Excel file with different sheets. To create a database, it is good to have each table (Excel sheet) in each csv file. So, I split the Excel file with different sheets to different csv files using Python Script. 
-	Then opened DBeaver and right clicked on Tables, then import data -> file type csv -> Browsed the file imported each csv file, Now the tables are ready. (Initial imports resulted in type and format errors. After cleaning the dataset, the tables were re-imported successfully.)

---

## Step 4 – Altering the data:
-	All the Table names are in upper case. In DBeaver it is better to use all lower-case snake_case because it is case sensitive. To access upper case column names, we need to use double quotes which becomes difficult. So, I converted them to lower case snake_case.
    ```ALTER TABLE customer RENAME COLUMN "CUST_NAME" TO cust_name;
       ALTER TABLE customer RENAME COLUMN "CUST_ID" TO cust_id;
    ```
- Synthetic salary data was generated to simulate realistic business scenarios and enable meaningful analytics.
  ```UPDATE employees
    SET salary =
    CASE
        WHEN job = 'President' THEN 150000
        WHEN job = 'Manager'   THEN 95000 + (random()*10000)
        WHEN job = 'Salesman'  THEN 60000 + (random()*10000)
        WHEN job = 'Cashier'   THEN 35000 + (random()*5000)
    END;
    ```
-	Additional synthetic records were generated to increase dataset volume and better simulate real-world transaction loads. So, I randomly generated rows for tables
    -	Orders:
      ```
        INSERT INTO orders (ord_id, cust_id, ord_date, total_amt, emp_id)
        SELECT
            generate_series(500016, 500080),                      -- INT ids
            (SELECT cust_id FROM customer ORDER BY random() LIMIT 1),
            TO_CHAR(DATE '2025-01-01' + (random()*180)::int, 'YYYY-MM-DD'),
            (random()*500 + 50)::numeric(10,2),
            (SELECT emp_id FROM employees ORDER BY random() LIMIT 1);
        This Query generated only 1 Salesman for all the orders, So generated these. 
        WITH s AS (
        SELECT emp_id,
                ROW_NUMBER() OVER () rn
        FROM employees
        WHERE job = 'Salesman'
        ),
        o AS (
        SELECT ord_id,
                ROW_NUMBER() OVER () rn
        FROM orders
        )
        UPDATE orders
        SET emp_id = s.emp_id
        FROM s, o
        WHERE orders.ord_id = o.ord_id
        AND (o.rn % 3) + 1 = s.rn;
      ```
    -	Orderdetails:
      ```
        INSERT INTO orderdetails (orderdetail_id, order_id, product_id, quantity, price)
        SELECT
            ROW_NUMBER() OVER () + (SELECT MAX(orderdetail_id) FROM orderdetails) AS orderdetail_id,
            o.ord_id,
            p.product_id,
            (ROW_NUMBER() OVER () % 5) + 1 AS quantity,
            ROUND((p.price)::numeric, 2) AS price
        FROM orders o
        JOIN product p
        ON (p.product_id % 3) = (o.ord_id % 3)   -- distributes products across orders
        LIMIT 180;
      ```
Now the data is all set. 

---

## Step 5 - Adding Constraints:
Now I have added the Primary key , Foreign Key, Unique and >0 constraints:
-	Primary keys:
    ```
    ALTER TABLE customer 
    ADD CONSTRAINT customer_pkey PRIMARY KEY (cust_id);
    ```
-	Foreign Keys:
    ```
    ALTER TABLE employees 
    ADD CONSTRAINT fk_employee_department FOREIGN KEY (dept_id) REFERENCES public.department(dept_id);
    ```
-	Unique Keys:
    ```
    ALTER TABLE customer 
    ADD CONSTRAINT unique_customer_email UNIQUE (email);
    ```
-	> 0:
    ```
    ALTER TABLE product
    ADD CONSTRAINT chk_price_positive CHECK ((price > (0)::numeric));
    ```

---

## Step 6 – ERD:
I have created and ERD using dbdiagram.io. I have copy pasted the primary key and foreign key code in the dbdiagram.io and it gave me the ER Diagram.

---

## Step 7 – Indexes: 
Indexes were added on foreign key and frequently joined columns to improve query performance by reducing full table scans and speeding up joins and filters.
CREATE INDEX idx_employee_dept_id ON public.employees USING btree (dept_id);

---

## Step 8 – Final Checks:
I checked the columns for its authenticity, 
-	Validated column data types and converted mismatches (e.g., VARCHAR → DATE, FLOAT → NUMERIC) to ensure data integrity and accurate analytics.
-	Checked for null columns and set null columns (I have done this manually first then exported the commands from DBeaver and updated it in Code File)

---

## Step 9 – Analytics Queries:
Created analytical queries (e.g., monthly revenue, product performance) to validate schema correctness and demonstrate business insights.
---------------------------------------------------------
-- 1. Monthly Revenue
---------------------------------------------------------
```
SELECT
    TO_CHAR(DATE_TRUNC('month', o.order_date), 'YYYY-MM')  AS month,
    SUM(p.price * od.quantity) AS revenue
FROM orders o
JOIN orderdetails od ON o.order_id = od.order_id
JOIN product p ON p.product_id = od.product_id
GROUP BY DATE_TRUNC('month', o.order_date)
ORDER BY DATE_TRUNC('month', o.order_date);
```

---

## Step 10 – README.md and GitHub:
After successfully executing the Analytics queries, I have created a README and pushed the code to GitHub for visibility.
