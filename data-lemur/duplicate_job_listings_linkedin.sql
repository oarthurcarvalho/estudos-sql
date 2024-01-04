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