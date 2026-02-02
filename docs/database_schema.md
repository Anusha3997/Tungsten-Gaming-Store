# Database Schema
🧩 Entities
- Customer – Customer profile and contact details
- Membership – Loyalty membership and points
- Orders – Purchase transactions
- OrderDetails – Line items per order
- Product – Product catalog and pricing
- Supplier – Product suppliers
- Inventory – Stock tracking
- Employees – Store staff
- Department – Employee departments or product departments

-----

## 📋 Tables & Keys
- Customer
```Column	Key
cust_id	PK
cust_name	
email	UNIQUE
phone_no	
address	
city	
state	
total_spent
```
- Membership
Column	Key
mem_id	PK
cust_id	FK → customer
mem_status	
points	
reg_date	
- Orders
Column	Key
order_id	PK
cust_id	FK → customer
emp_id	FK → employees
order_date	
total_amount	
- OrderDetails
Column	Key
orderdetail_id	PK
order_id	FK → orders
product_id	FK → product
quantity	
price	
- Product
Column	Key
product_id	PK
product_name	
category	
price	
supplier_id	FK → supplier
stock_quantity	
- Supplier
Column	Key
supplier_id	PK
supplier_name	
contact_name	
supplier_phone	
supplier_address	
- Inventory
Column	Key
inventory_id	PK
product_id	FK → product
stock_quantity	
last_restocked	
- Employees
Column	Key
emp_id	PK
emp_name	
job	
dept_id	FK → department
hire_date	
salary	
- Department
Column	Key
dept_id	PK
dept_name	

----

## 🔗 Relationships
One Customer → many Orders
One Order → many OrderDetails
One Product → many OrderDetails
One Supplier → many Products
One Product → one Inventory record
One Employee → many Orders
One Department → many Employees
One Customer → zero or one Membership
