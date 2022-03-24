let update_oracle (p, s: address * storage) : storage =
    if Tezos.source <> s.admin
    then (failwith "UNKNOWN_ADMIN" : storage)
    else
        {s with oracle_address = p}

let withdraw (p, s: withdraw_param * storage) : return =
    let { tez_amt = tez_amt } = p in
    if Tezos.source <> s.admin
    then (failwith "NOT_ADMIN" : return)
    else
        if Tezos.balance < tez_amt
        then (failwith "NOT_ENOUGH_BALANCE" : return)
        else
            let receiver : unit contract =
                match (Tezos.get_contract_opt s.admin : unit contract option) with
                | Some contract -> contract
                | None -> (failwith "NOT_A_CONTRACT" : unit contract) in
            [Tezos.transaction unit tez_amt receiver], s