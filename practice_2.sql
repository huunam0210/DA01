--ex1
select city from station
where id%2=0
group by city
--ex2
select count(city)- count(distinct city) from station
