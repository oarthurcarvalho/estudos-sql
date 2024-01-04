-- ======================================================================
--    App Click-through Rate (CTR) [Facebook SQL Interview Question]
-- ======================================================================

-- ** Link: https://datalemur.com/questions/click-through-rate

-- Assume you have an events table on Facebook app analytics. Write a query to calculate the click-through rate
-- (CTR) for the app in 2022 and round the results to 2 decimal places.

-- Definition and note:

-- Percentage of click-through rate (CTR) = 100.0 * Number of clicks / Number of impressions
-- To avoid integer division, multiply the CTR by 100.0, not 100.

SELECT 
  t1.app_id,
  ROUND( t1.number_of_clicks / t1.number_of_impressions * 100.0, 2 ) as teste
FROM (
  SELECT
    app_id,
    CAST( COUNT(*)  FILTER (WHERE event_type = 'click') AS NUMERIC ) AS number_of_clicks,
    CAST( COUNT(*) FILTER (WHERE event_type = 'impression') AS NUMERIC ) AS number_of_impressions
  FROM events
  WHERE DATE_PART('year', timestamp) = 2022
  GROUP BY app_id
) as t1