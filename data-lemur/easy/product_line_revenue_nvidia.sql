 -- ======================================================================
--         Product Line Revenue [NVIDIA SQL Interview Question]
-- ======================================================================
 
-- ** PREMIUM **

-- * Link: https://datalemur.com/questions/revenue-by-product-line

-- As a business analyst on the revenue forecasting team at NVIDIA, you are given a table of NVIDIA transactions
-- in 2021.

-- Write a query to summarize the total sales revenue for each product line. The product line with the highest
-- revenue should be at the top of the results.

-- Assumption:

    -- There will be at least one sale of each product line.
	-- This is a premium excercise
	-- with CTE
 
 
 -- FORM 1
 WITH t1 AS (
  SELECT
  	product_id,
  	SUM(amount) rev
  FROM transactions
  GROUP BY product_id
),
t2 AS (
	SELECT
		pi.product_id,
		pi.product_line,
		t1.rev    
	FROM product_info AS pi
    JOIN t1
    	ON t1.product_id = pi.product_id
)
SELECT
	product_line,
	SUM(rev) revenue
FROM t2
GROUP BY product_line
ORDER BY SUM(rev) DESC;

-- FORM 2
SELECT
	DISTINCT
		product.product_line,
		SUM(amount) OVER (PARTITION BY product.product_line) AS total_revenue
FROM transactions
INNER JOIN product_info AS product
  ON transactions.product_id = product.product_id
ORDER BY total_revenue DESC;