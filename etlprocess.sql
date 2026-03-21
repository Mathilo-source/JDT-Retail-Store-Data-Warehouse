CREATE TABLE staging_area (
	product_id int,
    product_name varchar(100),
    product_category varchar(100),
    price DECIMAL(10,2),
    customer_id int,
    customer_fullname varchar(100),
    gender varchar(45),
    location_id int,
    country varchar(100),
    county varchar(100),
    order_id int,
    order_date DATE,
    ship_date DATE,
    sales_id int,
    quantity int,
    total_amount int
);

INSERT IGNORE INTO product_dimension
SELECT
product_id ,
product_name,
product_category ,
price
FROM staging_area;

INSERT IGNORE INTO customer_dimension
SELECT
customer_id,
customer_fullname,
gender
FROM staging_area;

INSERT IGNORE INTO location_dimension
SELECT
location_id ,
country,
county
FROM staging_area;


INSERT IGNORE INTO orders_dimension
SELECT
order_id ,
order_date ,
ship_date
FROM staging_area;

INSERT INTO sales_facts
SELECT
sales_id,
product_id,
customer_id,
location_id,
order_id,
quantity,
total_amount
FROM staging_area;
