-- ======================================================================
--            Compressed Mode [Alibaba SQL Interview Question]
-- ======================================================================

-- * Link: https://datalemur.com/questions/alibaba-compressed-mode

-- You're given a table containing the item count for each order on Alibaba, along with the frequency of orders
-- that have the same item count. Write a query to retrieve the mode of the order occurrences. Additionally, if
-- there are multiple item counts with the same mode, the results should be sorted in ascending order.

-- Clarifications:

-- - item_count: Represents the number of items sold in each order.
-- - order_occurrences: Represents the frequency of orders with the corresponding number of items sold per order.
-- - For example, if there are 800 orders with 3 items sold in each order, the record would have an item_count of
--   3 and an order_occurrences of 800.

WITH t1 AS (
  SELECT
    *,
    RANK() OVER (ORDER BY order_occurrences DESC) AS rnk
  FROM items_per_order
)
SELECT
  item_count AS mode
FROM t1
WHERE rnk = 1
ORDER BY t1.item_count ASC