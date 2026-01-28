INSERT INTO public.customer (cust_id,cust_name,email,phone_no,address,city,state,total_spent) VALUES
	 ('TGSN0001','John Doe','john.doe@example.com','720-555-0123','123 LAWRENCE ST','DENVER','CO',150.75),
	 ('TGSN0002','Jane Smith','jane.smith@example.com','720-525-0456','456 LOGAN ST','LOUISVILLE','CO',200.00),
	 ('TGSN0003','Alice Brown','alice.brown@example.com','720-535-0789','789 CHAMPA ST','DENVER','CO',300.50),
	 ('TGSN0004','Bob Johnson','bob.johnson@example.com','720-553-1011','321 MAPLE ST','ARVADA','CO',175.25),
	 ('TGSN0005','Charlie Davis','charlie.davis@example.com','720-545-1213','654 CEDAR ST','BROOMFIELD','CO',125.00);

INSERT INTO public.department (dept_id,dept_name) VALUES
	 (201,'FINANCE'),
	 (202,'OPERATIONS'),
	 (203,'ELECTRONICS'),
	 (204,'CDs/DVDs'),
	 (205,'ACCESSORIES');

INSERT INTO public.employees (emp_id,emp_name,job,dept_id,hire_date,salary) VALUES
	 (7839,'King','President',201,'2011-04-02',150000.00),
	 (7698,'Blake','Manager',201,'2012-05-01',95957.04),
	 (7782,'Clark','Cashier',202,'2013-06-09',35126.11),
	 (7566,'Jones','Salesman',203,'2011-11-17',64972.46),
	 (7499,'Allen','Manager',203,'2013-02-20',102992.86);

INSERT INTO public.inventory (inventory_id,product_id,stock_quantity,last_restocked) VALUES
	 ('INVTY5001',100860,20,'2024-09-15'),
	 ('INVTY5002',100861,9,'2024-09-20'),
	 ('INVTY5003',100870,11,'2024-08-30');

INSERT INTO public.membership (mem_id,cust_id,mem_status,reg_date,points) VALUES
	 ('GAME0001','TGSN0001','ACTIVE','2022-10-04',15.75),
	 ('GAME0002','TGSN0002','INACTIVE','2022-10-09',20.0),
	 ('GAME0003','TGSN0003','ACTIVE','2022-10-14',30.5);

INSERT INTO public.orderdetails (orderdetail_id,order_id,product_id,quantity,price) VALUES
	 (10001,500001,100860,2,10.00),
	 (10002,500001,100870,1,6.50),
	 (10003,500002,100890,3,14.00),
	 (10004,500002,200376,1,9.00),
	 (10005,500003,101860,1,30.00),
	 (10006,500003,102130,2,5.00),
	 (10007,500004,101863,1,40.00),
	 (10008,500004,200380,2,7.50),
	 (10009,500005,100861,1,5.00),
	 (10010,500006,100871,2,18.00);

INSERT INTO public.orders (order_id,cust_id,order_date,total_amount,emp_id) VALUES
	 (500001,'TGSN0001','2024-09-01',120.75,7900),
	 (500002,'TGSN0002','2024-09-05',180.00,7788),
	 (500003,'TGSN0003','2024-09-10',250.50,7566),
	 (500004,'TGSN0004','2024-09-12',160.25,7900),
	 (500005,'TGSN0005','2024-09-15',100.00,7788),
	 (500006,'TGSN0006','2024-09-18',200.80,7566),
	 (500007,'TGSN0007','2024-09-20',280.00,7900),
	 (500008,'TGSN0008','2024-09-22',70.00,7788),
	 (500009,'TGSN0009','2024-09-25',170.00,7566),
	 (500010,'TGSN0010','2024-09-27',320.50,7900);

INSERT INTO public.product (product_id,product_name,price,category,stock_quantity,supplier_id) VALUES
	 (100871,'External SSD Y',18.00,'Electronics',4,10005),
	 (100890,'RGB Keyboard BB',14.00,'Electronics',6,10002),
	 (101860,'Gaming Chair I',30.00,'Accessories',4,10004),
	 (101863,'Gaming Chair II',40.00,'Accessories',3,10004),
	 (102130,'NFS CD',5.00,'CDs/DVDs',10,10001),
	 (200376,'PUBG CD',9.00,'CDs/DVDs',20,10003),
	 (200380,'Racing CD',7.50,'CDs/DVDs',25,10001);

INSERT INTO public.supplier (supplier_id,supplier_name,contact_name,supplier_phone,supplier_address) VALUES
	 (10001,'GAMETECH','Maya Clark','323-525-0101','123 GAMING ST  LOS ANGELES  CA'),
	 (10002,'PROGEAR','Nina Brown','315-125-0102','234 GAMER AVE  NEW YORK  NY'),
	 (10003,'PIXEL PERFECT','Toby  Hernandez','720-345-0108','890 PIXEL AVE  DENVER  CO'),
	 (10004,'GAMER''S HAVEN','Penny Wong','206-565-0104','456 ARCADE RD  SEATTLE  WA'),
	 (10005,'JOYSTICK JUNCTION','Quin Reed','737-578-0105','567 CONTROL ST  AUSTIN  TX');
