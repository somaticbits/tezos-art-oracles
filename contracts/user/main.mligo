#include "./interface.mligo"
#include "./utils.mligo"
#include "./data.mligo"

let main (action, storage: parameter * storage) : return =
    match action with
    | Get_data p -> ([] : operation list), get_data (p, storage)
    | Update_oracle p -> ([] : operation list), update_oracle (p, storage)
