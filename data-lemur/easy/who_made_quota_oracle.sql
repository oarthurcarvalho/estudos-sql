-- ======================================================================
--         Who Made Quota? [Oracle SQL Interview Question]
-- ======================================================================

-- ** PREMIUM **

-- * Link: https://datalemur.com/questions/oracle-sales-quota

-- As a data analyst on the Oracle Sales Operations team, you are given a list of salespeople’s deals, and the
-- annual quota they need to hit.

-- Write a query that outputs each employee id and whether they hit the quota or not ('yes' or 'no'). 
-- Order the results by employee id in ascending order.

-- Definitions:
    -- - deal_size: Deals acquired by a salesperson in the year. Each salesperson may have more than 1 deal.
    -- - quota: Total annual quota for each salesperson.

WITH t1 AS (
	SELECT
		d.employee_id,
		SUM(d.deal_size) AS sold
	FROM deals as d
	GROUP BY d.employee_id
)
SELECT
	t1.employee_id,
	CASE
		WHEN
			t1.sold - q.quota < 0 THEN 'no'
		ELSE 'yes'
	END made_quota
FROM t1
JOIN sales_quotas AS q
	ON q.employee_id = t1.employee_id
ORDER BY t1.employee_id ASC;



