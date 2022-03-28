let get_data (p, s: get_param * storage) : storage =
    let new_data: nat option = Tezos.call_view "get_data" p s.oracle_address in
    { s with data = new_data }                    

let get_sensor_ledger ((), s: unit * storage) : sensor_ledger = 
	let new_ledger: sensor_ledger option = Tezos.call_view "get_sensor_ledger" s.oracle_address in
	{ s with sensor_ledger = new_ledger }
