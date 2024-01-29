--ex1
select continent,
floor(avg(city.population))
from city 
inner join country 
on city.countrycode = country.code
group by continent
--ex3
SELECT
age_bucket, 
Round(100*sum(time_spent) filter (where activity_type='send')/ sum(time_spent),2) as send_perc,
round(100*sum(time_spent) filter (where activity_type='open')/ sum(time_spent),2) as open_perc
FROM activities as a 
join age_breakdown as b 
on a.user_id=b.user_id
where a.activity_type in ('send','open')
group by b.age_bucket
--ex4
SELECT customer_id, count(distinct product_category)
FROM customer_contracts as c
join products as p
on c.product_id=p.product_id
group by customer_id
having count(distinct product_category)=3
--ex5
select  e1.employee_id, e1.name,
count(e2.employee_id) as reports_count,
round(avg(e2.age),0) as average_age
from employees as e1
left join employees as e2
on e1.employee_id = e2. reports_to
group by e1.employee_id, e1.name
having count(e2.employee_id)>0
order by e1.employee_id
--ex6
select product_name, 
sum(o.unit) as unit
from products as p
join orders as o
on p.product_id=o.product_id
where extract(YEAR from order_date)='2020' and extract(month from order_date)='02'
group by product_name
having sum(o.unit) >=100
--ex7
SELECT p1.page_id
FROM pages as p1
left join page_likes as p2
on p1.page_id=p2.page_id
where p2.user_id is null
