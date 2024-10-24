WITH 
proposing AS (
    SELECT
      DATE(evt_block_time) AS date,
      COUNT(1) AS blocks_proposed
    FROM taikoxyz_ethereum.TaikoL1_evt_BlockProposed
    WHERE
      contract_address = 0x06a9ab27c7e2255df1815e6cc0168d7755feb19a
      AND evt_block_time >= CURRENT_TIMESTAMP - INTERVAL '365' day
    GROUP BY
      DATE(evt_block_time)
),
proving AS (
    SELECT
        DATE(evt_block_time) AS date,
        COUNT(1) AS transition_proved
    FROM taikoxyz_ethereum.TaikoL1_evt_TransitionProved
    WHERE
        contract_address = 0x06a9ab27c7e2255df1815e6cc0168d7755feb19a
    AND evt_block_time >= CURRENT_TIMESTAMP - INTERVAL '365' day
    GROUP BY
      DATE(evt_block_time)
),
contesting AS (
    SELECT
      DATE(evt_block_time) AS date,
      COUNT(1) AS transition_contested
    FROM taikoxyz_ethereum.TaikoL1_evt_TransitionContested
    WHERE
      contract_address = 0x06a9ab27c7e2255df1815e6cc0168d7755feb19a
      AND evt_block_time >= CURRENT_TIMESTAMP - INTERVAL '365' day
    GROUP BY
      DATE(evt_block_time)
),
statevars AS (
    SELECT
      date,
      AVG(numBlocks - lastVerifiedBlockId) AS num_pending_blocks
    FROM (
        SELECT
          DATE(evt_block_time) AS date,
          CAST(JSON_EXTRACT(slotB, '$.numBlocks') AS BIGINT) AS numBlocks,
          CAST(JSON_EXTRACT(slotB, '$.lastVerifiedBlockId') AS BIGINT) AS lastVerifiedBlockId
        FROM taikoxyz_ethereum.TaikoL1_evt_StateVariablesUpdated
        WHERE
          contract_address = 0x06a9ab27c7e2255df1815e6cc0168d7755feb19a
          AND evt_block_time >= CURRENT_TIMESTAMP - INTERVAL '365' day
    )  GROUP BY date
)

SELECT 
    COALESCE(a.date, b.date, c.date) AS date,
    COALESCE(a.blocks_proposed, 0) AS blocks_proposed,
    COALESCE(b.transition_proved, 0) AS transition_proved,
    COALESCE(c.transition_contested, 0) AS transition_contested,
    COALESCE(d.num_pending_blocks, 0) AS num_pending_blocks
FROM proposing a
FULL OUTER JOIN proving b ON a.date = b.date
FULL OUTER JOIN contesting c ON COALESCE(a.date, b.date) = c.date
FULL OUTER JOIN statevars d ON COALESCE(a.date, b.date, d.date) = d.date;
