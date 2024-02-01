-- ======================================================================
--           Y-on-Y Growth Rate [Wayfair SQL Interview Question]
-- ======================================================================

-- * Link: https://datalemur.com/questions/yoy-growth-rate

-- Assume you're given a table containing information about Wayfair user transactions for different products.
-- Write a query to calculate the year-on-year growth rate for the total spend of each product, grouping the
-- results by product ID.

-- The output should include the year in ascending order, product ID, current year's spend, previous year's
-- spend and year-on-year growth percentage, rounded to 2 decimal places.

WITH t1 AS (
  SELECT
    DATE_PART('year', transaction_date) AS year,
    product_id,
    SUM(spend) as curr_year_spend
  FROM user_transactions
  GROUP BY DATE_PART('year', transaction_date), product_id
),
t2 AS (
  SELECT
    *,
    LAG(t1.curr_year_spend, 1) OVER (PARTITION BY product_id ORDER BY t1.year) AS prev_year_spend
  FROM t1
  ORDER BY t1.year ASC
)
SELECT
  *,
  ROUND( (t2.curr_year_spend / t2.prev_year_spend - 1) * 100, 2)
FROM t2
ORDER BY product_id, year, curr_year_spend, prev_year_spend