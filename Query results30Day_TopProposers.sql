WITH proposers AS (
  SELECT
    DATE(evt_block_time) AS date,
    JSON_EXTRACT(meta, '$.sender') AS proposer
  FROM taikoxyz_ethereum.TaikoL1_evt_BlockProposed
  WHERE
    contract_address = 0x06a9ab27c7e2255df1815e6cc0168d7755feb19a
    AND evt_block_time >= CURRENT_TIMESTAMP - INTERVAL '30' day
)
SELECT
  proposer,
  COUNT(*) AS blocks_proposed
FROM proposers
GROUP BY proposer
ORDER BY blocks_proposed DESC
LIMIT 10;
