--Sample Queries
SELECT * FROM runners
SELECT * FROM customer_orders
SELECT * FROM runner_orders
SELECT * FROM pizza_names 
SELECT * FROM pizza_recipes 
SELECT * FROM pizza_toppings


--Q1.How many pizzas were ordered?
SELECT COUNT(pizza_id) AS Total_Pizzas FROM customer_orders
----------------------------------------------------
--Q2.How many unique customer orders were made?
SELECT COUNT(DISTINCT(order_id)) FROM customer_orders
-----------------------------------------------------
--Q3.How many successful orders were delivered by each runner?
SELECT runner_id,COUNT(order_id) AS Successful_Orders
FROM runner_orders
WHERE cancellation IS NULL
GROUP BY runner_id
ORDER BY runner_id
-----------------------------------------------------
--Q4.How many of each type of pizza was delivered?
SELECT pizza_id,COUNT(pizza_id) AS Number_of_Pizzas
FROM customer_orders
GROUP BY pizza_id
ORDER BY pizza_id
--------------------------------------------------
--Q5.How many Vegetarian and Meatlovers were ordered by each customer?
SELECT customer_id,
SUM (CASE WHEN pizza_id=1 THEN 1 ELSE 0 END) AS Number_of_Meatlovers,
SUM (CASE WHEN pizza_id=2 THEN 1 ELSE 0 END) AS Number_of_Vegetarian
FROM customer_orders
GROUP BY customer_id
ORDER BY customer_id
-------------------------------------------------
--Q6.What was the maximum number of pizzas delivered in a single order?
SELECT order_id,COUNT(pizza_id) AS Maximium_Pizzas
FROM customer_orders
GROUP BY order_id
ORDER BY COUNT(pizza_id) DESC
LIMIT 1
--------------------------------------------------

--Q7.For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
SELECT customer_id,SUM (CASE WHEN exclusions='' OR extras='' THEN 1 ELSE 0 END) AS Pizza_Nochanges,
SUM (CASE WHEN exclusions IS NOT NULL AND extras IS NOT NULL THEN 1 ELSE 0 END) AS Pizza_Withchanges
FROM customer_orders
GROUP BY customer_id
ORDER BY customer_id
---------------------------------------------------------------
--Q8.How many pizzas were delivered that had both exclusions and extras?
SELECT customer_id,
SUM (CASE WHEN exclusions IS NOT NULL AND extras IS NOT NULL THEN 1 ELSE 0 END) AS Pizza_Withchanges
FROM customer_orders
INNER JOIN runner_orders USING (order_id)
WHERE cancellation IS NULL
GROUP BY customer_id
ORDER BY customer_id
-----------------------------------------------------------
