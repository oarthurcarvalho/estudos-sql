-- ======================================================================
--   Histogram of Users and Purchases [Walmart SQL Interview Question]
-- ======================================================================

-- * Link: https://datalemur.com/questions/histogram-users-purchases

-- Assume you're given a table on Walmart user transactions. Based on their most recent transaction date, write a
-- query that retrieve the users along with the number of products they bought.

-- Output the user's most recent transaction date, user ID, and the number of products, sorted in chronological
-- order by the transaction date.

-- Starting from November 10th, 2022, the official solution was updated, and the expected output of transaction
-- date, number of users, and number of products was changed to the current expected output.

WITH t1 AS (
  SELECT *,
    RANK() OVER (PARTITION BY user_id ORDER BY transaction_date DESC) AS rnk
  FROM user_transactions
)
SELECT
  transaction_date,
  user_id,
  COUNT(DISTINCT product_id) AS number_of_products
FROM t1
WHERE rnk = 1
GROUP BY transaction_date, user_id
ORDER BY transaction_date