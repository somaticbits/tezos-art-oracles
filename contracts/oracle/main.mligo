#include "./interface.mligo"
#include "./oracle.mligo"

let main (action, storage: parameter * storage) : return =
    match action with
    | Add_data p -> ([] : operation list), add_data (p, storage)
    | Add_sensor p -> ([] : operation list), add_sensor (p, storage)
    | Remove_sensor p -> ([] : operation list), remove_sensor (p, storage)
    | Update_admin p -> ([] : operation list), update_admin (p, storage)
    | Withdraw p -> withdraw (p, storage)