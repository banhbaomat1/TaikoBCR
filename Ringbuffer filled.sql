WITH lastUpdate AS (
  SELECT
    evt_block_time,
    TRY_CAST(JSON_EXTRACT(slotB, '$.numBlocks') AS BIGINT) AS numBlocks,
    TRY_CAST(JSON_EXTRACT(slotB, '$.lastVerifiedBlockId') AS BIGINT) AS lastVerifiedBlockId
  FROM taikoxyz_ethereum.TaikoL1_evt_StateVariablesUpdated
  ORDER BY
    evt_block_time DESC
  LIMIT 1
)
SELECT
  numBlocks,
  lastVerifiedBlockId,
   (
   86400/TRY_CAST(numBlocks - lastVerifiedBlockId AS REAL)
  ) AS avgBlockTime,
  (
    numBlocks - lastVerifiedBlockId
  ) AS numPending,
  TRY_CAST(numBlocks - lastVerifiedBlockId AS REAL) *100/ 360000 AS numPendingPctg,
  LEAST(TRY_CAST(numBlocks AS REAL) *100/ 360000,100) AS pcgtToBufferReuse
FROM lastUpdate
