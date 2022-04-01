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

let fail_if_not_admin (s: storage) : unit =
	if Tezos.source <> s.admin
    then (failwith op_not_admin : unit)
    else unit
    

(** 
Add data by first getting the current data_id,
adding the data and incrementing the data_id
*)
let add_data (p, s: add_param * storage) : storage =
    let { sensor_id = sensor_id; data = data } = p in
	let () = fail_if_not_admin s in
	let get_n_data_ids : nat = 
    	match Map.find_opt sensor_id s.n_data_ids with
        | None -> (failwith sensor_not_found : nat)
        | Some id -> id in
    let new_data = Map.add (sensor_id, get_n_data_ids) data s.sensor_ledger in
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
	let () = fail_if_not_admin s in
    if Map.mem sensor_id s.n_data_ids
    then (failwith sensor_already_exists : storage)
    else
   		let new_sensor = Map.add sensor_id 0n s.n_data_ids in
       { s with n_data_ids = new_sensor }

(**
Remove sensor by creating a list of all entries to remove
then folding it into a new map without those entries
and remove the n_data_ids of that sensor as well
*)
let remove_sensor (p, s: sensor_id * storage) : storage = 
    let sensor_id = p in
	let () = fail_if_not_admin s in	
	if not Map.mem sensor_id s.n_data_ids
	then (failwith sensor_not_found : storage) 
	else
		let removing_list : sensor_key list = [] in
		let to_remove : sensor_key list = 
			let folded (i, j: sensor_key list * ((sensor_id * data_id) * nat)) : sensor_key list =
				if j.0.0 = sensor_id then j.0 :: i else i in
			Map.fold folded s.sensor_ledger removing_list
			in
			let new_map = List.fold_left
							(fun (m, x: sensor_ledger * sensor_key) -> Map.remove x m) 
							s.sensor_ledger to_remove in
		let remove_data_id = Map.remove sensor_id s.n_data_ids in
		{ s with 
				sensor_ledger = new_map;
				n_data_ids    = remove_data_id }

let update_admin (p, s: address * storage) : storage =
	let new_admin = p in
	let () = fail_if_not_admin s in
    { s with admin = new_admin }

let withdraw (p, s: withdraw_param * storage) : return =
    let { tez_amt = tez_amt } = p in
	let () = fail_if_not_admin s in
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
    match Map.find_opt (sensor_id, data_id) s.sensor_ledger with
    | None -> (failwith sensor_not_found : nat)
    | Some d -> d

[@view] let get_sensor_ledger ((), s: unit * storage) : sensor_ledger = s.sensor_ledger
