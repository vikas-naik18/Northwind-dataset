CREATE database northwind;

SELECT * FROM northwind.categories LIMIT 5;
SELECT * FROM northwind.`customers (1)`LIMIT 5;
SELECT * FROM northwind.employees LIMIT 5;
SELECT * FROM northwind.products LIMIT 5;
SELECT * FROM northwind.orders LIMIT 5;
SELECT * FROM northwind.order_details LIMIT 5;

SELECT 
    o.order_id,
    o.order_date,
    c.customer_name,
    c.region,
    o.total_amount
FROM orders o
INNER JOIN customers c
ON o.customer_id = c.customer_id

SELECT
    c.region,
    SUM(o.total_amount) AS total_sales
FROM orders o
INNER JOIN customers c
ON o.customer_id = c.customer_id
WHERE c.region = 'South'
GROUP BY c.region
SELECT
    c.category_name,
    SUM(oi.quantity * oi.price) AS category_revenue
FROM order_items oi
INNER JOIN products p
ON oi.product_id = p.product_id
INNER JOIN categories c
ON p.category_id = c.category_id
GROUP BY c.category_name
ORDER BY category_revenue DESC;


SELECT
    c.region,
    SUM(o.total_amount) AS total_sales
FROM orders o
INNER JOIN customers c
ON o.customer_id = c.customer_id
WHERE c.region = 'South'
GROUP BY c.region;

SELECT
    c.customer_name,
    o.order_id,
    o.total_amount
FROM customers c
INNER JOIN orders o
ON c.customer_id = o.customer_id;

SELECT
    c.customer_name,
    p.product_name,
    oi.quantity,
    (oi.quantity * oi.price) AS revenue
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
INNER JOIN order_items oi ON o.order_id = oi.order_id
INNER JOIN products p ON oi.product_id = p.product_id;

SELECT o.order_id, c.customer_name
FROM orders o
INNER JOIN customers c
ON o.customer_id = c.customer_id;

-- Customers with no orders
SELECT c.customer_name
FROM customers c
LEFT JOIN orders o
ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

-- Category revenue
SELECT c.category_name, SUM(oi.quantity * oi.price)
FROM order_items oi
JOIN products p ON oi.product_id = p.product_id
JOIN categories c ON p.category_id = c.category_id
GROUP BY c.category_name;