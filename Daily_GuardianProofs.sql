   SELECT
        DATE(evt_block_time) AS date,
        SUM(1) as guardian_proofs
    FROM taikoxyz_ethereum.TaikoL1_evt_TransitionProvedV2
    WHERE
        contract_address = 0x06a9ab27c7e2255df1815e6cc0168d7755feb19a
        AND (tier = 900 OR tier = 1000)
    AND evt_block_time >= CURRENT_TIMESTAMP - INTERVAL '365' day
    GROUP BY
      DATE(evt_block_time)
