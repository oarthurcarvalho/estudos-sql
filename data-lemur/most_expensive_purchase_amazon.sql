-- ======================================================================
--         Most Expensive Purchase [Amazon SQL Interview Question]
-- ======================================================================

-- ** PREMIUM **

-- ** Link: https://datalemur.com/questions/most-expensive-purchase

-- Amazon is trying to identify their high-end customers. To do so, they first need your help to write a query
-- that obtains the most expensive purchase made by each customer. Order the results by the most expensive
-- purchase first.

SELECT
  customer_id, MAX(purchase_amount)
FROM
  transactions
GROUP BY customer_id
ORDER BY 2 DESC;