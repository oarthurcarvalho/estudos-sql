-- ======================================================================
--       User's Third Transaction [Uber SQL Interview Question]
-- ======================================================================

-- * Link: https://datalemur.com/questions/sql-third-transaction

-- Assume you are given the table below on Uber transactions made by users. Write a query to obtain the third
-- transaction of every user. Output the user id, spend and transaction date.

SELECT
	t1.user_id,
	t1.spend,
	t1.transaction_date
FROM (
	SELECT
		*,
		RANK() OVER (PARTITION BY user_id ORDER BY transaction_date ASC) AS rank_transaction
	FROM transactions
) AS t1
WHERE t1.rank_transaction = 3