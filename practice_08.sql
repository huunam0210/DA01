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
--ex4
with a as (select visited_on,sum(amount) as amount from customer group by visited_on)
select a.visited_on, 
sum(amount) over (order by visited_on range between interval '6' day preceding and current row) as amount, 
round(cast(sum(amount) over (order by visited_on range between interval '6' day preceding and current row) as decimal)/7,2) as average_amount
from a
order by visited_on
offset 6
