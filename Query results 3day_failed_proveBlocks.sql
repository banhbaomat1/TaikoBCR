SELECT
  call_block_time,
  "from" as prover,
  call_tx_hash
FROM taikoxyz_ethereum.TaikoL1_call_proveBlock as T1
INNER JOIN ethereum.transactions AS T2
  ON T1.call_tx_hash = T2.hash 
WHERE
  contract_address = 0x06a9ab27c7e2255df1815e6cc0168d7755feb19a
  AND call_success = FALSE
  AND call_block_time >= CURRENT_TIMESTAMP - INTERVAL '3' day
ORDER BY call_block_time DESC
LIMIT 25