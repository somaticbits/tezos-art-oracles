let update_oracle (p, s: address * storage) : storage =
    if Tezos.source <> s.admin
    then (failwith "UNKNOWN_ADMIN" : storage)
    else
        {s with oracle_address = p}
