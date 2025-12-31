select * from customer


--Q1. total revenue generated male vs female?
select gender , SUM(purchase_amount) as revenue
from customer
group by gender

--Q2. which customer used a discount but still spent more than the average purchase amount ?
select customer_id , purchase_amount 
from customer
where discount_applied = 'Yes' and purchase_amount >=(select Avg(purchase_amount) from customer)

--Q3. which are the top 5 products with highest average review rating
select item_purchased , ROUND(AVG(review_rating::numeric),2) as "Averag Product Rating"
from customer
group by item_purchased
order by avg(review_rating) desc
limit 5;

--Q4. compare the average purchase amount between standard and express shipping
select shipping_type,
ROUND(AVG(purchase_amount),2)
from customer
where shipping_type in('Standard','Express')
group by shipping_type

--Q5. compare average spend and total revenue  between subscriber and non subscriber?
select subscription_status,
COUNT(customer_id) as total_customers,
ROUND(AVG(purchase_amount),2) as average_spend,
ROUND(SUM(purchase_amount),2) as total_revenue
from customer
group by subscription_status
order by total_revenue,average_spend desc

--Q6.which 5 products have the highest percentage of purchases with discount applied?
select item_purchased,
ROUND(100 * SUM(CASE WHEN discount_applied = 'Yes' THEN 1 ELSE 0 END)/COUNT(*) ,2) as discount_rate
from customer
group by item_purchased
order by discount_rate desc
limit 5

--Q7.segment customers into new,returning and loyal based on their total
--number of previous purchases and show the count of each segment.
--1 times new,2-10 returning , 10+ loyal
with customer_type as (
select customer_id,previous_purchases,
CASE 
      WHEN previous_purchases = 1 THEN 'New'
	  WHEN previous_purchases BETWEEN 2 AND 10  THEN 'Returning'
      ELSE 'Loyal'
	  END AS customer_segment
from customer
)
select customer_segment,count(*) as Number_of_Customers
from customer_type
group by customer_segment

--Q8. what are the top 3 most purchased products within each category?
with item_count as (
select category,
item_purchased,
COUNT(customer_id) as total_orders,
ROW_NUMBER() over (partition by category order by count(customer_id)DESC) as item_rank
from customer
group by category,item_purchased
)
select item_rank,category , item_purchased , total_orders
from item_count
where item_rank <=3;

--Q9. are customers who are repeat buyers (more than 5 previous purchase) also likely to subscribe?
select subscription_status,
count(customer_id) as repeat_buyers
from customer
where previous_purchases>5
group by subscription_status

--Q10. revenue contribution by each age group!
select age_group,
sum(purchase_amount) as total_revenue
from customer
group by age_group
order by total_revenue DESC

