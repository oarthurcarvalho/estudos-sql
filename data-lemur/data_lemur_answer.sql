-- ======================================================================
--        Data Science Skills [LinkedIn SQL Interview Question]
-- ======================================================================

-- ** Link: https://datalemur.com/questions/matching-skills

-- Given a table of candidates and their skills, you're tasked with finding the candidates best suited
-- for an open Data Science job. You want to find candidates who are proficient in Python, Tableau, and PostgreSQL.

-- Write a query to list the candidates who possess all of the required skills for the job. Sort the output by
-- candidate ID in ascending order.

SELECT candidate_id
FROM candidates
WHERE skill in ('Python', 'Tableau', 'PostgreSQL')
GROUP BY candidate_id
HAVING COUNT(candidate_id) = 3;


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


-- ======================================================================
--        Page With No Likes [Facebook SQL Interview Question]
-- ======================================================================

-- ** Link: https://datalemur.com/questions/sql-page-with-no-likes

-- Assume you're given two tables containing data about Facebook Pages and their respective likes (as in 
-- "Like a Facebook Page").

-- Write a query to return the IDs of the Facebook pages that have zero likes. The output should be sorted in
-- ascending order based on the page IDs.

SELECT
  p.page_id
FROM pages p
  LEFT JOIN page_likes pl ON p.page_id = pl.page_id
WHERE liked_date IS NULL
ORDER BY p.page_id


-- ======================================================================
--        Unfinished Parts [Tesla SQL Interview Question]
-- ======================================================================               

-- ** Link: https://datalemur.com/questions/tesla-unfinished-parts

-- Tesla is investigating production bottlenecks and they need your help to extract the relevant data.
-- Write a query to determine which parts have begun the assembly process but are not yet finished.

-- Assumptions:

-- - parts_assembly table contains all parts currently in production, each at varying stages of the assembly
--	 process.
-- - An unfinished part is one that lacks a finish_date.

-- This question is straightforward, so let's approach it with simplicity in both thinking and solution.

SELECT
  part,
  assembly_step
FROM parts_assembly
WHERE finish_date IS NULL;


-- ======================================================================
--  Laptop vs. Mobile Viewership [New York Times SQL Interview Question]
-- ======================================================================

-- ** Link: https://datalemur.com/questions/laptop-mobile-viewership

-- Assume you're given the table on user viewership categorised by device type where the three types are laptop,
-- tablet, and phone.

-- Write a query that calculates the total viewership for laptops and mobile devices where mobile is defined as
-- the sum of tablet and phone viewership. Output the total viewership for laptops as laptop_reviews and the 
-- total viewership for mobile devices as mobile_views.

SELECT
  COUNT(*) FILTER (WHERE device_type = 'laptop') AS laptop_views,
  COUNT(*) FILTER (WHERE device_type IN ('tablet', 'phone')) AS mobile_views
FROM viewership


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


-- ======================================================================
--          Teams Power Users [Microsoft SQL Interview Question]
-- ======================================================================

-- ** Link: https://datalemur.com/questions/teams-power-users

-- Write a query to identify the top 2 Power Users who sent the highest number of messages on Microsoft Teams
-- in August 2022. Display the IDs of these 2 users along with the total number of messages they sent. Output the
-- results in descending order based on the count of the messages.

-- Assumption:
-- - No two users have sent the same number of messages in August 2022.

SELECT
  sender_id,
  COUNT(message_id) AS message_count
FROM messages
WHERE 
  DATE_PART('month', sent_date) = 08 AND
  DATE_PART('year', sent_date) = 2022
GROUP BY sender_id
ORDER BY COUNT(message_id) DESC
LIMIT 2


-- ======================================================================
--        Duplicate Job Listings [Linkedin SQL Interview Question]
-- ======================================================================

-- ** Link: https://datalemur.com/questions/duplicate-job-listings

-- Assume you're given a table containing job postings from various companies on the LinkedIn platform.
-- Write a query to retrieve the count of companies that have posted duplicate job listings.

-- Definition:

-- Duplicate job listings are defined as two job listings within the same company that share identical titles
-- and descriptions.

-- FORM 1
SELECT COUNT(*) as duplicate_companies
FROM (
  SELECT company_id
  FROM job_listings
  GROUP BY company_id, title
  HAVING COUNT(*) > 1
) as t1
GROUP BY company_id
HAVING COUNT(*) = 1;

-- FORM 2
SELECT
  COUNT(*) as duplicate_companies
FROM (
  SELECT
    COUNT(title) - COUNT(DISTINCT title) as duplicate_jobs
  FROM job_listings
  GROUP BY company_id
  HAVING COUNT(title) - COUNT(DISTINCT title) = 1
) as t1


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


-- ======================================================================
--    Cities With Completed Trades [Robinhood SQL Interview Question]
-- ======================================================================

-- ** Link: https://datalemur.com/questions/sql-avg-review-ratings

-- Given the reviews table, write a query to retrieve the average star rating for each product, grouped by month.
-- The output should display the month as a numerical value, product ID, and average star rating rounded to two
-- decimal places. Sort the output first by month and then by product ID.

SELECT 
  DATE_PART('month', submit_date) AS mth,
  product_id,
  ROUND( CAST(AVG(stars) AS NUMERIC),2) AS avg_stars
FROM reviews
GROUP BY DATE_PART('month', submit_date), product_id
ORDER BY DATE_PART('month', submit_date), product_id
