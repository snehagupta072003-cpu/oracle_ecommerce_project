🛒 E-Commerce Order Processing System (Oracle SQL & PL/SQL)
📌 Project Overview

This project demonstrates an E-Commerce Order Processing System implemented using Oracle SQL and PL/SQL. The system simulates how an online store manages customers, products, orders, and inventory while using database programming features such as functions, procedures, triggers, and packages.

The project highlights core database concepts including data relationships, automation with triggers, transaction management, and query optimization. 

Oracle_project

🎯 Objectives

Design a relational database for an e-commerce system

Implement order management logic using PL/SQL

Automatically update inventory using triggers

Calculate order totals using functions

Organize business logic using packages

Generate sales reports and analytical queries

🗄️ Database Schema

The system consists of four main tables:

1️⃣ Customers

Stores customer information.

Column	Description
customer_id	Unique customer ID
name	Customer name
email	Customer email
2️⃣ Products

Stores product details and inventory.

Column	Description
product_id	Unique product ID
product_name	Product name
price	Product price
stock_qty	Available stock
3️⃣ Orders

Stores order information.

Column	Description
order_id	Unique order ID
customer_id	Customer placing the order
order_date	Date of order
status	Order status
4️⃣ Order Items

Stores items included in each order.

Column	Description
order_item_id	Unique order item ID
order_id	Order reference
product_id	Product reference
quantity	Quantity ordered
unit_price	Price at time of order
⚙️ PL/SQL Features Implemented
🔹 Function – Calculate Order Total

A function calculates the total bill of an order.

fn_order_total(order_id)

It returns:

SUM(quantity × unit_price)
🔹 Trigger – Automatic Inventory Update

Trigger automatically reduces product stock whenever a new order item is inserted.

Trigger Name: trg_reduce_stock
Event: AFTER INSERT ON order_items

Purpose:

Maintain real-time inventory levels.

🔹 Procedure – Place Order

Procedure handles order creation logic.

place_order(customer_id, product_id, quantity)

Steps performed:

Retrieve product price

Generate new order ID

Insert order

Insert order item

Commit transaction

📦 Package – Order Management

A PL/SQL package groups related procedures and functions.

Package Name
order_pkg
Contains

Procedure

place_order()

Function

get_total(order_id)

Packages improve modularity, maintainability, and performance.

📊 Analytical Queries
Customer Order Details
SELECT c.name,
       o.order_id,
       p.product_name,
       oi.quantity
FROM customers c
JOIN orders o ON c.customer_id=o.customer_id
JOIN order_items oi ON o.order_id=oi.order_id
JOIN products p ON oi.product_id=p.product_id;
Sales Report
SELECT p.product_name,
       SUM(oi.quantity) total_sold,
       SUM(oi.quantity*oi.unit_price) revenue
FROM order_items oi
JOIN products p
ON oi.product_id=p.product_id
GROUP BY p.product_name;

This report shows:

total units sold

total revenue generated

⚡ Query Optimization

Index created to improve query performance:

CREATE INDEX idx_orders_customer
ON orders(customer_id);

Execution plan is analyzed using:

EXPLAIN PLAN
DBMS_XPLAN.DISPLAY
🧪 Sample Data

Example records used for testing:

Customers

Sneha – sneha@gmail.com

Products

Laptop – ₹50000
Mouse – ₹500

Orders are created using:

EXEC place_order(1,101,1);
🛠️ Tools Used

Oracle Database 21c

Oracle SQL Developer

SQL

PL/SQL

📚 Concepts Demonstrated

Relational database design

Primary & foreign keys

Joins

PL/SQL procedures

Functions

Triggers

Packages

Indexing

Query optimization

Sales analytics

🚀 Future Improvements

Possible enhancements:

Add payment table

Add order status tracking

Implement customer login system

Create dashboard reports

Add product categories
