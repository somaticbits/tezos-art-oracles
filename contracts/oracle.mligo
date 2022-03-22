type sensor_data_ledger = (timestamp, nat) big_map
type sensor_registry = { sensor_data_ledger : sensor_data_ledger;
                         sensor_id : nat }
type storage = { sensor_registry : sensor_registry;
                 admin : address }

type return = operation list * storage

type entrypoint =
| GetPrice of storage contract
| Add of nat

let add (data, s: nat * storage) : return =
    if Tezos.source <> s.admin
    then (failwith "NOT_ALLOWED" : return)
    else
        let new_storage = { s with sensor_registry.sensor_data_ledger = Big_map.add Tezos.now data s.sensor_registry.sensor_data_ledger } in
    (([] : operation list), new_storage)

let get (u, s: storage contract * storage) : return =
    ([Tezos.transaction s 0tez u], s)

let updateAdmin (addr, s: address * storage) : return =
    if Tezos.source <> s.admin
    then (failwith "NOT_ADMIN" : return)
    else
        let new_storage = { s with admin = addr } in
    (([] : operation list), new_storage)

let main (p, s: entrypoint * storage) : return =
    match p with
    | GetPrice u -> get (u, s)
    | Add v -> add (v, s) 