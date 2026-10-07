type get_param =
{
    sensor_id : nat;
    data_id   : nat;
}

type withdraw_param =
{
    tez_amt : tez;
}

type sensor_id  = nat
type data_id    = nat
type sensor_key = (sensor_id * data_id)

type sensor_ledger = (sensor_id, nat) map

// parameter type
type parameter = 
    | Get_data of get_param
	| Get_sensor_ledger of sensor_ledger
    | Update_oracle of address
    | Withdraw of withdraw_param

// storage type
type storage = 
{
    oracle_address : address;
    admin          : address;
    data           : nat option;
	sensor_ledger  : sensor_ledger
}

type return = (operation list) * storage
