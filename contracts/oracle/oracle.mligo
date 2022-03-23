let add_data (p, s: add_param * storage) : storage =
    let { sensor_id = sensor_id; data = data } = p in
    if Tezos.source <> s.admin
    then (failwith "NOT_ALLOWED" : storage)
    else
        let new_data = Big_map.add (sensor_id, s.next_data_id) data s.sensor_ledger in
        { s with 
                sensor_ledger  = new_data;
                next_data_id = s.next_data_id + 1n }

[@view] let get_data (p, s: get_param * storage) : nat =
    let { sensor_id = sensor_id; data_id = data_id } = p in
    match Big_map.find_opt (sensor_id, data_id) s.sensor_ledger with
    | None -> (failwith "NOT_FOUND" : nat)
    | Some d -> d

let update_admin (p, s: address * storage) : storage =
    if Tezos.source <> s.admin
    then (failwith "NOT_ADMIN" : storage)
    else
        { s with admin = p }
