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

--Q4.What is the most purchased item on the menu and how many times was it purchased by all customers?
SELECT product_name,COUNT(s.product_id) AS Number_Orders FROM sales s INNER JOIN menu u
on s.product_id=u.product_id
GROUP BY product_name
ORDER BY Number_Orders DESC
LIMIT 1

--Q5.Which item was the most popular for each customer?
WITH CTE_Popular AS (
		SELECT s.customer_id,s.product_id,m.product_name,COUNT(*) ,
		RANK() OVER (PARTITION BY s.customer_id ORDER BY COUNT(*) DESC ) AS rank_num
		FROM sales s LEFT JOIN menu m
		ON s.product_id=m.product_id
		GROUP BY s.customer_id,s.product_id,m.product_name
		ORDER BY s.customer_id
		)
SELECT * FROM CTE_Popular
WHERE rank_num=1
GROUP BY (CTE_Popular.customer_id, CTE_Popular.product_id, CTE_Popular.product_name)

--Q6.Which item was purchased first by the customer after they became a member?
WITH CTE_firstorder AS (
		SELECT s.customer_id
		,u.product_name
		,RANK() OVER (PARTITION BY s.customer_id ORDER BY order_date) AS rank_num
		FROM sales s INNER JOIN  members m
		ON s.customer_id=m.customer_id
		INNER JOIN menu u 
		ON s.product_id=u.product_id
		WHERE s.order_date>=m.join_date
)
SELECT customer_id,product_name FROM CTE_firstorder
WHERE rank_num=1

--Q7.Which item was purchased just before the customer became a member?
WITH CTE_firstorder AS (
		SELECT s.customer_id
		,u.product_name
		,RANK() OVER (PARTITION BY s.customer_id ORDER BY order_date) AS rank_num
		FROM sales s INNER JOIN  members m
		ON s.customer_id=m.customer_id
		INNER JOIN menu u 
		ON s.product_id=u.product_id
		WHERE s.order_date<=m.join_date
)
SELECT customer_id,product_name FROM CTE_firstorder
WHERE rank_num=1
GROUP BY (customer_id,product_name)

--Q8.What is the total items and amount spent for each member before they became a member?
SELECT s.customer_id,COUNT(product_name) AS Total_Items,CONCAT('$',SUM(price)) AS Total_Price 
FROM sales s INNER JOIN  members m
		ON s.customer_id=m.customer_id
		INNER JOIN menu u 
		ON s.product_id=u.product_id
		WHERE s.order_date<m.join_date
		GROUP BY s.customer_id
		ORDER BY s.customer_id
		
--Q9.If each $1 spent equates to 10 points and sushi has a 2x points multiplier
-- how many points would each customer have?
SELECT s.customer_id,SUM(u.price) AS Total_Price,
  SUM(CASE WHEN (u.product_name='curry' OR  u.product_name='ramen') THEN (u.price*10)
				ELSE (u.price*20) END) as Total_Points
FROM sales s LEFT JOIN members m 
ON s.customer_id=m.customer_id
INNER JOIN menu u 
ON u.product_id=s.product_id
WHERE order_date>join_date
GROUP BY s.customer_id
ORDER BY s.customer_id	

--Q10.In the first week after a customer joins the program (including their join date)
--they earn 2x points on all items, not just sushi 
-- how many points do customer A and B have at the end of January?
WITH CTE_members AS(
SELECT customer_id,join_date,
join_date+6 as last_date
	from members)
SELECT s.customer_id,
	SUM (CASE 	WHEN order_date BETWEEN join_date AND last_date THEN (u.price*20)
				WHEN (order_date NOT BETWEEN join_date AND last_date) AND u.product_name='sushi' THEN (u.price*20)  
				WHEN (order_date NOT BETWEEN join_date AND last_date) AND u.product_name!='sushi' THEN (u.price*10) END) AS total_points
FROM sales s 
INNER JOIN  menu u 
ON s.product_id=s.product_id
INNER JOIN CTE_members c 
ON c.customer_id=s.customer_id
WHERE order_date>=join_date AND join_date<= '2021-01-31'
GROUP BY s.customer_id
ORDER BY s.customer_id
