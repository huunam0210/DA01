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
