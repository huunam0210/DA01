--ex1
with job_count_cte as
(SELECT company_id, title, description, count(job_id) as job_count
FROM job_listings
group by company_id, title, description)
select count(job_count_cte.company_id) as count_duplicate_companies
from job_count_cte
where job_count>=2
--ex2
with top_category_1
As (SELECT 
category, product, 
sum(spend) as total_spend
FROM product_spend
where extract (year from transaction_date)='2022' and category='appliance'
group by category,product
order by total_spend desc
limit 2),
top_category_2
As (SELECT 
category, product, 
sum(spend) as total_spend
FROM product_spend
where extract (year from transaction_date)='2022' and category='electronics'
group by category,product
order by total_spend desc
limit 2)
select category, product, total_spend from top_category_1
union ALL
select category, product, total_spend from top_category_2
--ex4
select page_id
from (select * from pages as p1
left join page_likes as p2 
on p1.page_id=p2.page_id) as new_table
where user_id is null
--ex5
SELECT
  EXTRACT(MONTH FROM current_month.event_date) AS month,
 count(distinct current_month.user_id)
FROM user_actions AS current_month
WHERE EXISTS (
  SELECT last_month.user_id
  FROM user_actions AS last_month
  WHERE last_month.user_id = current_month.user_id
  and extract(month from last_month.event_date)=extract(month from current_month.event_date)-1)
  and extract(month  from current_month.event_date)='7' 
group by month
--ex6
select  
to_char(transactions.trans_date, 'YYYY-MM') as month, country,
count(state) as trans_count,
sum(case when state='approved' then 1 else 0 end) as approved_count,
sum(amount) as trans_total_amount ,
sum(case when state='approved' then amount else 0 end) as approved_total_amount
 from transactions
 group by month, country
--ex7
with first_year_product
as(select product_id,
min(year) as first_year
from sales
group by product_id)
select sales.product_id, sales.year as first_year, sales.quantity,sales.price
from sales
JOIN first_year_product  ON sales.product_id = first_year_product.product_id
WHERE first_year_product.first_year = sales.year
--ex8
select customer_id from customer
group by customer_id
having count(distinct product_key)= (select count(product_key) from product)
--ex9
select employee_id
from employees
where salary<30000
and manager_id not in (select employee_id from employees)
order by employee_id
--ex11
(select name as results from users
left join movierating on users.user_id=movierating.user_id
group by users.user_id, users.name
order by count(movie_id) desc, users.name asc
limit 1)
union all
(select title as results from movies
left join movierating on movies.movie_id=movierating.movie_id
where to_char(created_at,'YYYY-MM')='2020-02'
group by movies.movie_id, movies.title
order by avg(movierating.rating) desc, movies.title asc
limit 1) 
--ex12
with a
as (select requester_id as id from RequestAccepted
union all
select accepter_id as id from RequestAccepted)
select id, count(id) as num from a
group by id
order by num desc
limit 1


