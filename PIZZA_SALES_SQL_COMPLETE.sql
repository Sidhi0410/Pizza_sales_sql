use pizzahut;

-- Basic:
-- Retrieve the total number of orders placed.
SELECT count(ORDER_ID) as Total_oredr_placed
FROM pizzahut.orders;

-- Calculate the total revenue generated from pizza sales.-- 
SELECT 
    ROUND(SUM(order_details.QUALTITY * pizzas.price),
            1) AS Total_revenue
FROM
    pizzahut.pizzas
        JOIN
    order_details ON order_details.PIZZA_ID = pizzas.pizza_id;
-- Identify the highest-priced pizza.
use pizzahut;
SELECT pizza_types.name,pizzas.price
FROM pizza_types
join pizzas on pizza_types.pizza_type_id=pizzas.pizza_type_id
order by price desc limit 1;

-- Identify the most common pizza size ordered.
SELECT QUALTITY,count(order_details_id) as count
 FROM order_details
 group by QUALTITY; 
 
 SELECT size,count(order_details.ORDER_ID) as count
 FROM pizzahut.pizzas
 join order_details on order_details.PIZZA_ID=pizzas.pizza_id
 group by size
 order by count desc
 limit 1;

-- List the top 5 most ordered pizza types along with their quantities.	

SELECT pizza_types.name,sum(order_details.QUALTITY) as total
from pizza_types
join pizzas on pizzas.pizza_type_id=pizza_types.pizza_type_id
join order_details on order_details.PIZZA_ID=pizzas.pizza_id
group by name
order by total 	desc
limit 5;
-- Intermediate:
-- Join the necessary tables to find the total quantity of each pizza category ordered.
SELECT CATEGORY,COUNT(QUALTITY) AS Q
FROM PIZZA_TYPES
JOIN PIZZAS ON PIZZAS.PIZZA_TYPE_ID=pizza_types.pizza_type_id
JOIN order_details ON order_details.PIZZA_ID=pizzas.pizza_id
GROUP BY CATEGORY
ORDER BY Q DESC;
-- Determine the distribution of orders by hour of the day.
SELECT HOUR(ORDER_TIME),COUNT(ORDER_ID)
FROM ORDERS
GROUP BY HOUR(ORDER_TIME)
ORDER BY  HOUR(ORDER_TIME) DESC ;

-- Join relevant tables to find the category-wise distribution of pizzas.
SELECT CATEGORY,COUNT(NAME)
FROM pizzahut.pizza_types
GROUP BY CATEGORY;

-- Group the orders by date and calculate the average number of pizzas ordered per day.
SELECT ROUND(AVG(Q)) AS AVG_PIZZA_PER_DAY
FROM
(SELECT  ORDER_DATE,SUM(QUALTITY) AS Q
FROM ORDERS
JOIN ORDER_DETAILS ON ORDER_DETAILS.ORDER_ID=ORDERS.ORDER_ID
GROUP BY ORDER_DATE) AS OQ;
-- Determine the top 3 most ordered pizza types based on revenue.
SELECT pizza_types.NAME,SUM(order_details.QUALTITY*pizzas.PRICE) AS REVENUE
FROM pizza_types
JOIN pizzas ON pizzas.pizza_type_id=pizza_types.pizza_type_id
JOIN order_details ON order_details.PIZZA_ID=pizzas.pizza_id
GROUP BY pizza_types.NAME
ORDER BY REVENUE DESC
LIMIT 3;
-- Advanced:
-- Calculate the percentage contribution of each pizza type to total revenue.

SELECT pizza_types.category,SUM(order_details.QUALTITY*pizzas.price)/(SELECT ROUND(SUM(order_details.QUALTITY * pizzas.price),1) AS Total_revenue
FROM pizzahut.pizzas
JOIN order_details ON order_details.PIZZA_ID = pizzas.pizza_id)*100 as revenue
FROM pizza_types
JOIN pizzas ON pizzas.pizza_type_id=pizza_types.pizza_type_id
JOIN order_details ON order_details.PIZZA_ID=pizzas.pizza_id
group by category
order by revenue desc;
-- Analyze the cumulative revenue generated over time.
select ORDER_DATE,sum(revenue) over (order by ORDER_DATE)
from
(select orders.ORDER_DATE,sum(order_details.QUALTITY*pizzas.price) as Revenue
from order_details
join pizzas on order_details.PIZZA_ID=pizzas.pizza_id
join orders on orders.ORDER_ID=order_details.ORDER_ID
group by orders.ORDER_DATE) as sales;

-- Determine the top 3 most ordered pizza types based on revenue for each pizza category.
SELECT NAME,REVENUE
FROM
(SELECT CATEGORY,NAME,REVENUE,RANK() OVER(PARTITION BY CATEGORY ORDER BY REVENUE DESC) AS RN
FROM
(select pizza_types.category,pizza_types.name,sum(order_details.QUALTITY*pizzas.price) as Revenue
FROM pizza_types
JOIN pizzas ON pizzas.pizza_type_id=pizza_types.pizza_type_id
JOIN order_details ON order_details.PIZZA_ID=pizzas.pizza_id
group by pizza_types.category,pizza_types.name) AS A) AS B
Where rn>=3;