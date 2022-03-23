#include "./interface.mligo"
#include "./oracle.mligo"

let main (action, storage: parameter * storage) : return =
    match action with
    | Add_data p -> ([] : operation list), add_data (p, storage)
    | Update_admin p -> ([] : operation list), update_admin (p, storage)