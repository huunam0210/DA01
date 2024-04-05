--ex1 
select
round(100*cast(sum (case
when order_date=customer_pref_delivery_date then 1 else 0 
end) as decimal) /count(distinct customer_id),2) as immediate_percentage
from (select *,
dense_rank() over(partition by customer_id order by order_date, customer_pref_delivery_date) as first_order
from delivery) as a
where a.first_order=1
--ex2
with first_date as (select *, event_date - first_value(event_date) over(partition by player_id order by event_date) as gap_day
from activity)
select round( cast(count(distinct player_id) as decimal)/(select count(distinct player_id) from activity),2) as fraction
from first_date
where gap_day=1
 --ex3
 select case
when id%2 <>0 and id = (select count(id) from seat) then id
 when id%2=0 then id-1
 else id +1
 end as id,
 student
 from  seat order by id
--ex4
with a as (select visited_on,sum(amount) as amount from customer group by visited_on)
select a.visited_on, 
sum(amount) over (order by visited_on range between interval '6' day preceding and current row) as amount, 
round(cast(sum(amount) over (order by visited_on range between interval '6' day preceding and current row) as decimal)/7,2) as average_amount
from a
order by visited_on
offset 6
 --ex5
 select round(cast(sum(tiv_2016) as decimal),2) as tiv_2016 from insurance
where tiv_2015 in  (select tiv_2015 from insurance group by tiv_2015 having count(tiv_2015)>1 )
and (lat, lon) in (select lat, lon from insurance group by lat, lon having count (*)=1)
--ex6
with earner as (select t1.name as employee, t1.salary as salary,t2.name as department, 
dense_rank() over(partition by t2.name order by salary desc) as rank
from employee as t1
join department as t2
on t1.departmentid=t2.id)

select department, employee, salary
from earner
where rank<=3
order by department, employee
--ex7
with maxweight as (select
*, sum(weight) over(order by turn rows between unbounded preceding and current row ) as limitweight
from queue)
select person_name from maxweight 
where limitweight<=1000 
order by turn desc 
limit 1
--ex8
with cte as (select *,
rank() over(partition by product_id order by change_date desc) as rank
from products
where change_date<='2019-08-16')

select product_id, new_price as price from cte
where rank=1
 
 union 

 select product_id, 10 as price from products
 where product_id not in (select product_id  from cte)
