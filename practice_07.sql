--ex1
SELECT extract(year from transaction_date), product_id,
spend as curr_year_spend,
lag(spend)over (partition by product_id order by transaction_date) as prev_year_spend,
round(spend/lag(spend)over (partition by product_id order by transaction_date)*100-100,2) as yoy_rate
FROM user_transactions
--ex2
SELECT card_name,
first_value(issued_amount) over (PARTITION BY card_name order by issue_month, issue_year)
FROM monthly_cards_issued;
--ex3
select user_id, spend, transaction_date 
from (SELECT 
  user_id, 
  spend, 
  transaction_date, 
  RANK() OVER (
    PARTITION BY user_id 
    ORDER BY transaction_date) AS rank_num 
FROM transactions) as trans_num
where rank_num=3
--ex4
WITH latest_transactions_cte AS (
  SELECT 
    transaction_date, 
    user_id, 
    product_id, 
    RANK() OVER (
      PARTITION BY user_id 
      ORDER BY transaction_date DESC) AS ranking 
  FROM user_transactions)
  
  select transaction_date, user_id, count(product_id) as purchase_count
  from latest_transactions_cte
  where ranking=1
  group by transaction_date, user_id
  order by transaction_date
--ex7
with ranked_spend_cte as (SELECT 
  category, 
  product, 
  SUM(spend) AS total_spend,
  Rank() OVER (
    PARTITION BY category
    ORDER BY sum(spend) DESC) AS ranking
FROM product_spend 
WHERE EXTRACT(YEAR FROM transaction_date) = 2022
GROUP BY category, product)

select category, product, total_spend 
from ranked_spend_cte
where ranking <=2
--ex8
 with cte as (SELECT 
    artists.artist_name,
    DENSE_RANK() OVER (
      ORDER BY COUNT(songs.song_id) DESC) AS artist_rank
  FROM artists
  INNER JOIN songs
    ON artists.artist_id = songs.artist_id
  INNER JOIN global_song_rank AS ranking
    ON songs.song_id = ranking.song_id
  WHERE ranking.rank <= 10
group by artists.artist_name)
select artist_name from cte
where artist_rank <=5
