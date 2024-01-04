-- ======================================================================
--    Cards Issued Difference [JPMorgan Chase SQL Interview Question]
-- ======================================================================

-- ** Link: https://datalemur.com/questions/cards-issued-difference

-- Your team at JPMorgan Chase is preparing to launch a new credit card, and to gain some insights, you're
-- analyzing how many credit cards were issued each month.

-- Write a query that outputs the name of each credit card and the difference in the number of issued cards between
-- the month with the highest issuance cards and the lowest issuance. Arrange the results based on the largest
-- disparity.

SELECT
  card_name,
  MAX(issued_amount) - MIN(issued_amount) AS difference
FROM monthly_cards_issued
GROUP BY card_name
ORDER BY MAX(issued_amount) - MIN(issued_amount) DESC