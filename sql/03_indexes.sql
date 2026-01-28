CREATE INDEX idx_employee_dept_id ON public.employees USING btree (dept_id);
CREATE INDEX idx_membership_customer_id ON public.membership USING btree (cust_id);
CREATE INDEX idx_orders_customer_id ON public.orders USING btree (cust_id);
CREATE INDEX idx_orders_emp_id ON public.orders USING btree (emp_id);
CREATE INDEX idx_product_supplier_id ON public.product USING btree (supplier_id);
CREATE INDEX idx_inventory_product_id ON public.inventory USING btree (product_id);
CREATE INDEX idx_orderdetail_order_id ON public.orderdetails USING btree (order_id);
CREATE INDEX idx_orderdetail_product_id ON public.orderdetails USING btree (product_id);