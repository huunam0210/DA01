--ex1
with job_count_cte as
(SELECT company_id, title, description, count(job_id) as job_count
FROM job_listings
group by company_id, title, description)
select count(job_count_cte.company_id) as count_duplicate_companies
from job_count_cte
where job_count>=2
