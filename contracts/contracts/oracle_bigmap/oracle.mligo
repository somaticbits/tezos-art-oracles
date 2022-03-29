(** TODO: check data and sensor_id size to avoid having long numbers and avoid storage issues *)

(** Operation failed because `Tezos.source <> s.admin` *)
let op_not_admin = "NOT_ADMIN"

(** Sensor not found in storage *)
let sensor_not_found = "SENSOR_NOT_FOUND"

(** Sensor already exists in storage *)
let sensor_already_exists = "SENSOR_ALREADY_EXISTS"

(** Operation failed because there's not enough Tez in contract *)
let not_enough_balance = "NOT_ENOUGH_BALANCE"

(** Operation failed because provided account is not a contract *)
let not_contract = "NOT_CONTRACT"

(** 
Add data by first getting the current data_id,
adding the data and incrementing the data_id
*)
let add_data (p, s: add_param * storage) : storage =
    let { sensor_id = sensor_id; data = data } = p in
    if Tezos.source <> s.admin
    then (failwith op_not_admin : storage)
    else
        let get_n_data_ids : nat = 
            match Map.find_opt sensor_id s.n_data_ids with
            | None -> (failwith sensor_not_found : nat)
            | Some id -> id in
        let new_data = Big_map.add (sensor_id, get_n_data_ids) data s.sensor_ledger in
        let increment_data_id = Map.update sensor_id (Some (get_n_data_ids + 1n)) s.n_data_ids in
        { s with 
                sensor_ledger = new_data;
                n_data_ids    = increment_data_id }

(**
Check first if sensor already exists,
else add it to the n_data_ids map
*) 
let add_sensor (p, s: sensor_id * storage) : storage =
    let sensor_id = p in
    if Tezos.source <> s.admin
    then (failwith op_not_admin : storage)
    else
        if Map.mem sensor_id s.n_data_ids
        then (failwith sensor_already_exists : storage)
        else
            let new_sensor = Map.add sensor_id 0n s.n_data_ids in
            { s with n_data_ids = new_sensor }

(**
Remove sensor by removing the incremental data_id in the
sensor_key recursively from 0n to len(data_ids) and creating
a new map out of that
*)
let remove_sensor (p, s: sensor_id * storage) : storage =
	let sensor_id = p in
	if Tezos.source <> s.admin
	then (failwith op_not_admin : storage)
	else
		let rec remove_values (sensor_key, last_sensor_key, sensor_ledger: sensor_key * sensor_key * sensor_ledger) : sensor_ledger = 
		if sensor_key.1 > last_sensor_key.1
		then sensor_ledger
		else
			let new_sensor_ledger = Big_map.update sensor_key (None: nat option) sensor_ledger in
			let new_sensor_key = (sensor_key.0, sensor_key.1 + 1n) in
			remove_values (new_sensor_key, last_sensor_key, new_sensor_ledger) in
		let get_n_data_ids : nat = 
            match Map.find_opt sensor_id s.n_data_ids with
            | None -> (failwith sensor_not_found : nat)
            | Some id -> id in 
        let new_map = remove_values ((sensor_id, 0n), (sensor_id, get_n_data_ids), s.sensor_ledger) in
		let remove_data_id = Map.remove sensor_id s.n_data_ids in
		{ s with 
				sensor_ledger = new_map;
				n_data_ids 	  = remove_data_id }

let update_admin (p, s: address * storage) : storage =
	let new_admin = p in
    if Tezos.source <> s.admin
    then (failwith op_not_admin : storage)
    else
        { s with admin = new_admin }

let withdraw (p, s: withdraw_param * storage) : return =
    let { tez_amt = tez_amt } = p in
    if Tezos.source <> s.admin
    then (failwith op_not_admin : return)
    else
        if Tezos.balance < tez_amt
        then (failwith not_enough_balance : return)
        else
            let receiver : unit contract =
                match (Tezos.get_contract_opt s.admin : unit contract option) with
                | None -> (failwith not_contract : unit contract) 
                | Some contract -> contract in
            [Tezos.transaction unit tez_amt receiver], s

[@view] let get_data (p, s: get_param * storage) : nat =
    let { sensor_id = sensor_id; data_id = data_id } = p in
    match Big_map.find_opt (sensor_id, data_id) s.sensor_ledger with
    | None -> (failwith sensor_not_found : nat)
    | Some d -> d

