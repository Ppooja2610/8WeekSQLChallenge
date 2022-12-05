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
