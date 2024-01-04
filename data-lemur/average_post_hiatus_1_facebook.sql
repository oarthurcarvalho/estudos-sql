-- ======================================================================
--     Average Post Hiatus (Part 1) [Facebook SQL Interview Question]
-- ======================================================================

-- ** Link: https://datalemur.com/questions/sql-average-post-hiatus-1

-- Given a table of Facebook posts, for each user who posted at least twice in 2021, write a query to find the
-- number of days between each user’s first post of the year and last post of the year in the year 2021. Output
-- the user and number of the days between each user's first and last post.

-- FORM 1
SELECT
  user_id,
  MAX(post_date)::date - MIN(post_date)::date AS days_between
FROM posts
WHERE DATE_PART('year', post_date) = 2021
GROUP BY user_id
HAVING MAX(post_date)::date - MIN(post_date)::date <> 0;

-- FORM 2
SELECT
  t1.user_id,
  (t1.last_post::date) - (t1.first_post::date) AS days_between
FROM (
  SELECT
    DISTINCT user_id,
    MIN(post_date) OVER (PARTITION BY user_id) AS first_post,
    MAX(post_date) OVER (PARTITION BY user_id) AS last_post
  FROM posts
  WHERE DATE_PART('year', post_date) = 2021
) as t1
WHERE (t1.last_post::date) - (t1.first_post::date) <> 0