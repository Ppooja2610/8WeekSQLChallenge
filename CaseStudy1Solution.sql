--What is the total amount each customer spent at the restaurant?
SELECT s.customer_id,SUM(price) FROM sales s INNER JOIN  menu m
on s.product_id=m.product_id
GROUP BY 1
ORDER BY 1
