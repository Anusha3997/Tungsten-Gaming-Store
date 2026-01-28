--ADDING PRIMARY KEYS
ALTER TABLE customer 
ADD CONSTRAINT customer_pkey PRIMARY KEY (cust_id),

ALTER TABLE department 
ADD CONSTRAINT department_pkey PRIMARY KEY (dept_id),

ALTER TABLE employees 
ADD CONSTRAINT employees_pkey PRIMARY KEY (emp_id),

ALTER TABLE supplier 
ADD CONSTRAINT supplier_pkey PRIMARY KEY (supplier_id)

ALTER TABLE membership 
ADD CONSTRAINT membership_pkey PRIMARY KEY (mem_id),

ALTER TABLE orders 
ADD CONSTRAINT orders_pkey PRIMARY KEY (order_id),

ALTER TABLE product 
ADD CONSTRAINT product_pkey PRIMARY KEY (product_id),

ALTER TABLE inventory 
ADD CONSTRAINT inventory_pkey PRIMARY KEY (inventory_id),

ALTER TABLE orderdetails 
ADD CONSTRAINT orderdetails_pkey PRIMARY KEY (orderdetail_id),

-- ADDING FOREIGN KEY CONSTRAINTS

ALTER TABLE employees 
ADD CONSTRAINT fk_employee_department FOREIGN KEY (dept_id) REFERENCES public.department(dept_id)

ALTER TABLE membership 
ADD CONSTRAINT fk_customer_membership FOREIGN KEY (cust_id) REFERENCES public.customer(cust_id)

ALTER TABLE orders 
ADD CONSTRAINT fk_orders_customer FOREIGN KEY (cust_id) REFERENCES public.customer(cust_id),
CONSTRAINT fk_orders_employee FOREIGN KEY (emp_id) REFERENCES public.employees(emp_id)

ALTER TABLE product
ADD CONSTRAINT fk_product_supplier FOREIGN KEY (supplier_id) REFERENCES public.supplier(supplier_id)

ALTER TABLE inventory
ADD CONSTRAINT fk_inventory_product FOREIGN KEY (product_id) REFERENCES public.product(product_id)

ALTER TABLE orderdetails 
ADD CONSTRAINT fk_orderdetails_order FOREIGN KEY (order_id) REFERENCES public.orders(order_id),
CONSTRAINT fk_orderdetails_product FOREIGN KEY (product_id) REFERENCES public.product(product_id)   

-- ADDING UNIQUE AND CHECK CONSTRAINTS
ALTER TABLE customer 
ADD CONSTRAINT unique_customer_email UNIQUE (email)

ALTER TABLE inventory 
ADD CONSTRAINT unique_product_inventory UNIQUE (product_id),
CONSTRAINT chk_quantity_positive CHECK ((stock_quantity >= 0))

ALTER TABLE product
ADD CONSTRAINT chk_price_positive CHECK ((price > (0)::numeric))