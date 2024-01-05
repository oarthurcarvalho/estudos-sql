-- ======================================================================
--         Webinar Popularity [Snowflake SQL Interview Question]
-- ======================================================================

-- ** PREMIUM **

-- * Link: https://datalemur.com/questions/snowflake-webinar-popularity

-- As a Data Analyst on Snowflake's Marketing Analytics team, you're analyzing the CRM to determine what percent
-- of marketing touches were of type "webinar" in April 2022.
 
-- Round your percentage to the nearest integer.

-- FORM 1
WITH t1 AS (
	SELECT COUNT(contact_id) aprweb
	FROM marketing_touches 
	WHERE event_type = 'webinar'
		AND DATE_TRUNC('month', event_date) = '04/01/2022'
),
t2 AS (
	SELECT COUNT(contact_id) apr_ttl	
	FROM marketing_touches 
	WHERE DATE_TRUNC('month', event_date) = '04/01/2022'
)
SELECT 
	ROUND( CAST( t1.aprweb * 100 / t2.apr_ttl AS NUMERIC)) AS webinar_pct
FROM t1, t2


-- FORM 2
SELECT
	ROUND(100 * SUM(CASE WHEN event_type='webinar' THEN 1 ELSE 0 END) / COUNT(*) ) as webinar_pct
FROM marketing_touches
WHERE DATE_TRUNC('month', event_date) = '04/01/2022';