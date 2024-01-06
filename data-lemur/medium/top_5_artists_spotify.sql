-- ======================================================================
--            Top 5 Artists [Spotify SQL Interview Question]
-- ======================================================================

-- * Link: https://datalemur.com/questions/top-fans-rank

-- Assume there are three Spotify tables: artists, songs, and global_song_rank, which contain information about
-- the artists, songs, and music charts, respectively.

-- Write a query to find the top 5 artists whose songs appear most frequently in the Top 10 of the global_song_rank
-- table. Display the top 5 artist names in ascending order, along with their song appearance ranking.

-- If two or more artists have the same number of song appearances, they should be assigned the same ranking, and
-- the rank numbers should be continuous (i.e. 1, 2, 2, 3, 4, 5). If you've never seen a rank order like this 
-- before, do the rank window function tutorial.

WITH top_10_cte AS (
  SELECT 
    a.artist_name,
    DENSE_RANK() OVER ( ORDER BY COUNT(s.song_id) DESC) AS artist_rank
  FROM artists a
    INNER JOIN songs s ON a.artist_id = s.artist_id
    INNER JOIN global_song_rank gsr ON s.song_id = gsr.song_id
  WHERE gsr.rank <= 10
  GROUP BY a.artist_name
)
SELECT artist_name, artist_rank
FROM top_10_cte
WHERE artist_rank <= 5;