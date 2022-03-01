type sensor_data = { name: string; data: int }
type sensor_ledger = (nat, sensor_data) big_map
type storage = { sensor_ledger : sensor_ledger;
                 admin : address }

type return = operation list * storage

type entrypoint =
| GetPrice of storage contract
| Update of sensor_data

let update (v, s: sensor_data * storage) : return =
    if Tezos.source <> s.admin
    then (failwith "NOT_ALLOWED" : return)
    else
        let new_storage = { s with sensor_ledger = Big_map.add 0n {name = v.name; data = v.data} s.sensor_ledger } in
    (([] : operation list), new_storage)

let get (u, s: storage contract * storage) : return =
    ([Tezos.transaction s 0tez u], s)

let updateAdmin (a, s: address * storage) : return =
    if Tezos.source <> s.admin
    then (failwith "NOT_ADMIN" : return)
    else
        let new_storage = { s with admin = a } in
    (([] : operation list), new_storage)

let main (p, s: entrypoint * storage) : return =
    match p with
    | GetPrice u -> get (u, s)
    | Update v -> update (v, s) 