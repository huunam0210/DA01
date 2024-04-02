--ex1 
select
round(100*cast(sum (case
when order_date=customer_pref_delivery_date then 1 else 0 
end) as decimal) /count(distinct customer_id),2) as immediate_percentage
from (select *,
dense_rank() over(partition by customer_id order by order_date, customer_pref_delivery_date) as first_order
from delivery) as a
where a.first_order=1
