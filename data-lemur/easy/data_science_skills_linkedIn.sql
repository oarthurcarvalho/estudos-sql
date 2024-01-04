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