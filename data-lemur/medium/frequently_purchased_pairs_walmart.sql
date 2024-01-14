-- ======================================================================
--      Frequently Purchased Pairs [Walmart SQL Interview Question]
-- ======================================================================

-- ** PREMIUM **

-- * Link: https://datalemur.com/questions/frequently-purchased-pairs

-- Assume you are given the following tables on Walmart transactions and products. Find the number of unique
-- product combinations that are purchased in the same transaction.

-- For example, if there are 2 transactions where apples and bananas are bought, and another transaction where
-- bananas and soy milk are bought, my output would be 2 to represent the 2 unique combinations.

-- Assumptions:

-- - For each transaction, a maximum of 2 products is purchased.
-- - You may or may not need to use the products table.

WITH product_transactions AS (
  SELECT
    t.transaction_id,
    t.product_id,
    p.product_name
  FROM transactions AS t
    INNER JOIN products AS p ON t.product_id = p.product_id
)
SELECT
  p1.product_name AS product1,
  p2.product_name AS product2,
  COUNT(*) AS combo_num
FROM product_transactions AS p1
  INNER JOIN product_transactions AS p2 ON p1.transaction_id = p2.transaction_id AND p1.product_id > p2.product_id
GROUP BY p1.product_name, p2.product_name
ORDER BY combo_num DESC
LIMIT 3;