--Q1.What is the total amount each customer spent at the restaurant?
SELECT s.customer_id,SUM(price) FROM sales s INNER JOIN  menu m
on s.product_id=m.product_id
GROUP BY 1
ORDER BY 1

--Q2.How many days has each customer visited the restaurant?
SELECT customer_id,COUNT(DISTINCT(order_date)) as Num_Days
FROM sales
GROUP BY 1
ORDER BY 1
