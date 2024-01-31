-- ======================================================================
--      Active User Retention [Facebook SQL Interview Question]
-- ======================================================================

-- * Link: https://datalemur.com/questions/user-retention

-- Assume you're given a table containing information on Facebook user actions. Write a query to obtain number of monthly active users (MAUs)
-- in July 2022, including the month in numerical format "1, 2, 3".

-- Hint:

-- An active user is defined as a user who has performed actions such as 'sign-in', 'like', or 'comment' in both the current month and the previous month.

WITH t1 AS (
  SELECT DISTINCT
    user_id,
    DATE_PART('month', event_date) AS month_date,
    DATE_PART('month', LAG(event_date, 1) OVER (PARTITION BY user_id ORDER BY event_date)) AS last_activity
  FROM user_actions
  ORDER BY user_id, month_date ASC
),
t2 AS (
  SELECT
    user_id,
    month_date,
    CASE
      WHEN last_activity IS NULL THEN 0
      WHEN (month_date - last_activity) = 1 THEN 1
      WHEN (month_date - last_activity) > 1 THEN 0
      ELSE 0
    END AS MAU
  FROM t1
)
SELECT
  t2.month_date AS month,
  SUM(t2.mau)
FROM t2
GROUP BY month_date
HAVING t2.month_date = 7
