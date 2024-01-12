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
--ex6
select distinct city from station
where city not like 'a%' and city not like 'e%' and city not like 'i%' and city not like 'o%' and city not like 'u%' and city not like 'i%e%'
--ex7
select name from employee
order by name
--ex8
select name from employee
where salary >2000 and months <10
order by employee_id
--ex9
select product_id from products
where low_fats='Y' and recyclable='Y'
--ex10
select name from customer 
where not  referee_id='2' or referee_id is null
--ex11
select name,population,area from world 
where area>=3000000 or population>=25000000
--ex12
select distinct author_id as id from views
where author_id=viewer_id
order by author_id
--ex13
SELECT * FROM parts_assembly
WHERE finish_date IS NULL
--ex14
select advertising_channel from uber_advertising
where money_spent>100000
--ex15
select * from lyft_drivers
where yearly_salary<=30000 or yearly_salary>=70000
