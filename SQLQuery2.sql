--Write a query to retrieve the list of orders along with the customer name and staff name for each order.

SELECT o.order_id, c.first_name AS customer_first_name, c.last_name AS customer_last_name, s.first_name AS staff_first_name, s.last_name AS staff_last_name
FROM sales.orders o
JOIN sales.customers c ON o.customer_id = c.customer_id
JOIN sales.staffs s ON o.staff_id = s.staff_id;


--Create a view that returns the total quantity and sales amount for each product.
CREATE VIEW product_sales_summary AS
SELECT p.product_id, p.product_name, SUM(oi.quantity) AS total_quantity, SUM(oi.quantity * p.list_price) AS total_sales_amount
FROM production.products p
JOIN sales.order_items oi ON p.product_id = oi.product_id
JOIN sales.orders o ON oi.order_id = o.order_id
WHERE o.order_status = 4 -- Filter for completed orders only
GROUP BY p.product_id, p.product_name;


--Write a stored procedure that accepts a customer ID and returns the total number of orders placed by that customer.
CREATE PROCEDURE GetTotalOrdersByCustomer
    @CustomerID INT,
    @TotalOrders INT OUTPUT
AS
BEGIN
    SELECT @TotalOrders = COUNT(*) 
    FROM sales.orders
    WHERE customer_id = @CustomerID;
END;

DECLARE @TotalOrders INT;

EXEC GetTotalOrdersByCustomer @CustomerID = 5, @TotalOrders = @TotalOrders OUTPUT;

SELECT @TotalOrders AS TotalOrders;


--Write a query to find the top 5 customers who have placed the most orders.

SELECT TOP 5 c.customer_id, c.first_name, c.last_name, COUNT(o.order_id) AS total_orders
FROM sales.customers c
JOIN sales.orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY COUNT(o.order_id) DESC;

--Create a view that shows the product details along with the total sales quantity and revenue for each product.


CREATE VIEW product_sales_summary AS
SELECT p.product_id, p.product_name, p.list_price, SUM(oi.quantity) AS total_sales_quantity, SUM(oi.quantity * p.list_price) AS total_revenue
FROM production.products p
JOIN sales.order_items oi ON p.product_id = oi.product_id
JOIN sales.orders o ON oi.order_id = o.order_id
WHERE o.order_status = 4
GROUP BY p.product_id, p.product_name, p.list_price;










