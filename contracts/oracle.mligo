type storage = nat

type return = operation list * storage

type update = 
| Store of nat

type action =
| GetPrice of nat contract
| Update of nat

let update (value, _storage: nat * storage) : return =
    (([] : operation list), value)

let get (u, storage: nat contract * storage) : return =
    ([Tezos.transaction storage 0tez u], storage)

let main (entrypoint, storage: action * storage) : return =
    match entrypoint with
    | GetPrice _u -> get (_u, storage)
    | Update _v   -> update (_v, storage) 