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

/* Result:
| month | revenue |
|----------|-------|
| 2024-09  | 1272  | 
| 2024-10  | 487.5 |
| 2025-01  | 802   |
| 2025-02  | 1381.5|
| 2025-03  | 1176  | 
| 2025-04  | 740   |
| 2025-05  | 2044.5|
| 2025-06  | 1570.5|

*/
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

/* Result:
| product_name    | units_sold |
|--------------------|------- |
| RGB Keyboard BB    | 90  | 
| Wireless Joystick Q| 87  |
| External SSD Y     | 83  |
| Gaming Headset T   | 83  |
| Gaming Chair I     | 81  | 
*/
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

/* Result:
| product_name    | stock_quantity|
|--------------------|------- |
| Gaming Chair II    | 3  | 
| External SSD Y     | 4  |
| Gaming Chair I     | 4  |
| RGB Keyboard BB    | 6  |
| Wireless Joystick Q| 9  | 
*/
---------------------------------------------------------
-- 4. Top 5 Customer Lifetime Value (Total Spend)
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

/* Result:
| cust_id | cust_name      | total_spent |
|----------|---------------|-------------|
| TGSN0012 | Jack Moore    | 7871.5      |
| TGSN0008 | Fiona Lee     | 255.5       |
| TGSN0003 | Alice Brown   | 238.5       |
| TGSN0001 | John Doe      | 195.5       |
| TGSN0005 | Charlie Davis | 178.5       |
*/
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

/* Result:
| order_date | daily_sales |
|------------|-------------|
| 2025-02-24 | 372.5       | 
| 2025-05-10 | 314.5       |
| 2025-04-23 | 314.5       |
| 2025-06-17 | 314.5       |
| 2025-02-02 | 314.5       |
*/
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

/* Result:
| average_order_value | 
|---------------------|
| 118.43              | 
*/