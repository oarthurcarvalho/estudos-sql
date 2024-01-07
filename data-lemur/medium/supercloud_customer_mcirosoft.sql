-- ======================================================================
--       Supercloud Customer [Microsoft SQL Interview Question]
-- ======================================================================

-- * Link: https://datalemur.com/questions/supercloud-customer

-- A Microsoft Azure Supercloud customer is defined as a company that purchases at least one product from each
-- product category.

-- Write a query that effectively identifies the company ID of such Supercloud customers.

WITH t1 AS (
  SELECT
    COUNT(DISTINCT product_category) AS num_categories
  FROM products
),
t2 AS (
  SELECT
    cc.customer_id
  FROM customer_contracts cc
    LEFT JOIN products p ON p.product_id = cc.product_id
  GROUP BY cc.customer_id
  HAVING 
    COUNT(DISTINCT p.product_category) = (
      SELECT t1.num_categories
      FROM t1
    )
)
SELECT *
FROM t2