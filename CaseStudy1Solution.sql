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

--Q3.What was the first item from the menu purchased by each customer?
WITH CTE_ITEM AS (
SELECT customer_id,order_date,s.product_id,product_name,
	RANK() OVER (PARTITION BY customer_id ORDER BY order_date ASC) AS rank_num
FROM sales s INNER JOIN menu u
on s.product_id=u.product_id
)
SELECT DISTINCT customer_id,product_name FROM CTE_ITEM
WHERE rank_num=1
