/*-- ========================
-- CUSTOMER
-- ========================
ALTER TABLE customer RENAME COLUMN "CUST_ID" TO cust_id;
ALTER TABLE customer RENAME COLUMN "CUST_NAME" TO cust_name;
ALTER TABLE customer RENAME COLUMN "EMAIL" TO email;
ALTER TABLE customer RENAME COLUMN "PHONE_NO" TO phone_no;
ALTER TABLE customer RENAME COLUMN "ADDRESS" TO address;
ALTER TABLE customer RENAME COLUMN "CITY" TO city;
ALTER TABLE customer RENAME COLUMN "STATE" TO state;
ALTER TABLE customer RENAME COLUMN "TOTAL_SPENT" TO total_spent;
ALTER TABLE customer RENAME COLUMN "MEM_ID" TO mem_id;


-- ========================
-- ORDERS
-- ========================
ALTER TABLE orders RENAME COLUMN "ORDER_ID" TO order_id;
ALTER TABLE orders RENAME COLUMN "CUST_ID" TO cust_id;
ALTER TABLE orders RENAME COLUMN "EMP_ID" TO emp_id;
ALTER TABLE orders RENAME COLUMN "ORDER_DATE" TO order_date;
ALTER TABLE orders RENAME COLUMN "TOTAL_AMOUNT" TO total_amount;


-- ========================
-- ORDERDETAILS
-- ========================
ALTER TABLE orderdetails RENAME COLUMN "ORDERDETAIL_ID" TO orderdetail_id;
ALTER TABLE orderdetails RENAME COLUMN "ORDER_ID" TO order_id;
ALTER TABLE orderdetails RENAME COLUMN "PRODUCT_ID" TO product_id;
ALTER TABLE orderdetails RENAME COLUMN "QUANTITY" TO quantity;
ALTER TABLE orderdetails RENAME COLUMN "PRICE" TO price;


-- ========================
-- PRODUCT
-- ========================
ALTER TABLE product RENAME COLUMN "PRODUCT_ID" TO product_id;
ALTER TABLE product RENAME COLUMN "PRODUCT_NAME" TO product_name;
ALTER TABLE product RENAME COLUMN "CATEGORY" TO category;
ALTER TABLE product RENAME COLUMN "PRICE" TO price;
ALTER TABLE product RENAME COLUMN "SUPPLIER_ID" TO supplier_id;


-- ========================
-- INVENTORY
-- ========================
ALTER TABLE inventory RENAME COLUMN "PRODUCT_ID" TO product_id;
ALTER TABLE inventory RENAME COLUMN "STOCK_QTY" TO stock_qty;
ALTER TABLE inventory RENAME COLUMN "REORDER_LEVEL" TO reorder_level;


-- ========================
-- EMPLOYEES
-- ========================
ALTER TABLE employees RENAME COLUMN "EMP_ID" TO emp_id;
ALTER TABLE employees RENAME COLUMN "EMP_NAME" TO emp_name;
ALTER TABLE employees RENAME COLUMN "DEPT_ID" TO dept_id;
ALTER TABLE employees RENAME COLUMN "HIRE_DATE" TO hire_date;
ALTER TABLE employees RENAME COLUMN "SALARY" TO salary;


-- ========================
-- DEPARTMENT
-- ========================
ALTER TABLE department RENAME COLUMN "DEPT_ID" TO dept_id;
ALTER TABLE department RENAME COLUMN "DEPT_NAME" TO dept_name;


-- ========================
-- MEMBERSHIP
-- ========================
ALTER TABLE membership RENAME COLUMN "MEM_ID" TO mem_id;
ALTER TABLE membership RENAME COLUMN "MEM_TYPE" TO mem_type;
ALTER TABLE membership RENAME COLUMN "DISCOUNT_RATE" TO discount_rate;
ALTER TABLE membership RENAME COLUMN "POINTS" TO points;


-- ========================
-- SUPPLIER
-- ========================
ALTER TABLE supplier RENAME COLUMN "SUPPLIER_ID" TO supplier_id;
ALTER TABLE supplier RENAME COLUMN "SUPPLIER_NAME" TO supplier_name;
ALTER TABLE supplier RENAME COLUMN "CITY" TO city;

*/

INSERT INTO orders (order_id, cust_id, order_date, total_amount, emp_id)
SELECT
    generate_series(16, 80),                      -- INT ids
    (SELECT cust_id FROM customer ORDER BY random() LIMIT 1),
    TO_CHAR(DATE '2025-01-01' + (random()*180)::int, 'YYYY-MM-DD'),
    (random()*500 + 50)::float4,
    (SELECT emp_id FROM employees ORDER BY random() LIMIT 1);

UPDATE orders
SET order_id = order_id + 500000
where order_id >= 16 and order_id< 50000;

ALTER TABLE orders
ALTER COLUMN total_amount TYPE numeric(10,2)
USING ROUND(total_amount::numeric, 2);

WITH s AS (
  SELECT emp_id,
         ROW_NUMBER() OVER () rn
  FROM employees
  WHERE job = 'Salesman'
),
o AS (
  SELECT order_id,
         ROW_NUMBER() OVER () rn
  FROM orders
)
UPDATE orders
SET emp_id = s.emp_id
FROM s, o
WHERE orders.order_id = o.order_id
AND (o.rn % 3) + 1 = s.rn;

INSERT INTO orderdetails (orderdetail_id, order_id, product_id, quantity, price)
SELECT
    gs AS orderdetail_id,
    o.order_id,
    p.product_id,
    (random()*4 + 1)::int AS quantity,
    ROUND((random()*45 + 5)::numeric, 2) AS price
FROM
    generate_series(
        (SELECT COALESCE(MAX(orderdetail_id),0)+1 FROM orderdetails),
        (SELECT COALESCE(MAX(orderdetail_id),0)+180 FROM orderdetails)
    ) gs

-- random order per row
CROSS JOIN LATERAL (
    SELECT order_id
    FROM orders
    ORDER BY random()
    LIMIT 1
) o

-- random product per row
CROSS JOIN LATERAL (
    SELECT product_id
    FROM product
    ORDER BY random()
    LIMIT 1
) p;


DELETE FROM orderdetails
WHERE orderdetail_id > 10025;


INSERT INTO orderdetails (orderdetail_id, order_id, product_id, quantity, price)
SELECT
    ROW_NUMBER() OVER () + (SELECT MAX(orderdetail_id) FROM orderdetails) AS orderdetail_id,
    o.order_id,
    p.product_id,
    (ROW_NUMBER() OVER () % 5) + 1 AS quantity,
    ROUND((p.price)::numeric, 2) AS price
FROM orders o
JOIN product p
  ON (p.product_id % 3) = (o.order_id % 3)   -- distributes products across orders
LIMIT 180;


ALTER TABLE customer
ADD PRIMARY KEY (cust_id);

ALTER TABLE product
ADD PRIMARY KEY (product_id);

ALTER TABLE orders
ADD PRIMARY KEY (order_id);

ALTER TABLE orderdetails
ADD PRIMARY KEY (orderdetail_id);

ALTER TABLE employees
ADD PRIMARY KEY (emp_id);

ALTER TABLE membership
ADD PRIMARY KEY (mem_id);

ALTER TABLE supplier
ADD PRIMARY KEY (supplier_id);

ALTER TABLE department
ADD PRIMARY KEY (dept_id);

ALTER TABLE inventory
ADD PRIMARY KEY (inventory_id);

ALTER TABLE orders
ADD CONSTRAINT fk_orders_customer
FOREIGN KEY (cust_id)
REFERENCES customer(cust_id);

ALTER TABLE orders
ADD CONSTRAINT fk_orders_employee
FOREIGN KEY (emp_id)
REFERENCES employees(emp_id);

ALTER TABLE orderdetails
ADD CONSTRAINT fk_orderdetails_order
FOREIGN KEY (order_id)
REFERENCES orders(order_id);

ALTER TABLE orderdetails
ADD CONSTRAINT fk_orderdetails_product
FOREIGN KEY (product_id)
REFERENCES product(product_id);

ALTER TABLE customer
ADD CONSTRAINT fk_customer_membership
FOREIGN KEY (mem_id)
REFERENCES membership(mem_id);

ALTER TABLE employees
ADD CONSTRAINT fk_employee_department
FOREIGN KEY (dept_id)
REFERENCES department(dept_id);

ALTER TABLE product
ADD CONSTRAINT fk_product_supplier
FOREIGN KEY (supplier_id)
REFERENCES supplier(supplier_id);

ALTER TABLE inventory
ADD CONSTRAINT fk_inventory_product
FOREIGN KEY (product_id)
REFERENCES product(product_id);

ALTER TABLE membership
ADD CONSTRAINT fk_customer_membership
FOREIGN KEY (cust_id)
REFERENCES customer(cust_id);

ALTER TABLE inventory
ADD CONSTRAINT unique_product_inventory UNIQUE(product_id);

ALTER TABLE customer
ADD CONSTRAINT unique_customer_email UNIQUE(email);

ALTER TABLE orders
ALTER COLUMN order_date TYPE DATE
USING order_date::date;

ALTER TABLE employees
ALTER COLUMN hire_date TYPE DATE
USING hire_date::date;

ALTER TABLE membership
ALTER COLUMN reg_date TYPE DATE
USING reg_date::date;

ALTER TABLE inventory
ALTER COLUMN last_restocked TYPE DATE
USING last_restocked::date;

ALTER TABLE customer
ALTER COLUMN total_spent TYPE numeric(10,2);

ALTER TABLE orderdetails
ALTER COLUMN price TYPE numeric(10,2);

ALTER TABLE product
ALTER COLUMN price TYPE numeric(10,2);

ALTER TABLE product
ALTER COLUMN price TYPE numeric(10,2);

CREATE INDEX idx_orders_customer_id ON orders(cust_id);
CREATE INDEX idx_inventory_product_id ON inventory(product_id);
create index idx_employee_dept_id on employees(dept_id);
create index idx_product_supplier_id on product(supplier_id);
CREATE INDEX idx_membership_customer_id ON membership(cust_id);
create index idx_orderdetail_order_id on orderdetails(order_id);
create index idx_orderdetail_product_id on orderdetails(product_id);
CREATE INDEX idx_orders_emp_id ON orders(emp_id);



ALTER TABLE product
ADD CONSTRAINT chk_price_positive
CHECK (price > 0);

ALTER TABLE inventory
ADD CONSTRAINT chk_quantity_positive
CHECK (stock_quantity >= 0);

ALTER TABLE product
ALTER COLUMN price SET NOT NULL;

ALTER TABLE customer
ALTER COLUMN cust_name SET NOT NULL;

ALTER TABLE department
ALTER COLUMN dept_name SET NOT NULL;

ALTER TABLE employees
ALTER COLUMN emp_name SET NOT null,
ALTER COLUMN dept_id SET NOT NULL;

ALTER TABLE inventory
ALTER COLUMN product_id SET NOT null,
ALTER COLUMN stock_quantity SET NOT null,
ALTER COLUMN last_restocked SET NOT null;

ALTER TABLE membership
ALTER COLUMN cust_id SET NOT null,
ALTER COLUMN reg_date SET NOT NULL;

ALTER TABLE orderdetails
ALTER COLUMN order_id SET NOT null,
ALTER COLUMN product_id SET NOT null,
ALTER COLUMN quantity SET NOT null,
ALTER COLUMN price SET NOT null;

ALTER TABLE orders
ALTER COLUMN cust_id SET NOT null,
ALTER COLUMN total_amount SET NOT null,
ALTER COLUMN order_date SET NOT null;

ALTER TABLE product
ALTER COLUMN product_name SET NOT null,
ALTER COLUMN stock_quantity SET NOT null,
ALTER COLUMN supplier_id SET NOT null;

ALTER TABLE supplier
ALTER COLUMN supplier_name SET NOT NULL;
