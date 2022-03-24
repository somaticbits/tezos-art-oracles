type get_param =
{
    sensor_id : nat;
    data_id   : nat;
}

type withdraw_param =
{
    tez_amt : tez;
}

// parameter type
type parameter = 
    | Get_data of get_param
    | Update_oracle of address
    | Withdraw of withdraw_param

// storage type
type storage = 
{
    oracle_address : address;
    admin          : address;
    data           : nat option;
}

type return = (operation list) * storage
