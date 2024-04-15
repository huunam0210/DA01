--cách 1: Sử dụng IQR/boxplot tìm ra outlier
-- b1: tính q1, q3, iqr
-- b2: xác định min=q1-1,5*iqr, max=q3 + 1,5*iqr
with cte as (
  select q1-1,5*iqr as min_value,
  q3+1,5*iqr as max_value
  from(select percentile_count(0.25) within group (order_by users) as q1,
  percentile_count(0.75) within group (order by users) as q2, 
  percentile_count(0.25) within group (order_by users) - percentile_count(0.25) within group (order_by users) as iqr))
--b3: xác định outlier <min or >max
select * from user_data
where users< (select min_value from cte) or users> (select max_value from cte)

--cách 2: sử dụng z-score= (users - avg)/stddev)
with cte as (select data_date, users, 
  (select avg(users) from user_data) as avg, 
  (select stddev(users) from user_data) as stddev from user_data)
select data_date, users, (users-avg)/stddev as z_score
from cte
where abs((users - avg)/stddev) > 2 or abs((users - avg)/stddev) > 3
