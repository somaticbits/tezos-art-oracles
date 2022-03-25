let add_data (p, s: add_param * storage) : storage =
    let { sensor_id = sensor_id; data = data } = p in
    if Tezos.source <> s.admin
    then (failwith "NOT_ALLOWED" : storage)
    else
        let get_next_data_id : nat = 
            match Map.find_opt sensor_id s.next_data_id with
            | None -> (failwith "SENSOR_NOT_FOUND" : nat)
            | Some id -> id in
        let new_data = Map.add (sensor_id, get_next_data_id) data s.sensor_ledger in
        let increment_data_id = Map.update sensor_id (Some (get_next_data_id + 1n)) s.next_data_id in
        { s with 
                sensor_ledger = new_data;
                next_data_id  = increment_data_id }

let add_sensor (p, s: sensor_id * storage) : storage =
    let sensor_id = p in
    if Tezos.source <> s.admin
    then (failwith "NOT_ALLOWED" : storage)
    else
        if Map.mem sensor_id s.next_data_id
        then (failwith "SENSOR_ALREADY_EXISTS" : storage)
        else
            let new_sensor = Map.add sensor_id 0n s.next_data_id in
            { s with next_data_id = new_sensor }

// remove sensor by creating a list of all entries to remove
// then folding it into a new map without those entries
// and remove the next_data_id of that sensor as well
let remove_sensor (p, s: sensor_id * storage) : storage = 
    let sensor_id = p in
    if Tezos.source <> s.admin
    then (failwith "NOT_ALLOWED" : storage)
    else
		if not Map.mem sensor_id s.next_data_id
		then (failwith "SENSOR_NOT_FOUND" : storage) 
		else
			let removing_list : sensor_key list = [] in
			let to_remove : sensor_key list = 
				let folded (i, j: sensor_key list * ((sensor_id * data_id) * nat)) : sensor_key list =
					if j.0.0 = sensor_id
					then j.0 :: i
					else i in
					Map.fold folded s.sensor_ledger removing_list in

			let new_map = List.fold_left
							(fun ((m, x: sensor_ledger * sensor_key)) -> Map.remove x m) s.sensor_ledger to_remove in
			{ s with 
					sensor_ledger = new_map;
					next_data_id  = Map.remove sensor_id s.next_data_id }


let update_admin (p, s: address * storage) : storage =
    if Tezos.source <> s.admin
    then (failwith "NOT_ALLOWED" : storage)
    else
        { s with admin = p }

let withdraw (p, s: withdraw_param * storage) : return =
    let { tez_amt = tez_amt } = p in
    if Tezos.source <> s.admin
    then (failwith "NOT_ALLOWED" : return)
    else
        if Tezos.balance < tez_amt
        then (failwith "NOT_ENOUGH_BALANCE" : return)
        else
            let receiver : unit contract =
                match (Tezos.get_contract_opt s.admin : unit contract option) with
                | None -> (failwith "NOT_A_CONTRACT" : unit contract) 
                | Some contract -> contract in
            [Tezos.transaction unit tez_amt receiver], s

[@view] let get_data (p, s: get_param * storage) : nat =
    let { sensor_id = sensor_id; data_id = data_id } = p in
    match Map.find_opt (sensor_id, data_id) s.sensor_ledger with
    | None -> (failwith "NOT_FOUND" : nat)
    | Some d -> d
