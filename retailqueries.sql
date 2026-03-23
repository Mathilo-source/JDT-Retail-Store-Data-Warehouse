USE retail;
-- total revenue for the sales
SELECT SUM(total_amount) AS total_revenue
FROM sales_facts;

-- sales by product
SELECT p.product_name, SUM(s.total_amount)
FROM sales_facts s
JOIN product_dimension p ON s.product_id = p.product_id
GROUP BY p.product_name;

-- top selling product by category
SELECT 
    p.product_category,
    p.product_name,
    SUM(s.quantity) AS total_sold
FROM sales_facts s
JOIN product_dimension p ON s.product_id = p.product_id
GROUP BY p.product_category, p.product_name
ORDER BY p.product_category, total_sold DESC;


-- sales by date
SELECT 
    o.order_date,
    SUM(s.total_amount) AS daily_sales
FROM sales_facts s
JOIN orders_dimension o ON s.order_id = o.order_id
GROUP BY o.order_date
ORDER BY o.order_date;

-- Calculate 
SELECT 
    c.customer_fullname,
    COUNT(s.order_id) AS total_orders
FROM sales_facts s
JOIN customer_dimension c ON s.customer_id = c.customer_id
GROUP BY c.customer_fullname
ORDER BY total_orders DESC;

-- total revenue per customer
SELECT 
    c.customer_fullname,
    o.order_date,
    s.total_amount,
    SUM(s.total_amount) OVER (
        PARTITION BY c.customer_id 
        ORDER BY o.order_date
    ) AS cumulative_spend
FROM sales_facts s
JOIN customer_dimension c ON s.customer_id = c.customer_id
JOIN orders_dimension o ON s.order_id = o.order_id;

-- top products by revenue within category
SELECT * FROM (
    SELECT 
        p.product_category,
        p.product_name,
        SUM(s.total_amount) AS total_revenue,
        DENSE_RANK() OVER (
            PARTITION BY p.product_category 
            ORDER BY SUM(s.total_amount) DESC
        ) AS sales_rank
    FROM sales_facts s
    JOIN product_dimension p ON s.product_id = p.product_id
    GROUP BY p.product_category, p.product_name
) ranked_products
WHERE sales_rank <= 3;

-- customers who spent more $1000 total
SELECT 
    c.customer_fullname,
    COUNT(s.sales_id) AS total_orders,
    SUM(s.total_amount) AS total_spent
FROM sales_facts s
JOIN customer_dimension c ON s.customer_id = c.customer_id
GROUP BY c.customer_id, c.customer_fullname
HAVING SUM(s.total_amount) > 1000
ORDER BY total_spent DESC;