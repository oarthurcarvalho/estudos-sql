-- ======================================================================
--     Spotify Streaming History [Spotify SQL Interview Question]
-- ======================================================================

-- ** PREMIUM **

-- * Link: https://datalemur.com/questions/spotify-streaming-history

-- You are given a songs_history table that keeps track of users' listening history on Spotify. The songs_weekly
-- table tracks how many times users listened to each song for all days between August 1 and August 7, 2022.

-- Write a query to show the user ID, song ID, and the number of times the user has played each song as of
-- August 4, 2022. We'll refer to the number of song plays as song_plays. The rows with the most song plays should
-- be at the top of the output.

-- Assumption:

-- - The songs_history table holds data that ends on July 31, 2022. Output should include the historical data in
--   this table.
-- - There may be a new user in the weekly table who is not present in the history table.
-- - A user may listen to a song for the first time, in which case no existing (user_id, song_id) user-song pair
--   exists in the history table.
-- - A user may listen to a specific song multiple times in the same day.

WITH total_plays AS (
  SELECT
    user_id,
    song_id,
    song_plays
  FROM songs_history
  UNION ALL
  SELECT
    user_id,
    song_id,
    COUNT(song_id)
  FROM songs_weekly
  WHERE DATE(listen_time) <= '2022-08-04'
  GROUP BY user_id, song_id
)
SELECT 
  user_id,
  song_id,
  SUM(song_plays) AS song_plays
FROM total_plays
GROUP BY user_id, song_id
ORDER BY song_plays DESC;