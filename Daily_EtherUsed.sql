WITH 
proposing AS (
    SELECT
      DATE(block_time) AS date,
       SUM((value + gas_price * gas_used) / 1e18) AS proposeBlock_eth_fee
    FROM ethereum.transactions
    WHERE
      "from" = {{proposer_eoa}}
      AND block_time >= CURRENT_TIMESTAMP - INTERVAL '365' day
    GROUP BY
      DATE(block_time)
),
proving AS (
    SELECT
      DATE(block_time) AS date,
       SUM((value + gas_price * gas_used) / 1e18) AS proveBlock_eth_fee
    FROM ethereum.transactions
    WHERE
      "from" = {{prover_eoa}}
      AND block_time >= CURRENT_TIMESTAMP - INTERVAL '365' day
    GROUP BY
      DATE(block_time)
)

SELECT 
    COALESCE(a.date, b.date) AS date,
    COALESCE(a.proposeBlock_eth_fee, 0) AS proposeBlock_eth_fee,
    COALESCE(b.proveBlock_eth_fee, 0) AS proveBlock_eth_fee
FROM proposing a
FULL OUTER JOIN proving b ON a.date = b.date
