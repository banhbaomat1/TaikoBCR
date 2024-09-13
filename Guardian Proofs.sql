    SELECT
        COUNT(1) as num_guardian_proofs
    FROM taikoxyz_ethereum.TaikoL1_evt_TransitionProved
    WHERE
        contract_address = 0x06a9ab27c7e2255df1815e6cc0168d7755feb19a
        AND (tier = 900 OR tier = 1000);
