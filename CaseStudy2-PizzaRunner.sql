--Q1.How many pizzas were ordered?
SELECT COUNT(pizza_id) AS Total_Pizzas FROM customer_orders

--Q2.How many unique customer orders were made?
SELECT COUNT(DISTINCT(order_id)) FROM customer_orders
