WITH 
proposing AS (
    SELECT
      DATE(call_block_time) AS date,
      COUNT(1) AS num_failed_proposeBlocks
    FROM taikoxyz_ethereum.TaikoL1_call_proposeBlock as T1
    WHERE
      contract_address = 0x06a9ab27c7e2255df1815e6cc0168d7755feb19a
      AND call_success = FALSE
      AND call_block_time >= CURRENT_TIMESTAMP - INTERVAL '365' day
    GROUP BY
      DATE(call_block_time)
),
proving AS (
    SELECT
      DATE(call_block_time) AS date,
      COUNT(1) AS num_failed_proveBlocks
    FROM taikoxyz_ethereum.TaikoL1_call_proveBlock as T1
    WHERE
      contract_address = 0x06a9ab27c7e2255df1815e6cc0168d7755feb19a
      AND call_success = FALSE
      AND call_block_time >= CURRENT_TIMESTAMP - INTERVAL '365' day
    GROUP BY
      DATE(call_block_time)
)

SELECT 
    COALESCE(a.date, b.date) AS date,
    COALESCE(a.num_failed_proposeBlocks, 0) AS num_failed_proposeBlock,
    COALESCE(b.num_failed_proveBlocks, 0) AS num_failed_proveBlock
FROM proposing a
FULL OUTER JOIN proving b ON a.date = b.date
