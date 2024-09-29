CREATE DATABASE pizza_sales;

CREATE TABLE orders (
order_id INT PRIMARY KEY NOT NULL,
order_date DATE NOT NULL,
order_time TIME NOT NULL
);

CREATE TABLE order_details (
order_details_id INT NOT NULL,
order_id INT NOT NULL,
pizza_id TEXT NOT NULL,
quantity INT NOT NULL,
PRIMARY KEY(order_details_id)
);


-- Retrieve the total number of order placed.

SELECT COUNT(order_id) as total_orders FROM orders;


-- Calculate the total revenue generated from pizza sales 

SELECT SUM(order_details.quantity * pizzas.price) AS total_sales
FROM order_details JOIN pizzas
ON order_details.pizza_id = pizzas.pizza_id;


-- Identify the higest priced pizza.

SELECT pizza_types.name, pizzas.price
FROM pizza_types JOIN pizzas
ON pizza_types.pizza_type_id = pizzas.pizza_type_id
ORDER BY price DESC LIMIT 1;


-- List the top 5 most ordered pizza types along with their quantities.

SELECT pizza_types.name, SUM(order_details.quantity) AS quantity
FROM pizza_types JOIN pizzas
ON pizza_types.pizza_type_id = pizzas.pizza_type_id
JOIN order_details
ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pizza_types.name ORDER BY quantity DESC LIMIT 5;


-- Determine the distribution of orders by hour of the day. 

SELECT HOUR(order_time), COUNT(order_id)FROM orders
GROUP BY HOUR(order_time);


-- Join the necessary tables to find the total quantity of each pizza category ordered.

SELECT pizza_types.category, SUM(order_details.quantity) AS quantity
FROM pizza_types JOIN pizzas 
ON pizza_types.pizza_type_id = pizzas.pizza_type_id
JOIN order_details
ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.category ORDER BY quantity DESC;


-- Find the category-wise distribution of pizzas.

SELECT category, COUNT(category) FROM pizza_types
GROUP BY category;


-- Group the orders by date and calculate the average number of pizzas ordered per day. 

SELECT AVG(total_quantity) AS average_pizza_ordered_per_day FROM
(SELECT orders.order_date, SUM(order_details.quantity) AS total_quantity FROM orders 
JOIN order_details ON orders.order_id = order_details.order_id
GROUP BY orders.order_date) AS order_quantity;


-- Determine the top 3 most ordered pizza types based on revenue

SELECT pizza_types.name, SUM(order_details.quantity * pizzas.price) AS total_sales
FROM pizza_types
JOIN pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
JOIN order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.name ORDER BY total_sales DESC LIMIT 3;


-- Calculate the percentage contribution of each pizza type to total revenue
-- (revenue from each pizza type/total revenue)*100 

SELECT pizza_types.name, (SUM(order_details.quantity * pizzas.price) / (SELECT SUM(order_details.quantity * pizzas.price) 
FROM order_details JOIN pizzas
ON order_details.pizza_id = pizzas.pizza_id)) * 100 AS revenue_percentage
FROM pizza_types
JOIN pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
JOIN order_details ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizza_types.name ORDER BY revenue_percentage;


-- Analyze the cumulative revenue generated over time

SELECT order_date, SUM(revenue) OVER(ORDER BY order_date) as cum_revenue
FROM
(SELECT orders.order_date, SUM(order_details.quantity*pizzas.price) AS revenue FROM orders 
JOIN order_details ON orders.order_id = order_details.order_id
JOIN pizzas ON pizzas.pizza_id = order_details.pizza_id
GROUP BY orders.order_date ORDER BY order_date) AS date_wise_revenue;


















