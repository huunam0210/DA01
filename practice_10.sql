--I ad hoc task
--bài 1
select concat( extract(year from created_at),'-', extract(month from created_at)) as year_month, count(user_id)  as total_user, sum(num_of_item) as total_order 
 from bigquery-public-data.thelook_ecommerce.orders
 where status = 'Complete' and concat( extract(year from created_at),'-', extract(month from created_at)) < '2022-5'
 group by concat( extract(year from created_at),'-', extract(month from created_at))
 order by year_month
 --bài 2
 select concat( extract(year from created_at),'-', extract(month from created_at)) as year_month, count(distinct user_id)  as distinct_total_user, sum(num_of_item)/count(order_id) as average_order_value
 from bigquery-public-data.thelook_ecommerce.orders
 where status = 'Complete' and concat( extract(year from created_at),'-', extract(month from created_at)) < '2022-5'
 group by concat( extract(year from created_at),'-', extract(month from created_at))
 order by year_month
 --bài 3
create temp table rank_age
 as with youngest as (select first_name, last_name, gender, age, dense_rank() over(order by age) as rank_age from bigquery-public-data.thelook_ecommerce.users ),
 oldest as (select first_name, last_name, gender, age, dense_rank() over(order by age desc) as rank_age from bigquery-public-data.thelook_ecommerce.users )
select first_name, last_name, gender, age, 'youngest' as tag from youngest
where rank_age=1
union all
select first_name, last_name, gender, age, 'oldest' as tag from oldest
where rank_age=1;

with youngest as (select count(tag) as total_youngest from rank_age where tag='youngest'),
oldest as (select count(tag) as total_oldest from rank_age where tag='oldest')

select youngest.total_youngest, oldest.total_oldest
from youngest, oldest
--bai 4
WITH cte AS (
  SELECT 
    t1.id AS product_id,
    t1.name,
    t1.cost,
    t1.retail_price,
    t2.created_at,
    CONCAT(EXTRACT(YEAR FROM t2.created_at), '-', EXTRACT(MONTH FROM t2.created_at)) AS year_month,
    (t1.retail_price - t1.cost) AS profit
  FROM 
    bigquery-public-data.thelook_ecommerce.products AS t1
  LEFT JOIN 
    bigquery-public-data.thelook_ecommerce.order_items AS t2
  ON 
    t1.id = t2.product_id
),
ranked_cte AS (
  SELECT
    year_month,
    product_id,
    name,
    cost,
    retail_price AS sale,
    profit,
    DENSE_RANK() OVER (PARTITION BY year_month ORDER BY profit asc) AS rank
  FROM 
    cte
)
SELECT
  year_month,
  product_id,
  name,
  cost,
  sale,
  profit,
  rank
FROM 
  ranked_cte
WHERE 
  rank < 6 and year_month is not null
  order by year_month
  --bai 5
SELECT 
  FORMAT_TIMESTAMP('%d-%m-%Y', created_at) AS day_month_year, 
  product_category, 
  SUM(product_retail_price) AS revenue  
FROM 
  bigquery-public-data.thelook_ecommerce.inventory_items
WHERE 
   DATE(created_at) BETWEEN DATE_SUB(DATE '2022-04-15', INTERVAL 3 MONTH) AND DATE '2022-04-15'
GROUP BY 
  day_month_year, product_category
  order by day_month_year
--II tao metric truoc khi su dung dash board
create view vw_ecommerce_analyst as(
with cte as(
select extract(month from a.created_at ) as Month,
extract (year from a.created_at) as Year,
category as Product_category, 
sum(sale_price) as TPV, count(a.id) as TPO,
sum(cost) as total_cost,
sum(retail_price - cost) as total_profit,
sum(retaiL_price - cost)/sum(cost) as Profit_to_cost_ratio,
from bigquery-public-data.thelook_ecommerce.order_items as a  
left join bigquery-public-data.thelook_ecommerce.products as b
on a.product_id=b.id
group by Month, Year,category
order by Year, Month)
  
  select *, 
  round((TPV - lag (TPV) over (partition by product_category order by year,month) )/lag (TPV) over (partition by product_category order by year,month)*100,2) as  Revenue_growth,
  round((TPO - lag (TPO) over (partition by product_category order by year,month))/lag (TPO) over (partition by product_category order by year,month)*100,2) as Order_growth
  from cte)
--cohort analyst
with cte as (select concat( extract(year from first_purchase_date),'-', extract(month from first_purchase_date))  as cohort_date,
 user_id,
(extract(year from created_at)-extract(year from first_purchase_date))*12 +(extract(month from created_at)-extract(month from first_purchase_date))+1 as index
from (select *, min(created_at) over (partition by user_id) as first_purchase_date from bigquery-public-data.thelook_ecommerce.order_items where status='Complete'))

select cohort_date, index, count(distinct user_id) as cnt
from cte 
where index < 5
group by cohort_date, index
order by cohort_date, index

select *, concat( extract(year from created_at),'-', extract(month from created_at)) from bigquery-public-data.thelook_ecommerce.orders
where concat( extract(year from created_at),'-', extract(month from created_at))='2019-3'
