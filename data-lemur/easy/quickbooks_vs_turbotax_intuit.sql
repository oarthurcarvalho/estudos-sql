-- ======================================================================
--         QuickBooks vs TurboTax [Intuit SQL Interview Question]
-- ======================================================================

-- ** PREMIUM **

-- ** Link: https://datalemur.com/questions/quickbooks-vs-turbotax

-- Intuit provides a range of tax filling products, including YurboTax and QuickBooks, available in various versions.

-- Write a query to determine the total number of tax fillings made using TurboTax and QuickBooks. Each user can file
-- taxes once a year using only one product.

SELECT 
	SUM(
		CASE 
			WHEN product LIKE 'TurboTax%' THEN 1 
			ELSE 0 
		END
	) AS turbotax_total,
	SUM(
		CASE
			WHEN product LIKE 'QuickBooks%' THEN 1
			ELSE 0
		END
	) AS quickbooks_total
FROM filed_taxes;