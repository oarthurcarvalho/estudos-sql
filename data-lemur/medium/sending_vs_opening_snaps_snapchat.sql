-- ======================================================================
--      Sending vs. Opening Snaps [Snapchat SQL Interview Question]
-- ======================================================================

-- * Link: https://datalemur.com/questions/time-spent-snaps

-- Assume you're given tables with information on Snapchat users, including their ages and time spent sending and
-- opening snaps.

-- Write a query to obtain a breakdown of the time spent sending vs. opening snaps as a percentage of total time
-- spent on these activities grouped by age group. Round the percentage to 2 decimal places in the output.

-- Notes:

-- 	- Calculate the following percentages:
--		* time spent sending / (Time spent sending + Time spent opening)
--		* time spent opening / (Time spent sending + Time spent opening)
--	- To avoid integer division in percentages, multiply by 100.0 and not 100.

SELECT
  t1.age_bucket,
  ROUND(t1.send_time / (t1.send_time + t1.open_time) * 100.0, 2) AS send_perc,
  ROUND(t1.open_time / (t1.send_time + t1.open_time) * 100.0, 2) AS open_perc
FROM (
  SELECT
    ab.age_bucket,
    SUM(time_spent) FILTER (WHERE activity_type = 'open') AS open_time,
    SUM(time_spent) FILTER (WHERE activity_type = 'send') AS send_time
  FROM activities a
    LEFT JOIN age_breakdown ab ON a.user_id = ab.user_id
  GROUP BY ab.age_bucket
) as t1