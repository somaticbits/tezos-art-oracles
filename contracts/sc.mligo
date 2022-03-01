type storage = {
    oracleAddress : address;
    admin : address;
    price : nat
}

type return = operation list * storage

type action = 
| GetData of unit
| HandleCallback of nat
| UpdateOracle of address

let getData (storage : storage) : return =
    let oracle : nat contract contract = 
        match (Tezos.get_entrypoint_opt "%getPrice" storage.oracleAddress : nat contract contract option) with
        | None -> (failwith "ORACLE_NOT_FOUND" : nat contract contract)
        | Some contract -> contract in
    let param : nat contract =
        match (Tezos.get_entrypoint_opt "%handleCallback" Tezos.self_address : nat contract option) with
        | None -> (failwith "CALLBACK_NOT_FOUND" : nat contract)
        | Some param -> param in
    ([Tezos.transaction param 0tez oracle], storage)

let handleCallback (price, storage : nat * storage) : return = 
    if Tezos.sender <> storage.oracleAddress
    then (failwith "UNKNOWN_SENDER" : operation list * storage)
    else 
        let new_storage = {storage with price = price} in
    (([] : operation list), new_storage)

let updateOracle (n, storage : address * storage) : return =
    if Tezos.source <> storage.admin
    then (failwith "UNKNOWN_ADMIN" : operation list * storage)
    else
        let new_storage = {storage with oracleAddress = n} in
    (([] : operation list), new_storage)

let main (entrypoint, storage: action * storage) : return =
    match entrypoint with
    | GetData -> getData (storage)
    | HandleCallback p -> handleCallback (p, storage)
    | UpdateOracle n -> updateOracle (n, storage)
        