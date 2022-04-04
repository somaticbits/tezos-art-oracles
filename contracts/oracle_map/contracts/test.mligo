#include "./partials/interface.mligo"
#include "./partials/oracle.mligo"

let main (action, storage: parameter * storage) : return =
    match action with
    | Add_data p 		-> ([] : operation list), add_data (p, storage)
    | Add_sensor p 		-> ([] : operation list), add_sensor (p, storage)
    | Remove_sensor p 	-> ([] : operation list), remove_sensor (p, storage)
    | Update_admin p 	-> ([] : operation list), update_admin (p, storage)
    | Withdraw p 		-> withdraw (p, storage)

let test_entrypoint (type a) (p, c: a * a contract) : bool =
	let () = match Test.transfer_to_contract a a contract  0tez with
		| Success nat -> true
		| Fail err ->
			begin
				match err with
				| Rejected rej -> let () = Test.log ("rejected", rej) in false
				| Other -> let () = Test.log "other" in false
			end
		in
	()

let test =
	let admin = Test.nth_bootstrap_account 0 in
	let user = Test.nth_bootstrap_account 1 in
	let () = Test.set_source admin in

	let initial_storage =
	{
		sensor_ledger = (Map.literal[(0n,0n),0n]); 
		n_data_ids 	  =	(Map.literal[(0n,0n)]);
		admin 		  = admin;
	} in
	let (taddr, _, _) = Test.originate main initial_storage 1tez in
	let contract_address = Tezos.address (Test.to_contract taddr) in
	let storage : storage = Test.get_storage taddr in
	let () = assert (storage = initial_storage) in

	// ADD_DATA entrypoint
	let () = Test.log("---------- Testing add_data entrypoint ----------") in
	let () = Test.log("Change source to user.") in
	let () = Test.set_source user in
	let add_param : add_param = { sensor_id = 0n; data = 123n } in
	let to_add : add_param contract = Test.to_entrypoint "add_data"	taddr in
	let () = Test.log("Expected to fail:") in
	let () = test_entrypoint add_param add_param to add in
	let () = Test.log("Change source to admin.") in
	let () = Test.set_source admin in
	let add_param : add_param = { sensor_id = 1n; data = 123n } in
	let to_add : add_param contract = Test.to_entrypoint "add_data"	taddr in
	let () = Test.log("Expected to fail:") in
	let _ = match Test.transfer_to_contract to_add add_param 0tez with
		| Success nat -> true
		| Fail err ->
			begin
				match err with
				| Rejected rej -> let () = Test.log ("rejected", rej) in false
				| Other -> let () = Test.log "other" in false
			end
	in
	let add_param : add_param = { sensor_id = 0n; data = 123n } in
	let to_add : add_param contract = Test.to_entrypoint "add_data"	taddr in
	let _ = match Test.transfer_to_contract to_add add_param 0tez with
		| Success nat -> let() = Test.log("Add_data operation successful") in true
		| Fail err ->
			begin
				match err with
				| Rejected rej -> let () = Test.log ("rejected", rej) in false
				| Other -> let () = Test.log "other" in false
			end
	in
	let storage : storage = Test.get_storage taddr in
	let data : nat = get_data ({ sensor_id = 0n; data_id = 0n }, storage) in
	let () = assert (data = 123n) in

	// ADD_SENSOR entrypoint
	let () = Test.log("---------- Testing add_sensor entrypoint ----------") in
	let () = Test.log("Change source to user.") in
	let () = Test.set_source user in
	let add_param : sensor_id = 1n in
	let to_add : sensor_id contract = Test.to_entrypoint "add_sensor" taddr in
	let () = Test.log("Expected to fail:") in
	let _ = match Test.transfer_to_contract to_add add_param 0tez with
		| Success nat -> true
		| Fail err ->
			begin
				match err with
				| Rejected rej -> let () = Test.log ("rejected", rej) in false
				| Other -> let () = Test.log "other" in false
			end
	in
	let () = Test.log("Change source to admin.") in
	let () = Test.set_source admin in
	let add_param : sensor_id = 0n in
	let to_add : sensor_id contract = Test.to_entrypoint "add_sensor" taddr in
	let () = Test.log("Expected to fail:") in
	let _ = match Test.transfer_to_contract to_add add_param 0tez with
		| Success nat -> true
		| Fail err ->
			begin
				match err with
				| Rejected rej -> let () = Test.log ("rejected", rej) in false
				| Other -> let () = Test.log "other" in false
			end
	in
	let add_param : sensor_id = 1n in
	let to_add : sensor_id contract = Test.to_entrypoint "add_sensor" taddr in
	let _ = match Test.transfer_to_contract to_add add_param 0tez with
		| Success nat -> let() = Test.log("Add_sensor operation successful") in true
		| Fail err ->
			begin
				match err with
				| Rejected rej -> let () = Test.log ("rejected", rej) in false
				| Other -> let () = Test.log "other" in false
			end
	in
	let storage : storage = Test.get_storage taddr in
	let () = assert (Map.mem 1n storage.n_data_ids) in

	// ADD_DATA and REMOVE_SENSOR entrypoint
	let () = Test.log("---------- Testing remove_sensor entrypoint ----------") in
	let () = Test.log("Change source to user.") in
	let () = Test.set_source user in
	let remove_param : sensor_id = 1n in
	let to_remove : sensor_id contract = Test.to_entrypoint "remove_sensor" taddr in
	let () = Test.log("Expected to fail:") in
	let _ = match Test.transfer_to_contract to_remove remove_param 0tez with
		| Success nat -> true
		| Fail err ->
			begin
				match err with
				| Rejected rej -> let () = Test.log ("rejected", rej) in false
				| Other -> let () = Test.log "other" in false
			end
	in
	let () = Test.log("Change source to admin.") in
	let () = Test.set_source admin in
	let remove_param : sensor_id = 2n in
	let to_remove : sensor_id contract = Test.to_entrypoint "remove_sensor" taddr in
	let () = Test.log("Expected to fail:") in
	let _ = match Test.transfer_to_contract to_remove remove_param 0tez with
		| Success nat -> true
		| Fail err ->
			begin
				match err with
				| Rejected rej -> let () = Test.log ("rejected", rej) in false
				| Other -> let () = Test.log "other" in false
			end
	in
	let add_param : add_param = { sensor_id = 1n; data = 123456n } in
	let to_add : add_param contract = Test.to_entrypoint "add_data"	taddr in
	let _ = match Test.transfer_to_contract to_add add_param 0tez with
		| Success nat -> let () = Test.log("Add_data operation successful") in true
		| Fail err ->
			begin
				match err with
				| Rejected rej -> let () = Test.log ("rejected", rej) in false
				| Other -> let () = Test.log "other" in false
			end
	in
	let remove_param : sensor_id = 1n in
	let to_remove : sensor_id contract = Test.to_entrypoint "remove_sensor" taddr in
	let _ = match Test.transfer_to_contract to_remove remove_param 0tez with
		| Success nat -> let () = Test.log("Remove_sensor operation successful") in true 
		| Fail err ->
			begin
				match err with
				| Rejected rej -> let () = Test.log ("rejected", rej) in false
				| Other -> let () = Test.log "other" in false
			end
	in
	let storage : storage = Test.get_storage taddr in
	let () = assert (not (Map.mem (1n,0n) storage.sensor_ledger)) in
	let () = assert (not (Map.mem 1n storage.n_data_ids)) in
	
	// UPDATE_ADMIN entrypoint:
	let () = Test.log("---------- Test update_admin entrypoint ----------") in
	let () = Test.log("Change source to user.") in
	let () = Test.set_source user in
	let update_param : address = user in
	let to_update : address contract = Test.to_entrypoint "update_admin" taddr in
	let () = Test.log("Expected to fail:") in
	let _ = match Test.transfer_to_contract to_update update_param 0tez with
		| Success nat -> true
		| Fail err ->
			begin
				match err with
				| Rejected rej -> let () = Test.log ("rejected", rej) in false
				| Other -> let () = Test.log "other" in false
			end
	in
	let () = Test.log("Change source to admin.") in
	let () = Test.set_source admin in
	let to_update : address contract = Test.to_entrypoint "update_admin" taddr in
	let _ = match Test.transfer_to_contract to_update update_param 0tez with
		| Success nat -> let () = Test.log("Update_admin operation successful") in true
		| Fail err ->
			begin
				match err with
				| Rejected rej -> let () = Test.log ("rejected", rej) in false
				| Other -> let () = Test.log "other" in false
			end
	in	
	let storage : storage = Test.get_storage taddr in
	let () = assert (user = storage.admin) in

	()
