select 
    address
    ,balance
from tokens_ethereum.balances_daily
where address = {{prover_eoa}} and day = date_trunc('day', now())
    and token_standard = 'native'
