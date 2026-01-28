-- public.customer definition

-- Drop table

-- DROP TABLE public.customer;

CREATE TABLE public.customer (
	cust_id varchar(50) NOT NULL,
	cust_name varchar(50) NOT NULL,
	email varchar(50) NULL,
	phone_no varchar(50) NULL,
	address varchar(50) NULL,
	city varchar(50) NULL,
	state varchar(50) NULL,
	total_spent numeric(10, 2) NULL
);


-- public.department definition

-- Drop table

-- DROP TABLE public.department;

CREATE TABLE public.department (
	dept_id int4 NOT NULL,
	dept_name varchar(50) NOT NULL
);


-- public.employees definition

-- Drop table

-- DROP TABLE public.employees;

CREATE TABLE public.employees (
	emp_id int4 NOT NULL,
	emp_name varchar(50) NOT NULL,
	job varchar(50) NULL,
	dept_id int4 NOT NULL,
	hire_date date NULL,
	salary numeric(10, 2) NULL
);


-- public.supplier definition

-- Drop table

-- DROP TABLE public.supplier;

CREATE TABLE public.supplier (
	supplier_id int4 NOT NULL,
	supplier_name varchar(50) NOT NULL,
	contact_name varchar(50) NULL,
	supplier_phone varchar(50) NULL,
	supplier_address varchar(50) NULL
);


-- public.membership definition

-- Drop table

-- DROP TABLE public.membership;

CREATE TABLE public.membership (
	mem_id varchar(50) NOT NULL,
	cust_id varchar(50) NOT NULL,
	mem_status varchar(50) NULL,
	reg_date date NOT NULL,
	points float4 NULL
);


-- public.orders definition

-- Drop table

-- DROP TABLE public.orders;

CREATE TABLE public.orders (
	order_id int4 NOT NULL,
	cust_id varchar(50) NOT NULL,
	order_date date NOT NULL,
	total_amount numeric(10, 2) NOT NULL,
	emp_id int4 NULL
);


-- public.product definition

-- Drop table

-- DROP TABLE public.product;

CREATE TABLE public.product (
	product_id int4 NOT NULL,
	product_name varchar(50) NOT NULL,
	price numeric(10, 2) NOT NULL,
	category varchar(50) NULL,
	stock_quantity int4 NOT NULL,
	supplier_id int4 NOT NULL
);


-- public.inventory definition

-- Drop table

-- DROP TABLE public.inventory;

CREATE TABLE public.inventory (
	inventory_id varchar(50) NOT NULL,
	product_id int4 NOT NULL,
	stock_quantity int4 NOT NULL,
	last_restocked date NOT NULL
);


-- public.orderdetails definition

-- Drop table

-- DROP TABLE public.orderdetails;

CREATE TABLE public.orderdetails (
	orderdetail_id int4 NOT NULL,
	order_id int4 NOT NULL,
	product_id int4 NOT NULL,
	quantity int4 NOT NULL,
	price numeric(10, 2) NOT NULL
);
