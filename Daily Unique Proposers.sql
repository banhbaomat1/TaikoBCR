SELECT
  DATE(evt_block_time) AS date,
  COUNT(DISTINCT JSON_EXTRACT(meta, '$.sender')) AS unique_proposers
FROM taikoxyz_ethereum.TaikoL1_evt_BlockProposed
WHERE
  contract_address = 0x06a9ab27c7e2255df1815e6cc0168d7755feb19a
  AND evt_block_time >= CURRENT_TIMESTAMP - INTERVAL '365' day
GROUP BY
  DATE(evt_block_time)
