--ex1
select name from city
where population >120000 and countrycode="USA"
--ex2
select * from city
where countrycode="JPN"
--ex3
select city, state from station
--ex4
select distinct city from station
where city like 'a%' or city like 'e%' or city like 'i%' or city like 'o%' or city like 'u%' or city like 'i%e%'
--ex5
select distinct city from station
where city like '%a' or city like '%e' or city like '%i' or city like '%o' or city like '%u'
