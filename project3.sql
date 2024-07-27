select * from public.sales_dataset_rfm_prj;
--1
select productline, year_id, dealsize,
sum(sales) from public.sales_dataset_rfm_prj as revenue
group by  productline, year_id, dealsize
--2
select month_id, year_id, revenue,  
dense_rank() over (partition by year_id order by revenue desc) as order_number
from (select month_id, year_id,
sum (sales) as revenue from public.sales_dataset_rfm_prj 
group by month_id, year_id)
--3
select month_id, productline, year_id, revenue,
dense_rank () over (partition by year_id order by revenue desc)
from (select month_id, productline,year_id,
sum (sales) as revenue from public.sales_dataset_rfm_prj
where month_id ='11'
group by month_id, productline, year_id)
--4
select month_id, productline, year_id, revenue, country,
dense_rank () over (partition by year_id order by revenue desc)
from (select month_id, productline,year_id,country,
sum (sales) as revenue from public.sales_dataset_rfm_prj
where month_id ='11' and country = 'UK'
group by month_id, productline, year_id,country)
--5
with customer_rfm as
(select 
customername,
current_date - max(orderdate) as R,
count (ordernumber) as F,
sum(sales) as M
from public.sales_dataset_rfm_prj
group by customername),
rfm_score as (
select customername, 
ntile(5) over (order by R desc) as R_score,
ntile(5) over (order by F) as F_score,
ntile(5) over (order by M) as M_score
from customer_rfm),
rfm as (
select customername,
cast(r_score as varchar) || cast (f_score as varchar) || cast (m_score as varchar) as rfm_score
from rfm_score)

select a.customername, b.segment from 
rfm as a
join segment_score as b 
on a.rfm_score=b.scores
