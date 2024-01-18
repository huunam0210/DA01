--ex1
select name
from students
where marks>75
order by right(name,3), id
--ex2
select user_id, 
concat(upper(left(name,1)), lower(right(name,length(name)-1))) as name
from users
order by user_id
--ex3
SELECT manufacturer, 
'$'||ROUND(SUM(total_sales)/1000000,0) ||' '|| 'million' as sale
FROM pharmacy_sales
GROUP BY manufacturer
--ex4
select extract(month from submit_date) as mth, product_id,
round(avg(stars),2) as avg_stars
from reviews
group by mth, product_id
order by mth, product_id
--ex5
SELECT sender_id, count(message_id) FROM messages
where extract(year from sent_date)=2022 and extract(month from sent_date)=8
group by sender_id 
order by count(message_id) desc
--ex6
select tweet_id from tweets
where length(content)>15
--ex7
select activity_date as day, 
count(distinct user_id)as active_users
from activity 
where activity_date between '2019-06-28' and '2019-07-27'
group by activity_date
--ex8
select count(id) from employees
where extract(month from joining_date) between 1 and 7
and extract(year from joining_date)=2022
--ex9
select position('a' in 'Amitah')
--ex10
select winery, 
substring(title,length(winery)+2,4)
from winemag_p2;
