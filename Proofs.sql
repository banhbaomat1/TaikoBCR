SELECT
  COALESCE((SELECT SUM(1)
   FROM taikoxyz_ethereum.TaikoL1_evt_TransitionProved), 0) AS transactions_proved,
  COALESCE((SELECT SUM(1)
   FROM taikoxyz_ethereum.TaikoL1_evt_TransitionContested), 0) AS transitions_contested
