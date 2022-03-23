type add_param = 
{
   sensor_id : nat;
   data      : nat; 
}

type get_param =
{
    sensor_id : nat;
    data_id   : nat;
}

// parameter type
type parameter =
    | Add_data of add_param
    | Update_admin of address

// storage type
type sensor_id     = nat
type data_id       = nat
type sensor_ledger = ((sensor_id * data_id), nat) big_map

type storage = 
{ 
    sensor_ledger : sensor_ledger;
    next_data_id  : nat;
    admin         : address 
}

type return = (operation list) * storage