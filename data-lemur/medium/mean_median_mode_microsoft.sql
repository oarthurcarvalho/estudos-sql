-- ======================================================================
--           Mean, Median, Mode [Microsoft SQL Interview Question]
-- ======================================================================

-- ** PREMIUM **

-- * Link: https://datalemur.com/questions/mean-median-mode

-- You're given a list of numbers representing the number of emails in the inbox of Microsoft Outlook users.
-- Before the Product Management team can start developing features related to bulk-deleting email or achieving
-- inbox zero, they simply want to find the mean, median, and mode for the emails. Display the output of mean,
-- median, and mode (in this order), with the mean rounded to the nearest integer. It should be assumed that there
-- are no ties to the mode.

SELECT
	ROUND(SUM(email_count) / COUNT(user_id) AS mean,
	PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY email_count) AS median,
	MODE() WITHIN GROUP (ORDER BY email_count) AS MODE
FROM inbox_stats
