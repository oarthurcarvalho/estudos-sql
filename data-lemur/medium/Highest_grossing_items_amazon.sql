-- ======================================================================
--       Highest-Grossing Items [Amazon SQL Interview Question]
-- ======================================================================

-- * Link: https://datalemur.com/questions/sql-highest-grossing

-- Assume you're given a table containing data on Amazon customers and their spending on products in different
-- category, write a query to identify the top two highest-grossing products within each category in the year 2022.
-- The output should include the category, product, and total spend.

WITH t1 AS (
  SELECT
    category,
    product,
    SUM(spend) AS total_spend
  FROM product_spend
  WHERE DATE_PART('year', transaction_date) = 2022
  GROUP BY product, category
),
t2 AS (
  SELECT
    *,
    RANK() OVER (PARTITION BY category ORDER BY t1.total_spend DESC) AS rank
  FROM t1
)
SELECT
  t2.category,
  t2.product,
  t2.total_spend
FROM t2
WHERE rank < 3