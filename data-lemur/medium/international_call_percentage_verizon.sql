-- ======================================================================
--     International Call Percentage [Verizon SQL Interview Question]
-- ======================================================================

-- * Link: https://datalemur.com/questions/international-call-percentage

-- A phone call is considered an international call when the person calling is in a different country than the
-- person receiving the call.

-- What percentage of phone calls are international? Round the result to 1 decimal.

-- Assumption:

-- - The caller_id in phone_info table refers to both the caller and receiver.

WITH t1 AS(
  SELECT
    pi1.caller_id,
    pi1.country_id AS country_caller,
    pi2.caller_id AS receiver_id,
    pi2.country_id AS country_receiver,
    CASE
      WHEN pi1.country_id <> pi2.country_id THEN 1
      ELSE 0
    END AS international_call
  FROM phone_calls pc
    LEFT JOIN phone_info pi1 ON pc.caller_id = pi1.caller_id
    LEFT JOIN phone_info pi2 ON pc.receiver_id = pi2.caller_id
),
t2 AS (
  SELECT
    COUNT(*) FILTER (WHERE international_call = 1) AS  num_international_call,
    COUNT(*) FILTER (WHERE international_call = 0) AS num_dosmetic_call
  FROM t1
)
SELECT
  ROUND(
    t2.num_international_call /
    CAST(t2.num_international_call + t2.num_dosmetic_call AS NUMERIC) * 100.0,
  1) AS international_calls_pct
FROM t2