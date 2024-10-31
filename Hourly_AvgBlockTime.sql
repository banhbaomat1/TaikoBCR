WITH table1 AS (
  SELECT
    evt_block_time,
    LAG(evt_block_time) OVER (ORDER BY evt_block_time) AS prev_evt_block_time,
    DATE_TRUNC('hour', evt_block_time) AS event_hour
  FROM taikoxyz_ethereum.TaikoL1_evt_BlockProposed
  WHERE
    evt_block_time >= CURRENT_TIMESTAMP - INTERVAL '3' day
), table2 AS (
  SELECT
    event_hour,
    AVG(EXTRACT(SECOND FROM (
      evt_block_time - prev_evt_block_time
    ))) AS taiko_blk_time
  FROM table1
  WHERE
    NOT prev_evt_block_time IS NULL
  GROUP BY
    event_hour
)
SELECT
  event_hour,
  AVG(taiko_blk_time) AS avg_taiko_blk_time
FROM table2
GROUP BY
  event_hour
ORDER BY
  event_hour
