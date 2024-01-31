--ex1
select continent,
floor(avg(city.population))
from city 
inner join country 
on city.countrycode = country.code
group by continent
--ex2
  SELECT round(cast(count(t.email_id)as decimal)/COUNT(e.email_id) ,2) as confirm_rate
FROM emails as e 
left join texts as t 
on e.email_id=t.email_id and t.signup_action='Confirmed'
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
--mid-course test
--câu 1
select distinct replacement_cost, title from film
order by replacement_cost
--câu 2
select
sum(case
when replacement_cost between 9.99 and 19.99 then 1
else 0
end) as low,
sum(case
when replacement_cost between 20.00 and 24.99 then 1
else 0
end) as mediumn,
sum(case
when replacement_cost between 25.00 and 29.99 then 1
else 0
end) as high
from film
--câu 3
select f.title, f.length, c.name
from film as f
join film_category as fc on f.film_id=fc.film_id
join category as c on fc.category_id=c.category_id
order by length desc
--câu 4
select c.name,count(c.name)
from film as f
join film_category as fc on f.film_id=fc.film_id
join category as c on fc.category_id=c.category_id
group by c.name
order by count(c.name) desc
--câu 5
select a.actor_id,a.first_name,a.last_name, count(fa.film_id) 
from film_actor  as fa
join actor as a on fa.actor_id=a.actor_id
group by a.actor_id
order by count(fa.film_id) desc
--câu 6
select count(a.address_id) filter (where c.customer_id is null)
from address as a
left join customer as c
on a.address_id=c.address_id
--câu 7
select city, sum(p.amount)
from city 
join address as a on a.city_id=city.city_id
join customer as c on c.address_id=a.address_id
join payment as p on p.customer_id=c.customer_id
group by city 
order by sum(p.amount) desc
--câu 8
select city, country, sum(p.amount)
from city 
join address as a on a.city_id=city.city_id
join customer as c on c.address_id=a.address_id
join country on country.country_id=city.country_id
join payment as p on p.customer_id=c.customer_id
group by city, country
order by sum(p.amount) desc
