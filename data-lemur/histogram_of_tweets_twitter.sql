-- ======================================================================
--        Histogram of Tweets [Twitter SQL Interview Question]
-- ======================================================================

-- ** Link: https://dataleur.com/questions/sql-histogram-tweets

-- Assume you're given a table Twitter tweet data, write a query to obtain a histogram of tweets posted per
-- user in 2022. Output the tweet count per user as the bucket and the number of Twitter users who fall into
-- that bucket.

-- In other words, group the users by the number of tweets they posted in 2022 and count the number of users in
-- each group.

SELECT
  tweet_bucket,
  COUNT(user_id) as users_num
FROM (
  SELECT
    user_id,
    COUNT(tweet_id) as tweet_bucket
  FROM tweets
  WHERE DATE_PART('year', tweet_date) = 2022
  GROUP BY user_id
) as subquery
GROUP BY tweet_bucket