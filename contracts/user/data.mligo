let get_data (p, s: get_param * storage) : storage =
    let new_data: nat option = Tezos.call_view "get_data" p s.oracle_address in
    { s with data = new_data }                    
