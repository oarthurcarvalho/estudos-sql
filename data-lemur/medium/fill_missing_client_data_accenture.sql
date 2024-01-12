-- ======================================================================
--     Fill Missing Client Data [Accenture SQL Interview Question]
-- ======================================================================

-- ** PREMIUM **

-- * Link: https://datalemur.com/questions/fill-missing-product

-- When you log in to your retalier client's database, you notice that their product catalog data is full of gaps
-- in the category column.

-- Can you write a SQL query that returns the product catalog withj the missing data filled in?

-- Assumptions

-- * Each category is mentioned only once in a category column.
-- * Akk the products belonging to same category are grouped together.
-- * The first product from a product group will always have a defined category.
--    - Meaning that the first item from eachc category will not have a missing category value.

WITH t1 AS (
  SELECT
    product_id,
    category,
    name,
    COUNT(category) OVER (ORDER BY product_id) AS category_group
  FROM products
)
SELECT
  product_id,
  CASE
    WHEN category IS NULL THEN FIRST_VALUE(category) OVER (PARTITION BY category_group)
      ELSE category
    END AS category,
    name
FROM t1