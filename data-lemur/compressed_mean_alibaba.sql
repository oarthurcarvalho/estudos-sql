-- ======================================================================
--           Compressed Mean [Alibaba SQL Interview Question]
-- ======================================================================

-- ** Link: https://datalemur.com/questions/alibaba-compressed-mean

-- You're trying to find the mean number of items per order on Alibaba, rounded to 1 decimal place using
-- tables which includes information on the count of items in each order (item_count table) and the corresponding
-- number of orders for each item count (order_occurrences table).

SELECT
  ROUND(
    CAST(
      SUM(item_count * order_occurrences) / SUM(order_occurrences) AS NUMERIC
    ), 1)
FROM items_per_order;