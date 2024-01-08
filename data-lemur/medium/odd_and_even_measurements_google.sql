-- ======================================================================
--       Odd and Even Measurements [Google SQL Interview Question]
-- ======================================================================

-- * Link: https://datalemur.com/questions/odd-even-measurements

-- Assume you're given a table with measurement values obtained from a Google sensor over multiple days with
-- measurements taken multiple times within each day.

-- Write a query to calculate the sum of odd-numbered and even-numbered measurements separately for a particular
-- day and display the results in two different columns. Refer to the Example Output below for the desired format.

-- Definition:

-- Within a day, measurements taken at 1st, 3rd, and 5th times are considered odd-numbered measurements, and
-- measurements taken at 2nd, 4th, and 6th times are considered even-numbered measurements.

WITH t1 AS (
  SELECT
    *,
    ROW_NUMBER() OVER (PARTITION BY DATE(measurement_time) ORDER BY measurement_time) as day2
  FROM measurements
)
SELECT
  DATE(t1.measurement_time),
  SUM(measurement_value) FILTER (WHERE (t1.day2 % 2) <> 0) AS odd_sum,
  SUM(measurement_value) FILTER (WHERE (t1.day2 % 2) = 0) AS even_sum
FROM t1
GROUP BY DATE(t1.measurement_time)
ORDER BY DATE(t1.measurement_time)