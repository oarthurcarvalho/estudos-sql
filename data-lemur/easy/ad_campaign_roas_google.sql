-- ======================================================================
--         Ad Campaign ROAS [Google SQL Interview Question]
-- ======================================================================

-- ** PREMIUM **

-- * Link: https://datalemur.com/questions/ad-campaign-roas]

-- Google marketing managers are analyzing the performance of various advertising accounts over the last month. 
-- They need your help to gather the relevant data.

-- Write a query to calculate the return on ad spend (ROAS) for each advertiser across all ad campaigns. Round your
-- answer to 2 decimal places, and order your output by the advertiser_id.

SELECT advertiser_id
  ,ROUND(
  ((sum(revenue)) / SUM(spend))::DECIMAL, 2) ROAS
FROM ad_campaigns
GROUP BY advertiser_id
ORDER BY advertiser_id ASC;