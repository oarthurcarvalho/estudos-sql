-- ======================================================================
--    Median Google Search Frequency [Google SQL Interview Question]
-- ======================================================================

-- * Link: https://datalemur.com/questions/median-search-freq

-- Google's marketing team is making a Superbowl commercial and needs a simple statistic to put on
-- their TV ad: the median number of searches a person made last year.

-- However, at Google scale, querying the 2 trillion searches is too costly. Luckily, you have
-- access to the summary table which tells you the number of searches made last year and how many
-- Google users fall into that bucket.

-- Write a query to report the median of searches made by a user. Round the median to one decimal
-- point.

WITH RECURSIVE CTE_REC_Median AS(
  SELECT 
    searches,
    num_users,
    1 AS temp
  FROM search_frequency
  UNION ALL
  SELECT
    searches,
    num_users,
    temp + 1
  FROM CTE_REC_Median
  WHERE temp + 1 <= num_users
)
SELECT
  PERCENTILE_CONT(.5) WITHIN GROUP (ORDER BY searches) as median
FROM CTE_REC_Median
