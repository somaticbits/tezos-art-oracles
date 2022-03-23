let get_data (p, s: get_param * storage) : storage =
    let { parameter = { sensor_id = sensor_id; data_id = data_id }; addr = addr } = p in
    let new_data: nat option = Tezos.call_view "get_data" { sensor_id = sensor_id; data_id = data_id } addr in
    { s with data = new_data }                    
