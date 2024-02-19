-- ======================================================================
--        3-Topping Pizzas [McKinsey SQL Interview Question]
-- ======================================================================

-- * Link: https://datalemur.com/questions/repeated-payments

-- Sometimes, payment transactions are repeated by accident; it could be due to user error, API failure or
-- a retry error that causes a credit card to be charged twice.

-- Using the transactions table, identify any payments made at the same merchant with the same credit card
-- for the same amount within 10 minutes of each other. Count such repeated payments.

-- Assumptions:

-- The first transaction of such payments should not be counted as a repeated payment. This means, if there
-- are two transactions performed by a merchant with the same credit card and for the same amount within
-- 10 minutes, there will only be 1 repeated payment.

WITH t1 AS (
  SELECT
    *,
    LAG(transaction_timestamp, 1) OVER (PARTITION BY merchant_id, credit_card_id ORDER BY transaction_timestamp) AS last_transaction,
    LAG(merchant_id, 1) OVER (PARTITION BY merchant_id, credit_card_id ORDER BY transaction_timestamp) AS last_merchant_id,
    LAG(credit_card_id, 1) OVER (PARTITION BY merchant_id, credit_card_id ORDER BY transaction_timestamp) AS last_credit_card_id,
    LAG(amount, 1) OVER (PARTITION BY merchant_id, credit_card_id ORDER BY transaction_timestamp) AS last_amount
  FROM transactions
),
t2 AS (
  SELECT
    *,
    DATE_PART('minute', age(transaction_timestamp, last_transaction)) AS time_last_transaction
  FROM t1
),
t3 AS (
  SELECT
    CASE
      WHEN time_last_transaction < 10 AND last_merchant_id = merchant_id AND last_credit_card_id = credit_card_id AND last_amount = amount
        THEN 1
      ELSE 0
    END AS repeated_payment
  FROM t2
)
 SELECT
  SUM(repeated_payment) as payment_count
FROM t3
