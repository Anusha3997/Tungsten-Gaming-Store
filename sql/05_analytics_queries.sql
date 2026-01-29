/* =====================================================
   BUSINESS ANALYTICS QUERIES – Tungsten Gaming Store
   ===================================================== */

---------------------------------------------------------
-- 1. Monthly Revenue
---------------------------------------------------------
SELECT
    TO_CHAR(DATE_TRUNC('month', o.order_date), 'YYYY-MM')  AS month,
    SUM(p.price * od.quantity) AS revenue
FROM orders o
JOIN orderdetails od ON o.order_id = od.order_id
JOIN product p ON p.product_id = od.product_id
GROUP BY DATE_TRUNC('month', o.order_date)
ORDER BY DATE_TRUNC('month', o.order_date);


---------------------------------------------------------
-- 2. Top 5 Best-Selling Products
---------------------------------------------------------
SELECT
    p.product_name,
    SUM(od.quantity) AS units_sold
FROM orderdetails od
JOIN product p ON p.product_id = od.product_id
GROUP BY p.product_name
ORDER BY units_sold DESC
LIMIT 5;


---------------------------------------------------------
-- 3. Low Inventory Alert
---------------------------------------------------------
SELECT
    p.product_name,
    i.stock_quantity
FROM inventory i
JOIN product p ON p.product_id = i.product_id
WHERE i.stock_quantity < 10
ORDER BY i.stock_quantity;


---------------------------------------------------------
-- 4. Customer Lifetime Value (Total Spend)
---------------------------------------------------------
SELECT
    c.cust_id,
    c.cust_name,
    SUM(p.price * od.quantity) AS total_spent
FROM customer c
JOIN orders o ON o.cust_id = c.cust_id
JOIN orderdetails od ON od.order_id = o.order_id
JOIN product p ON p.product_id = od.product_id
GROUP BY c.cust_id, c.cust_name
ORDER BY total_spent DESC;


---------------------------------------------------------
-- 5. Top 5 Best Selling Days
---------------------------------------------------------
SELECT
    o.order_date,
    SUM(p.price * od.quantity) AS daily_sales
FROM orders o
JOIN orderdetails od ON o.order_id = od.order_id
JOIN product p ON p.product_id = od.product_id
GROUP BY o.order_date
ORDER BY daily_sales DESC
LIMIT 5;

---------------------------------------------------------
-- 6. Average Order Value
---------------------------------------------------------
SELECT
    ROUND(AVG(order_total), 2) AS avg_order_value
FROM (
    SELECT
        o.order_id,
        SUM(p.price * od.quantity) AS order_total
    FROM orders o
    JOIN orderdetails od ON o.order_id = od.order_id
    JOIN product p ON p.product_id = od.product_id
    GROUP BY o.order_id
) t;
