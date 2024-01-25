--ex1
SELECT 
SUm(CASE
WHEN device_type='laptop' then 1
ELSE 0
END) as laptop_views,
sum(CASE
WHEN device_type in ('tablet','phone') then 1
ELSE 0
END) as mobile_views
FROM viewership
GROUP BY laptop_views, mobile_views
--ex2
select 
x,y,z,
Case
When x+y<z then 'No'
When y+z<x then 'No'
When x+z<y then 'No'
Else 'Yes'
end as triangle
from Triangle
--ex4
select name from customer
where not referee_id =2 or referee_id is null
--ex5
select 
survived,
sum(case 
 when pclass=1 then 1
 end) as first_class,
 sum(case 
 when pclass=2 then 1
 end) as second_class,
 sum(case 
 when pclass=3 then 1
 end) as third_class
 from titanic
 group by survived
