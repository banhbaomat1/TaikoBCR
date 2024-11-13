WITH table1 AS (
  SELECT
    evt_block_time,
    LAG(evt_block_time) OVER (ORDER BY evt_block_time) AS prev_evt_block_time,
    date_trunc('day', evt_block_time) AS event_date
  FROM taikoxyz_ethereum.TaikoL1_evt_BlockProposed
  WHERE
    evt_block_time >= CURRENT_TIMESTAMP - INTERVAL '365' day
), table2 AS (
  SELECT
    event_date,
    AVG(EXTRACT(SECOND FROM (
      evt_block_time - prev_evt_block_time
    ))) AS taiko_blk_time
  FROM table1
  WHERE
    NOT prev_evt_block_time IS NULL
  GROUP BY
    event_date
)
SELECT
  event_date,
  AVG(taiko_blk_time) AS avg_taiko_blk_time
FROM table2
GROUP BY
  event_date
ORDER BY
  event_date
