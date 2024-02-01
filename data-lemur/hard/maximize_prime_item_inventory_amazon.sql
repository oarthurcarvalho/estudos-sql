-- ======================================================================
--     Maximize Prime Item Inventory [Amazon SQL Interview Question]
-- ======================================================================

-- * Link: https://datalemur.com/questions/prime-warehouse-storage

-- Amazon wants to maximize the number of items it can stock in a 500,000 square feet warehouse.
-- It wants to stock as many prime items as possible, and afterwards use the remaining square footage
-- to stock the most number of non-prime items.

-- Write a query to find the number of prime and non-prime items that can be stored in the 500,000
-- square feet warehouse. Output the item type with prime_eligible followed by not_prime and the
-- maximum number of items that can be stocked.

-- Effective April 3rd 2023, we added some new assumptions to the question to provide additional clarity.

-- Assumptions:

-- - Prime and non-prime items have to be stored in equal amounts, regardless of their size or square footage.
--   This implies that prime items will be stored separately from non-prime items in their respective
--   containers, but within each container, all items must be in the same amount.
-- - Non-prime items must always be available in stock to meet customer demand, so the non-prime item count
--   should never be zero.
-- - Item count should be whole numbers (integers).

WITH t1 AS (
  SELECT
    item_type,
    COUNT(item_id) AS item_qty,
    SUM(square_footage) AS type_square
  FROM inventory
  GROUP BY item_type
  ORDER BY item_type DESC
),
t2 AS (
  SELECT
    *,
    LAG(t1.type_square, 1) OVER (ORDER BY t1.type_square DESC) AS lag_value
  FROM t1
),
t3 AS (
  SELECT
    t2.item_type,
    t2.item_qty,
    CASE
      WHEN t2.item_type = 'prime_eligible' THEN TRUNC(500000 / t2.type_square)
      ELSE TRUNC(
        (500000 - (TRUNC(500000 / t2.lag_value) * t2.lag_value)) / t2.type_square)
    END AS qty_per_item
  FROM t2
)
SELECT
  t3.item_type,
  t3.item_qty * t3.qty_per_item
FROM t3