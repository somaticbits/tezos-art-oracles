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

(** Operation failed because transaction included tez *)
let not_zero_tez = "NOT_ZERO_TEZ"

let fail_if_not_admin (s: storage) : unit =
	if Tezos.source <> s.admin
    then (failwith op_not_admin : unit)
    else unit

let fail_if_any_tez_amt (s: storage) : unit =
	if Tezos.amount > 0tz
	then (failwith not_zero_tez : unit)
	else unit
    
(** 
Add data by updating the sensor_ledger big_map
*)
let add_data (p, s: add_param * storage) : storage =
    let { sensor_id = sensor_id; data = data } = p in
    let () = fail_if_not_admin s in
	let () = fail_if_any_tez_amt s in
	if not Big_map.mem sensor_id s.sensor_ledger
	then (failwith sensor_not_found : storage)
    else
       	let new_data = Big_map.update sensor_id (Some data) s.sensor_ledger in
       	{ s with sensor_ledger = new_data }

(**
Check first if sensor already exists,
if not, add to sensor_ledger
*) 
let add_sensor (p, s: sensor_id * storage) : storage =
    let sensor_id = p in
	let () = fail_if_not_admin s in
	let () = fail_if_any_tez_amt s in
    if Big_map.mem sensor_id s.sensor_ledger
    then (failwith sensor_already_exists : storage)
    else
    	let new_sensor = Map.add sensor_id 0n s.sensor_ledger in
     	{ s with sensor_ledger = new_sensor }

(**
Remove sensor by removing key from sensor_ledger 
*)
let remove_sensor (p, s: sensor_id * storage) : storage =
	let sensor_id = p in
	let () = fail_if_not_admin s in
	let () = fail_if_any_tez_amt s in
	if not Big_map.mem sensor_id s.sensor_ledger
	then (failwith sensor_not_found : storage)
    else
    	let new_map = Map.remove sensor_id s.sensor_ledger in
		{ s with sensor_ledger = new_map }

let update_admin (p, s: address * storage) : storage =
	let new_admin = p in
	let () = fail_if_not_admin s in
	let () = fail_if_any_tez_amt s in
    { s with admin = new_admin }

let withdraw (p, s: withdraw_param * storage) : return =
    let { tez_amt = tez_amt } = p in
	let () = fail_if_not_admin s in
    let receiver : unit contract =
        match (Tezos.get_contract_opt s.admin : unit contract option) with
       	| None -> (failwith not_contract : unit contract) 
        | Some contract -> contract in
    [Tezos.transaction unit tez_amt receiver], s

[@view] let get_data (p, s: get_param * storage) : nat =
    let { sensor_id = sensor_id } = p in
    match Big_map.find_opt sensor_id s.sensor_ledger with
    | None -> (failwith sensor_not_found : nat)
    | Some d -> d

