-- ======================================================================
--    Pharmacy Analytics (Part 3) [CVS Health SQL Interview Question]
-- ======================================================================

-- ** Link: https://datalemur.com/questions/total-drugs-sales

SELECT
  manufacturer,
  CONCAT( '$', ROUND( SUM(total_sales) / 1000000.0), ' million') AS sale
FROM pharmacy_sales
GROUP BY manufacturer
ORDER BY 
  ROUND( SUM(total_sales) / 1000000.0) DESC,
  manufacturer DESC
