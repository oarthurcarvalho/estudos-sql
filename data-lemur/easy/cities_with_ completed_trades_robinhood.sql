-- ======================================================================
--    Cities With Completed Trades [Robinhood SQL Interview Question]
-- ======================================================================

-- ** Link: https://datalemur.com/questions/completed-trades

-- Assume you're given the tables containing completed trade orders and user details in a Robinhood trading system.

-- Write a query to retrieve the top three cities that have the highest number of completed trade orders listed
-- in descending order. Output the city name and the corresponding number of completed trade orders.

SELECT
  u.city,
  COUNT(*) as total_orders
FROM trades t
  LEFT JOIN users u ON t.user_id = u.user_id
WHERE status = 'Completed'
GROUP BY u.city
ORDER BY COUNT(*) DESC
LIMIT 3