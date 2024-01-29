--ex1
select continent,
floor(avg(city.population))
from city 
inner join country 
on city.countrycode = country.code
group by continent
--ex2
