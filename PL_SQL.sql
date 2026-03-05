Use Gupta;
CREATE TABLE customers (
    customer_id NUMBER PRIMARY KEY,
    name VARCHAR2(50),
    email VARCHAR2(100)
);

CREATE TABLE products (
    product_id NUMBER PRIMARY KEY,
    product_name VARCHAR2(100),
    price NUMBER(10,2),
    stock_qty NUMBER
);

CREATE TABLE orders (
    order_id NUMBER PRIMARY KEY,
    customer_id NUMBER,
    order_date DATE,
    status VARCHAR2(20),
    FOREIGN KEY (customer_id)
    REFERENCES customers(customer_id)
);

CREATE TABLE order_items (
    order_item_id NUMBER PRIMARY KEY,
    order_id NUMBER,
    product_id NUMBER,
    quantity NUMBER,
    unit_price NUMBER(10,2),
    FOREIGN KEY(order_id) REFERENCES orders(order_id),
    FOREIGN KEY(product_id) REFERENCES products(product_id)
);

Select * from customers;
INSERT INTO customers VALUES (1,'Sneha','sneha@gmail.com');

INSERT INTO products VALUES (101,'Laptop',50000,10);
INSERT INTO products VALUES (102,'Mouse',500,50);

CREATE OR REPLACE FUNCTION fn_order_total(p_order_id NUMBER)
RETURN NUMBER
IS
   v_total NUMBER;
BEGIN
   SELECT SUM(quantity * unit_price)
   INTO v_total
   FROM order_items
   WHERE order_id = p_order_id;

   RETURN v_total;
END;
/

CREATE OR REPLACE TRIGGER trg_reduce_stock
AFTER INSERT ON order_items
FOR EACH ROW
BEGIN
   UPDATE products
   SET stock_qty = stock_qty - :NEW.quantity
   WHERE product_id = :NEW.product_id;
END;
/

CREATE OR REPLACE PROCEDURE place_order(
    p_customer_id NUMBER,
    p_product_id NUMBER,
    p_qty NUMBER
)
IS
   v_order_id NUMBER;
   v_price NUMBER;
BEGIN
   SELECT price INTO v_price
   FROM products
   WHERE product_id = p_product_id;

   SELECT NVL(MAX(order_id),0)+1 INTO v_order_id FROM orders;

   INSERT INTO orders
   VALUES(v_order_id, p_customer_id, SYSDATE, 'PLACED');

   INSERT INTO order_items
   VALUES(v_order_id, v_order_id, p_product_id, p_qty, v_price);

   COMMIT;
END;
/

EXEC place_order(1,101,1);

CREATE OR REPLACE PACKAGE order_pkg AS
   PROCEDURE place_order(
       p_customer_id NUMBER,
       p_product_id NUMBER,
       p_qty NUMBER);

   FUNCTION get_total(p_order_id NUMBER)
   RETURN NUMBER;
END order_pkg;
/

CREATE OR REPLACE PACKAGE BODY order_pkg AS

PROCEDURE place_order(
    p_customer_id NUMBER,
    p_product_id NUMBER,
    p_qty NUMBER)
IS
   v_price NUMBER;
   v_order_id NUMBER;
BEGIN
   SELECT price INTO v_price
   FROM products
   WHERE product_id = p_product_id;

   SELECT NVL(MAX(order_id),0)+1 INTO v_order_id FROM orders;

   INSERT INTO orders VALUES
   (v_order_id,p_customer_id,SYSDATE,'PLACED');

   INSERT INTO order_items VALUES
   (v_order_id,v_order_id,p_product_id,p_qty,v_price);

END;

FUNCTION get_total(p_order_id NUMBER)
RETURN NUMBER
IS
   v_total NUMBER;
BEGIN
   SELECT SUM(quantity*unit_price)
   INTO v_total
   FROM order_items
   WHERE order_id=p_order_id;

   RETURN v_total;
END;

END order_pkg;
/


SELECT c.name,
       o.order_id,
       p.product_name,
       oi.quantity
FROM customers c
JOIN orders o ON c.customer_id=o.customer_id
JOIN order_items oi ON o.order_id=oi.order_id
JOIN products p ON oi.product_id=p.product_id;

SELECT p.product_name,
       SUM(oi.quantity) total_sold,
       SUM(oi.quantity*oi.unit_price) revenue
FROM order_items oi
JOIN products p
ON oi.product_id=p.product_id
GROUP BY p.product_name;

CREATE INDEX idx_orders_customer
ON orders(customer_id);

EXPLAIN PLAN FOR
SELECT * FROM orders WHERE customer_id=1;

SELECT * FROM TABLE(DBMS_XPLAN.DISPLAY);
