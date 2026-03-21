-- creating the database
create database retail;
use retail;

-- creating the products dimension table
create table product_dimension(
product_id int PRIMARY KEY,
product_name varchar(100),
product_category varchar(100),
price DECIMAL(10,2)
);

-- creating the customer dimension
create table customer_dimension(
customer_id int PRIMARY KEY,
customer_fullname varchar(100),
gender varchar(45)
);

-- creating location dimension
create table location_dimension(
location_id int PRIMARY KEY,
country varchar(100),
county varchar(100)
);

-- creating orders dimension
CREATE TABLE orders_dimension (
    order_id int PRIMARY KEY,
    order_date DATE,
    ship_date DATE
);

-- creating the fact table
create table sales_facts(
sales_id int primary key,
product_id int,
customer_id int,
location_id int,
order_id int,
quantity int,
total_amount int,

FOREIGN KEY (product_id) REFERENCES product_dimension(product_id),
FOREIGN KEY (customer_id) REFERENCES customer_dimension(customer_id),
FOREIGN KEY (location_id) REFERENCES location_dimension(location_id),
FOREIGN KEY (order_id) REFERENCES orders_dimension(order_id)
);
