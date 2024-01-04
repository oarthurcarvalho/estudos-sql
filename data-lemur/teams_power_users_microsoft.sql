-- ======================================================================
--          Teams Power Users [Microsoft SQL Interview Question]
-- ======================================================================

-- ** Link: https://datalemur.com/questions/teams-power-users

-- Write a query to identify the top 2 Power Users who sent the highest number of messages on Microsoft Teams
-- in August 2022. Display the IDs of these 2 users along with the total number of messages they sent. Output the
-- results in descending order based on the count of the messages.

-- Assumption:
-- - No two users have sent the same number of messages in August 2022.

SELECT
  sender_id,
  COUNT(message_id) AS message_count
FROM messages
WHERE 
  DATE_PART('month', sent_date) = 08 AND
  DATE_PART('year', sent_date) = 2022
GROUP BY sender_id
ORDER BY COUNT(message_id) DESC
LIMIT 2