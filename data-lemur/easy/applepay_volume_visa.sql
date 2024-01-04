-- ======================================================================
--         ApplePay Volume [Visa SQL Interview Question]
-- ======================================================================

-- ** PREMIUM **

-- ** Link: https://datalemur.com/questions/apple-pay-volume

-- Visa is analysing its partnership with ApplyPay. Calculate the total transaction volume for each merchant where
-- the transaction was performed via ApplePay.

-- Output the merchant ID and the total transactions. For merchants with no ApplePay transactions, output their
-- total transaction volume as 0. Display the result in descending order of the transaction volume.

-- FORM 1
SELECT merchant_id, sum(transaction_amount) ttl_trans
FROM transactions
WHERE LOWER(payment_method) like '%apple%'
GROUP BY merchant_id
ORDER BY ttl_trans DESC;

-- FORM 2
SELECT merchant_id,
  SUM(
    CASE
    WHEN LOWER(payment_method) LIKE '%apple%'
          THEN transaction_amount
        ELSE 0
        END) as ttl_trans
FROM transactions
GROUP BY merchant_id
ORDER BY ttl_trans DESC;