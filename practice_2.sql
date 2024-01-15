--ex1
select city from station
where id%2=0
group by city
--ex2
select count(city)- count(distinct city) from station
--ex4
select 
round(CAST(sum(item_count*order_occurrences)/sum(order_occurrences) as decimal),1) as mean 
from items_per_order
--ex5
select candidate_id from candidates
where skill in ('Python','Tableau','PostgreSQL')
group by candidate_id
having count(skill)=3
--ex6
SELECT user_id,
date(max(post_date))-date(min(post_date)) as days_between
FROM posts
where post_date<'1/1/2022' and post_date>='1/1/2021'
group by user_id
having count(user_id)>=2
--ex7
select card_name, max(issued_amount)-min(issued_amount) as difference
from monthly_cards_issued
group by card_name
order by max(issued_amount)-min(issued_amount) DESC
--ex8
SELECT manufacturer,
count(drug) as drug_count,
abs(sum(total_sales-cogs)) as total_loss
FROM pharmacy_sales
where total_sales<cogs
group by manufacturer
order by total_loss desc
--ex9
select id, movie, description, rating from cinema
where id%2=1 and not description ='boring'
order by rating desc
--ex10
select teacher_id,
count(distinct subject_id) as cnt
from teacher 
group by teacher_id
--ex11
select user_id, count(follower_id) as followers_count
from followers
group by user_id
order by user_id 
--ex12
select class from courses
group by class
having count(student)>=5
