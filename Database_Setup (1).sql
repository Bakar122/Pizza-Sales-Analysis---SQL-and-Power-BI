-- Pizza Sales Analysis | PostgreSQL
-- Create a database named pizza_sales in pgAdmin and connect to it.
-- Run this script in a new database before importing the CSV files.
BEGIN;
CREATE TABLE pizza_types (
    pizza_type_id text PRIMARY KEY,
    name text NOT NULL,
    category text NOT NULL,
    ingredients text
);
CREATE TABLE pizzas (
    pizza_id text PRIMARY KEY,
    pizza_type_id text NOT NULL REFERENCES pizza_types(pizza_type_id),
    size text NOT NULL,
    price numeric(10,2) NOT NULL CHECK (price >= 0)
);
CREATE TABLE orders (
    order_id integer PRIMARY KEY,
    date date NOT NULL,
    time time NOT NULL
);
CREATE TABLE order_details (
    order_details_id integer PRIMARY KEY,
    order_id integer NOT NULL REFERENCES orders(order_id),
    pizza_id text NOT NULL REFERENCES pizzas(pizza_id),
    quantity integer NOT NULL CHECK (quantity > 0)
);
COMMIT;

-- Import via pgAdmin: right-click each table > Import/Export Data.
-- Choose Import, CSV format, Header enabled, comma delimiter,
-- and double-quote quote/escape characters. Preserve column order.
-- Import in this order to satisfy foreign keys:
-- 1. pizza_types.csv (choose WIN1252 if UTF8 fails)
-- 2. pizzas.csv
-- 3. orders.csv
-- 4. order_details.csv

-- Run these checks AFTER importing all four files:
SELECT 'pizza_types' AS table_name, COUNT(*) AS row_count FROM pizza_types
UNION ALL SELECT 'pizzas', COUNT(*) FROM pizzas
UNION ALL SELECT 'orders', COUNT(*) FROM orders
UNION ALL SELECT 'order_details', COUNT(*) FROM order_details;

-- Revenue reconciliation:
SELECT SUM(p.price * od.quantity) AS total_revenue,
       SUM(od.quantity) AS total_pizzas_sold,
       COUNT(DISTINCT od.order_id) AS total_orders
FROM order_details od JOIN pizzas p ON p.pizza_id = od.pizza_id;

-- Next: execute Pizza_Sales_Analysis.sql in the same database.
